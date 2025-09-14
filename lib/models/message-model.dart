// models/message_model.dart
class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  final Message? repliedTo;
  final bool isForwarded;

  Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
    this.repliedTo,
    this.isForwarded = false, 
  });
}