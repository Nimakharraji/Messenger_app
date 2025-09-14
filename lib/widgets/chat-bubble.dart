// widgets/chat-bubble.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:chatthing/controllers/chat-screen-controller.dart';
import 'package:chatthing/models/message-model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatScreenController>();
    final bool isSentByMe = message.isSentByMe;

    final bubble = Slidable(
      key: ValueKey(message.date),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              isSentByMe
                  ? controller.navigateToForward(message)
                  : controller.setReplyTo(message);
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            icon: isSentByMe ? Icons.forward_rounded : Icons.reply_rounded,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              isSentByMe
                  ? controller.setReplyTo(message)
                  : controller.navigateToForward(message);
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            icon: isSentByMe ? Icons.reply_rounded : Icons.forward_rounded,
          ),
        ],
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isSentByMe
                    ? [const Color(0xff8e2de2), const Color(0xff4a00e0)]
                    : [const Color(0xff3a3a5a), const Color(0xff2a2a4a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft:
                isSentByMe
                    ? const Radius.circular(20)
                    : const Radius.circular(4),
            bottomRight:
                isSentByMe
                    ? const Radius.circular(4)
                    : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.isForwarded) _buildForwardedIndicator(),
            if (message.repliedTo != null)
              _buildReplyPreview(message.repliedTo!),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: message.text),
                  const TextSpan(text: ' \u00A0\u00A0\u00A0'),
                  TextSpan(
                    text: DateFormat('HH:mm').format(message.date),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onLongPressStart: (details) {
        _showContextMenu(context, details.globalPosition, controller, message);
      },
      onSecondaryTapUp: (details) {
        _showContextMenu(context, details.globalPosition, controller, message);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [bubble],
        ),
      ),
    );
  }

  void _showContextMenu(
    BuildContext context,
    Offset position,
    ChatScreenController controller,
    Message message,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      // نوع خروجی منو را مشخص می‌کنیم
      context: context,
      color: const Color(0xff2a2a4a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<String>>[
        _buildPopupMenuItem(
          icon: Icons.reply_rounded,
          text: 'Reply',
          value: 'reply',
        ),
        _buildPopupMenuItem(
          icon: Icons.forward_rounded,
          text: 'Forward',
          value: 'forward',
        ),
        _buildPopupMenuItem(
          icon: Icons.copy_rounded,
          text: 'Copy',
          value: 'copy',
        ),
        const PopupMenuDivider(height: 1),
        _buildPopupMenuItem(
          icon: Icons.delete_outline_rounded,
          text: 'Delete',
          value: 'delete',
          isDestructive: true,
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue == null) return;

      switch (selectedValue) {
        case 'reply':
          controller.setReplyTo(message);
          break;
        case 'forward':
          controller.navigateToForward(message);
          break;
        case 'copy':
          controller.copyMessage(message.text);
          break;
        case 'delete':
          controller.deleteMessage(message);
          break;
      }
    });
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required IconData icon,
    required String text,
    required String value,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: isDestructive ? Colors.redAccent.shade100 : Colors.white70,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDestructive ? Colors.redAccent.shade100 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForwardedIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.forward_rounded,
            color: Colors.white.withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'Forwarded message',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview(Message repliedMessage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border(
          left: BorderSide(
            color:
                repliedMessage.isSentByMe
                    ? Colors.blueAccent
                    : Colors.greenAccent,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            repliedMessage.isSentByMe ? "You" : "Samantha",
            style: TextStyle(
              color:
                  repliedMessage.isSentByMe
                      ? Colors.blueAccent
                      : Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            repliedMessage.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
