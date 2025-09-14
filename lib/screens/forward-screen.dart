// screens/forward_screen.dart
import 'package:chatthing/controllers/chat-list-controller.dart';
import 'package:chatthing/controllers/group-list-controller.dart';
import 'package:chatthing/models/chat-model.dart';
import 'package:chatthing/models/message-model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForwardScreen extends StatefulWidget {
  final Message messageToForward;
  const ForwardScreen({super.key, required this.messageToForward});

  @override
  State<ForwardScreen> createState() => _ForwardScreenState();
}

class _ForwardScreenState extends State<ForwardScreen> {
  final ChatListController chatController = Get.find();
  final GroupListController groupController = Get.find();
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    // یک لیست ترکیبی از چت‌ها، جداکننده و گروه‌ها می‌سازیم
    final List<dynamic> allTargets = [
      ...chatController.chatList,
      if (groupController.groupList.isNotEmpty) 'Groups', // جداکننده
      ...groupController.groupList,
    ];

    return Scaffold(
      floatingActionButton:
          _selectedIds.isNotEmpty
              ? FloatingActionButton(
                onPressed: () {
                  for (var id in _selectedIds) {
                    // فقط برای چت‌های شخصی پیام فوروارد می‌شود
                    if (chatController.chatList.any((chat) => chat.id == id)) {
                      chatController.forwardMessage(
                        id,
                        widget.messageToForward,
                      );
                    }
                  }
                  Get.back();
                  Get.snackbar(
                    "Success",
                    "${_selectedIds.length} message(s) forwarded!",
                    colorText: Colors.white,
                    backgroundColor: Colors.black45,
                    margin: const EdgeInsets.all(10),
                  );
                },
                backgroundColor: const Color(0xff8e2de2),
                child: const Icon(Icons.send, color: Colors.white),
              )
              : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4b1e6e), Color(0xff1e123a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text("Forward to..."),
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = allTargets[index];
                // اگر آیتم از نوع رشته بود، جداکننده را نمایش بده
                if (item is String) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),
                  );
                }

                // در غیر این صورت، آیتم چت یا گروه را نمایش بده
                final String id = item.id;
                final String name = item.name;
                final IconData icon = item is Chat ? Icons.person : Icons.group;
                final isSelected = _selectedIds.contains(id);

                return ListTile(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIds.remove(id);
                      } else {
                        _selectedIds.add(id);
                      }
                    });
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(icon, color: Colors.white70),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check_circle,
                            color: Colors.deepPurpleAccent,
                          )
                          : const Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.white54,
                          ),
                );
              }, childCount: allTargets.length),
            ),
          ],
        ),
      ),
    );
  }
}
