// models/group_model.dart

import 'package:chatthing/models/user-model.dart';

class Group {
  final String id; // آیدی اضافه شد
  final String name;
  final String lastMessage;
  final String time;
  final List<User> members;

  Group({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.members,
  });
}