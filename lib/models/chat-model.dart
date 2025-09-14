// models/chat-model.dart
import 'package:chatthing/models/message-model.dart';

class Chat {
  final String id;
  final String name;
  final List<Message> messages;
  final bool isBot; // مشخصه جدید برای شناسایی ربات

  Chat({
    required this.id,
    required this.name,
    required this.messages,
    this.isBot = false, // مقدار پیش‌فرض
  });
}