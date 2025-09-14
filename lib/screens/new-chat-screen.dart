// screens/new-chat-screen.dart
import 'package:chatthing/service/contact-service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatthing/controllers/chat-list-controller.dart';
import 'package:chatthing/screens/chat-screen.dart';

class NewChatScreen extends StatelessWidget {
  NewChatScreen({super.key});

  final ContactService contactService = ContactService();
  final ChatListController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    final allUsers = contactService.allUsers;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff4b1e6e), Color(0xff1e123a)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text("New Chat"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final user = allUsers[index];
                  return ListTile(
                    onTap: () {
                      final chat = chatController.findOrCreateChatWithUser(user);
                      Get.off(() => ChatScreen(chat: chat));
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white70),
                    ),
                    title: Text(user.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text("Available",
                        style: TextStyle(color: Colors.white60)),
                  );
                },
                childCount: allUsers.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}