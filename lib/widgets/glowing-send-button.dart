// widgets/glowing-send-button.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowingSendButton extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onPressed;

  const GlowingSendButton({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final double pulseValue = math.sin(controller.value * math.pi);
          final double cometOpacity = controller.value < 0.5
              ? controller.value * 2
              : (1.0 - controller.value) * 2;

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1 + (pulseValue * 0.3),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffa855f7).withOpacity(0.6 * pulseValue),
                        blurRadius: 20.0,
                        spreadRadius: 5.0 * pulseValue,
                      ),
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: cometOpacity > 0 ? cometOpacity : 0,
                child: RotationTransition(
                  turns: controller,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xffd946ef),
                          Color(0xff8e2de2),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.3, 0.6, 0.6],
                        transform: GradientRotation(math.pi / 2),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xff8e2de2), Color(0xff4a00e0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}