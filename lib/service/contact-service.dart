// services/contact-service.dart
import 'package:chatthing/models/user-model.dart';
import 'package:uuid/uuid.dart';

class ContactService {
  final _uuid = const Uuid();

  late final List<User> _allUsers;

  ContactService() {
    _allUsers = [
      User(id: _uuid.v4(), name: 'Samantha'),
      User(id: _uuid.v4(), name: 'John Doe'),
      // دو کاربر جدید
      User(id: _uuid.v4(), name: 'Alex Morgan'),
      User(id: _uuid.v4(), name: 'Maria Smith'),
    ];
  }

  List<User> get allUsers => _allUsers;

  User? findUserById(String id) {
    try {
      return _allUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}