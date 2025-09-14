// controllers/group-list-controller.dart
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:chatthing/models/group-model.dart';
import 'package:chatthing/models/user-model.dart';

class GroupListController extends GetxController {
  final _uuid = const Uuid();

  late final List<Group> groupList;

  GroupListController() {
    groupList = [
      Group(
        id: _uuid.v4(),
        name: 'گروه تست',
        lastMessage: 'You: Perfect, thanks!',
        time: '1 hour',
        members: [
          User(id: _uuid.v4(), name: 'Me', type: UserType.me),
          User(id: _uuid.v4(), name: 'Samantha'),
          User(id: _uuid.v4(), name: 'John Doe'),
          User(id: _uuid.v4(), name: 'Design Team'),
        ],
      ),
    ];
  }
}