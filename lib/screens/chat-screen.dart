// screens/chat-screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:chatthing/controllers/chat-list-controller.dart';
import 'package:chatthing/controllers/chat-screen-controller.dart';
import 'package:chatthing/models/chat-model.dart';
import 'package:chatthing/widgets/chat-bubble.dart';
import 'package:chatthing/widgets/glowing-send-button.dart'; 

bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String _formatDateSeparator(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCompare = DateTime(date.year, date.month, date.day);

  if (dateToCompare == today) {
    return 'TODAY';
  } else if (dateToCompare == yesterday) {
    return 'YESTERDAY';
  } else {
    return DateFormat('MMMM d, y').format(date);
  }
}

class ChatScreen extends StatelessWidget {
  final Chat chat;
  const ChatScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final ChatScreenController controller = Get.put(ChatScreenController());
    controller.setChatId(chat.id);
    final ChatListController chatListController = Get.find();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4b1e6e), Color(0xff1e123a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(context, controller),
            Expanded(
              child: Obx(() {
                final currentChat = chatListController.chatList
                    .firstWhere((c) => c.id == chat.id);
                final messages = currentChat.messages;
                // بعد از پیدا کردن پیام‌ها، به پایین اسکرول می‌کنیم
                controller.scrollToBottom();
                return AnimationLimiter(
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      bool showDateSeparator = false;

                      if (index == 0 ||
                          !_isSameDay(
                              message.date, messages[index - 1].date)) {
                        showDateSeparator = true;
                      }

                      return Column(
                        children: [
                          if (showDateSeparator)
                            _DateSeparator(date: message.date),
                          AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ChatBubble(message: message),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
            _buildMessageInput(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ChatScreenController controller) {
    return Container(
      color: Colors.black.withOpacity(0.15),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
              ),
              const SizedBox(width: 4),
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: Icon(Icons.smart_toy_outlined, color: Colors.white70),
              ),
              const SizedBox(width: 12),
              Text(
                chat.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 1) controller.scrollToTop();
                  if (value == 2) controller.deleteChat();
                  if (value == 3) controller.blockUser();
                },
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: const Color(0xff1a1a2e),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: 1,
                      child: Text("Go to First Message",
                          style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(
                      value: 2,
                      child: Text("Delete Chat",
                          style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(
                      value: 3,
                      child: Text("Block User",
                          style: TextStyle(color: Colors.white))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatScreenController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          if (controller.replyingTo.value == null) {
            return const SizedBox.shrink();
          }
          final message = controller.replyingTo.value!;
          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(width: 4, height: 40, color: Colors.deepPurpleAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.isSentByMe ? "You" : "Samantha",
                        style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        message.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.cancelReply,
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                )
              ],
            ),
          );
        }),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GlowingSendButton(
                controller: controller.iconAnimationController,
                onPressed: controller.sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatDateSeparator(date),
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}