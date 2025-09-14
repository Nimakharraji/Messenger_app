// screens/main-screen.dart
import 'package:chatthing/screens/chat-list-screen.dart';
import 'package:chatthing/screens/group-list-screen.dart';
import 'package:chatthing/widgets/new-chat-button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatthing/controllers/main-controller.dart';
import 'package:chatthing/controllers/chat-list-controller.dart';
import 'package:chatthing/controllers/group-list-controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());
    Get.put(ChatListController());
    Get.put(GroupListController());

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4b1e6e), Color(0xff1e123a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(mainController),
                _buildTabs(mainController),
                Expanded(
                  child: Obx(() => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: mainController.selectedIndex.value == 0
                            ? const ChatListView(key: ValueKey('chats'))
                            : const GroupListView(key: ValueKey('groups')),
                      )),
                ),
              ],
            ),
          ),
          Obx(
            () => AnimatedAlign(
              alignment: mainController.fabAlignment.value,
              duration: mainController.fabMoveDuration,
              // بازگشت به منحنی نرم و روان
              curve: Curves.easeInOutSine, 
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedNewChatButton(
                  glowTrigger: mainController.glowTrigger.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(MainController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => MouseRegion(
              onEnter: (_) => controller.isSettingsHovered.value = true,
              onExit: (_) => controller.isSettingsHovered.value = false,
              child: AnimatedRotation(
                turns: controller.isSettingsHovered.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                child: const Icon(Icons.settings_rounded,
                    color: Colors.white70, size: 28),
              ),
            ),
          ),
          Obx(() {
            return AnimatedOpacity(
              opacity: controller.currentTime.value.isEmpty ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Text(
                controller.currentTime.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
          Obx(
            () => MouseRegion(
              onEnter: (_) => controller.isThemeIconHovered.value = true,
              onExit: (_) => controller.isThemeIconHovered.value = false,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  controller.isThemeIconHovered.value
                      ? Icons.nightlight_round
                      : Icons.wb_sunny_rounded,
                  key: ValueKey<bool>(controller.isThemeIconHovered.value),
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(MainController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Obx(
        () => Row(
          children: [
            _buildTabItem(controller, 'Chats', 0),
            const SizedBox(width: 20),
            _buildTabItem(controller, 'Groups', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(MainController controller, String title, int index) {
    final bool isActive = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white54,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        child: Text(title),
      ),
    );
  }
}