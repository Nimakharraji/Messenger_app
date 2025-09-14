// widgets/animated-new-chat-button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatthing/screens/new-chat-screen.dart';
import 'dart:math' as math;

class AnimatedNewChatButton extends StatefulWidget {
  final int glowTrigger;
  const AnimatedNewChatButton({super.key, required this.glowTrigger});

  @override
  State<AnimatedNewChatButton> createState() => _AnimatedNewChatButtonState();
}

class _AnimatedNewChatButtonState extends State<AnimatedNewChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000), // مدت زمان افکت نور
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedNewChatButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.glowTrigger != oldWidget.glowTrigger) {
      _glowController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fab = FloatingActionButton.extended(
      onPressed: () {
        Get.to(() => NewChatScreen(), transition: Transition.downToUp);
      },
      backgroundColor: const Color(0xff8e2de2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text("New Chat", style: TextStyle(color: Colors.white)),
    );

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        // افکت نبض نرم (ظاهر شدن و محو شدن)
        final double glowValue = math.sin(_glowController.value * math.pi);

        return Stack(
          alignment: Alignment.center,
          children: [
            // لایه زیرین: هاله نور که حالا شکل دکمه را دارد
            if (_glowController.isAnimating)
              Opacity(
                opacity: glowValue,
                child: Container(
                  // ابعاد را کمی بزرگتر از دکمه در نظر می‌گیریم
                  width: 130,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), // شکل مستطیلی
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffa855f7).withOpacity(0.7),
                        blurRadius: 20.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                ),
              ),

            // دکمه اصلی همیشه در بالا و بدون تغییر قرار دارد
            child!,
          ],
        );
      },
      child: fab, // دکمه اصلی به عنوان child ارسال می‌شود تا دوباره ساخته نشود
    );
  }
}
