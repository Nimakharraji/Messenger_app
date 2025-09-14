// models/user-model.dart
enum UserType { me, other }

class User {
  final String id;
  final String name;
  final UserType type;

  User({required this.id, required this.name, this.type = UserType.other});
}