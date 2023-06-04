import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PatternStyle {
  const PatternStyle({
    required this.name,
    required this.from,
    required this.regExp,
    required this.replace,
    this.textStyle,
  });

  final String name;
  final Pattern from;
  final RegExp regExp;
  final String replace;
  final TextStyle? textStyle;

  String get pattern => regExp.pattern;

  static PatternStyle get bold => PatternStyle(
        name: 'bold',
        from: RegExp('(\\*\\*|\\*)'),
        regExp: RegExp('(\\*\\*|\\*)(.*?)(\\*\\*|\\*)'),
        replace: '',
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      );

  static PatternStyle get code => PatternStyle(
        name: "code",
        from: '`',
        regExp: RegExp('`(.*?)`'),
        replace: '',
        textStyle: TextStyle(
          fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
        ),
      );

  static PatternStyle get italic => PatternStyle(
        name: 'italic',
        from: '_',
        regExp: RegExp('_(.*?)_'),
        replace: '',
        textStyle: const TextStyle(fontStyle: FontStyle.italic),
      );

  static PatternStyle get lineThrough => PatternStyle(
        name: 'linethrough',
        from: '~',
        regExp: RegExp('~(.*?)~'),
        replace: '',
        textStyle: const TextStyle(decoration: TextDecoration.lineThrough),
      );
  static PatternStyle get spoiler => PatternStyle(
        name: 'spoiler',
        from: '||',
        regExp: RegExp(r'\|\|(.*?)\|\|'),
        replace: '',
      );
}
