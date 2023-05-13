import 'package:chatview/src/widgets/sliding_gradient_transform.dart';
import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    this.child,
  });

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController shimmerController;

  @override
  void initState() {
    super.initState();

    shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: 1000),
      );
  }

  @override
  void dispose() {
    shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
        colors: const [
          Color(0xFFD7D7D7),
          Color(0xFFC7C7C7),
          Color(0xFFD7D7D7),
        ],
        stops: const [
          0.1,
          0.3,
          0.4,
        ],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
        transform: SlidingGradientTransform(slidePercent: shimmerController.value),
      );

  bool get isSized {
    if (context.findRenderObject() != null) {
      return (context.findRenderObject()! as RenderBox).hasSize;
    } else {
      return false;
    }
  }

  Size get size => (context.findRenderObject()! as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final RenderBox shimmerBox = context.findRenderObject()! as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isShowing,
    required this.child,
  });

  final bool isShowing;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => ShimmerLoadingState();
}

class ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (shimmerChanges != null) {
      shimmerChanges!.removeListener(onShimmerChange);
    }
    shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (shimmerChanges != null) {
      shimmerChanges!.addListener(onShimmerChange);
    }
  }

  @override
  void dispose() {
    shimmerChanges?.removeListener(onShimmerChange);
    super.dispose();
  }

  void onShimmerChange() {
    if (widget.isShowing) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isShowing) {
      return widget.child;
    }

    final ShimmerState shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      return const SizedBox();
    }

    final Size shimmerSize = shimmer.size;
    final LinearGradient gradient = shimmer.gradient;
    final Offset offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject()! as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
