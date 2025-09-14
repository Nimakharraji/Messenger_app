// screens/chat-list-view.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chatthing/controllers/chat-list-controller.dart';
import 'package:chatthing/controllers/main-controller.dart';
import 'package:chatthing/models/chat-model.dart';
import 'package:chatthing/models/message-model.dart';
import 'package:chatthing/screens/chat-screen.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatListController controller = Get.find();
    final MainController mainController = Get.find();

    return Obx(
      () => AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.chatList.length,
          itemBuilder: (context, index) {
            final chat = controller.chatList[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Obx(() {
                    // ignore: unused_local_variable
                    final ticker = mainController.timestampTicker.value;
                    // ignore: unused_local_variable
                    if (chat.messages.isEmpty) {
                      return _buildEmptyChatItem(context, chat);
                    } else {
                      return _buildChatItem(context, chat);
                    }
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyChatItem(BuildContext context, Chat chat) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatScreen(chat: chat),
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 85,
          borderRadius: 20,
          blur: 15,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.5),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.smart_toy_outlined, color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No messages yet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, Chat chat) {
    final Message lastMessage = chat.messages.last;
    final String messageText =
        lastMessage.isSentByMe ? "You: ${lastMessage.text}" : lastMessage.text;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatScreen(chat: chat),
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 85,
          borderRadius: 20,
          blur: 15,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.5),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.smart_toy_outlined, color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        messageText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  timeago.format(lastMessage.date),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
