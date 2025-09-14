import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chatthing/models/message-model.dart';
import 'package:chatthing/controllers/chat-list-controller.dart';
import 'package:chatthing/screens/forward-screen.dart';

class ChatScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  late AnimationController iconAnimationController;
  late final String currentChatId;
  final ChatListController _chatListController = Get.find();

  var replyingTo = Rx<Message?>(null);

  @override
  void onInit() {
    super.onInit();
    iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (isClosed) {
        timer.cancel();
      } else if (iconAnimationController.status != AnimationStatus.forward) {
        iconAnimationController.forward(from: 0.0);
      }
    });
  }

  void setChatId(String chatId) {
    currentChatId = chatId;
  }

  void setReplyTo(Message message) {
    replyingTo.value = message;
  }

  void cancelReply() {
    replyingTo.value = null;
  }
  
  void navigateToForward(Message message) {
    Get.to(() => ForwardScreen(messageToForward: message));
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      _chatListController.sendMessage(
        currentChatId,
        text,
        repliedToMessage: replyingTo.value,
      );
      textController.clear();
      cancelReply();
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
    Get.back();
    Get.snackbar('Action', 'Scrolled to the first message!',
        colorText: Colors.white,
        backgroundColor: Colors.black45,
        margin: const EdgeInsets.all(10));
  }

  void deleteChat() {
     Get.back();
     Get.snackbar('Action', 'Chat Deleted (Not really!)',
        colorText: Colors.white, backgroundColor: Colors.black45, margin: const EdgeInsets.all(10));
  }
  
  void blockUser() {
     Get.back();
     Get.snackbar('Action', 'User Blocked (Not really!)',
        colorText: Colors.white, backgroundColor: Colors.black45, margin: const EdgeInsets.all(10));
  }

  void copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar("Copied", "Message copied to clipboard",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black45,
        margin: const EdgeInsets.all(10));
  }
  
  void deleteMessage(Message message) {
    _chatListController.deleteMessage(currentChatId, message);
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    iconAnimationController.dispose();
    super.onClose();
  }
}