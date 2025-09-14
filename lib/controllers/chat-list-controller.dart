// controllers/chat-list-controller.dart
import 'package:chatthing/service/bot-service.dart';
import 'package:chatthing/service/contact-service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:chatthing/models/chat-model.dart';
import 'package:chatthing/models/message-model.dart';
import 'package:chatthing/models/user-model.dart';

class ChatListController extends GetxController {
  var chatList = <Chat>[].obs;
  final BotService _botService = BotService();
  final ContactService _contactService = ContactService();
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    _loadInitialChats();
  }

  void _loadInitialChats() {
    final initialContact1 = _contactService.allUsers[0]; // Samantha
    final initialContact2 = _contactService.allUsers[1]; // John Doe

    chatList.value = [
      Chat(
        id: _uuid.v4(),
        name: initialContact1.name,
        isBot: false,
        messages: [
          Message(
            text: 'Hey! What\'s up?',
            date: DateTime.now().subtract(const Duration(minutes: 16)),
            isSentByMe: false,
          ),
          Message(
            text: 'Not much, just working on a new design. You?',
            date: DateTime.now().subtract(const Duration(minutes: 15)),
            isSentByMe: true,
          ),
          Message(
            text: 'Cool! I\'m building a Flutter app.',
            date: DateTime.now().subtract(const Duration(minutes: 14)),
            isSentByMe: false,
          ),
        ],
      ),
      Chat(
        id: _uuid.v4(),
        name: initialContact2.name,
        isBot: true,
        messages: [
          Message(
            text:
                'John Doe dictionary \n hi,hello,hey,yo \n Whats up,sup,wazup \n how is your day,how are you doing \n what is your name \n i like you,you are cool \n primary word👆 \n secondary word👇 \n yes,yeah,yep,ok \n no,nope \n good,great,cool,nice \n thank,thanks,thank you \n useless word👇 \n i hate you \n ** *,f u',
            date: DateTime.now().subtract(const Duration(days: 1)),
            isSentByMe: true,
          ),
        ],
      ),
    ];
  }

  Chat findOrCreateChatWithUser(User user) {
    var existingChat = chatList.firstWhere(
      (chat) => chat.name == user.name,
      orElse: () => Chat(id: 'not_found', name: '', messages: []),
    );

    if (existingChat.id != 'not_found') {
      return existingChat;
    } else {
      final newChat = Chat(
        id: _uuid.v4(),
        name: user.name,
        messages: [],
        isBot: user.name == 'John Doe',
      );
      chatList.add(newChat);
      return newChat;
    }
  }

  void sendMessage(String chatId, String text, {Message? repliedToMessage}) {
    final userMessage = Message(
      text: text,
      date: DateTime.now(),
      isSentByMe: true,
      repliedTo: repliedToMessage,
    );
    int chatIndex = chatList.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      chatList[chatIndex].messages.add(userMessage);
      chatList.refresh();
      if (chatList[chatIndex].isBot) {
        _triggerBotResponse(chatId, text);
      }
    }
  }

  void _triggerBotResponse(String chatId, String userInput) {
    Future.delayed(const Duration(seconds: 2), () {
      final botResponseText = _botService.getResponse(userInput);
      final botMessage = Message(
        text: botResponseText,
        date: DateTime.now(),
        isSentByMe: false,
      );
      int chatIndex = chatList.indexWhere((chat) => chat.id == chatId);
      if (chatIndex != -1) {
        chatList[chatIndex].messages.add(botMessage);
        chatList.refresh();
      }
    });
  }

  void forwardMessage(String targetChatId, Message messageToForward) {
    final forwardedMessage = Message(
      text: messageToForward.text,
      date: DateTime.now(),
      isSentByMe: true,
      repliedTo: messageToForward.repliedTo,
      isForwarded: true,
    );
    int chatIndex = chatList.indexWhere((chat) => chat.id == targetChatId);
    if (chatIndex != -1) {
      chatList[chatIndex].messages.add(forwardedMessage);
      chatList.refresh();
    }
  }

  void deleteMessage(String chatId, Message messageToDelete) {
    int chatIndex = chatList.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      chatList[chatIndex].messages.removeWhere(
        (msg) =>
            msg.date == messageToDelete.date &&
            msg.text == messageToDelete.text,
      );
      chatList.refresh();
    }
  }
}
