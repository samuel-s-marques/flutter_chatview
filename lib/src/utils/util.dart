import 'package:chatview/src/values/enumaration.dart';

MessageType getMessageTypeFromJson(String type) {
  switch (type) {
    case 'text':
      return MessageType.text;
    case 'image':
      return MessageType.image;
    case 'voice':
      return MessageType.voice;
    default:
      return MessageType.text;
  }
}

MessageStatus getMessageStatusFromJson(String status) {
  switch (status) {
    case 'read':
      return MessageStatus.read;
    case 'delivered':
      return MessageStatus.delivered;
    case 'undelivered':
      return MessageStatus.undelivered;
    default:
      return MessageStatus.pending;
  }
}
