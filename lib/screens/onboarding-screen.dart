import 'package:chatthing/controllers/onboarding-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:glassmorphism/glassmorphism.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // کنترلر را در GetX ثبت می‌کنیم تا در دسترس باشد
    final controller = Get.put(OnboardingController());

    // لیست اطلاعات هر صفحه (آیکون و متن)
    final List<Map<String, dynamic>> onboardingPages = [
      {
        'icon': Icons.send_rounded,
        'title': 'Send Texts',
        'description': 'Communicate instantly with your friends via fast and secure messages.'
      },
      {
        'icon': Icons.touch_app_rounded,
        'title': 'Select a Chat',
        'description': 'Easily browse and select any chat from your conversation list.'
      },
      {
        'icon': Icons.delete_sweep_rounded,
        'title': 'Delete Messages',
        'description': 'Have full control by deleting messages for everyone, anytime.'
      },
      {
        'icon': Icons.clear_all_rounded,
        'title': 'Clear History',
        'description': 'Wipe entire conversations clean with a single tap for a fresh start.'
      },
    ];

    // PageController برای مدیریت اسکرول بین صفحات
    final pageController = PageController();

    return Scaffold(
      backgroundColor: const Color(0xff1a1a2e), // پس‌زمینه بنفش دارک
      body: SafeArea(
        child: Column(
          children: [
            // بخش اصلی که صفحات را نمایش می‌دهد
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  return OnboardingPageItem(
                    icon: page['icon'],
                    title: page['title'],
                    description: page['description'],
                  );
                },
              ),
            ),
            // بخش پایینی شامل نشانگر صفحه و دکمه
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // نشانگرهای نقطه‌ای برای صفحات
                  SmoothPageIndicator(
                    controller: pageController,
                    count: onboardingPages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white38,
                    ),
                  ),

                  // دکمه "بعدی" یا "شروع"
                  Obx(() {
                    final isLastPage = controller.currentPageIndex.value == onboardingPages.length - 1;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: isLastPage
                          ? _buildStartButton(controller)
                          : _buildNextButton(pageController),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ویجت دکمه "شروع پیام‌رسانی"
  Widget _buildStartButton(OnboardingController controller) {
    return ElevatedButton(
      key: const ValueKey('start_button'),
      onPressed: controller.startMessaging,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      ),
      child: const Text(
        "Start Messaging",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // ویجت دکمه "بعدی"
  Widget _buildNextButton(PageController pageController) {
    return IconButton(
      key: const ValueKey('next_button'),
      onPressed: () {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white24,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}

// ویجت سفارشی برای نمایش هر آیتم در صفحه خوش‌آمدگویی
class OnboardingPageItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPageItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // کانتینر شیشه‌ای برای آیکون
          GlassmorphicContainer(
            width: 150,
            height: 150,
            borderRadius: 75,
            blur: 10,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.5),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 60),
          // عنوان ویژگی
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          // توضیحات ویژگی
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}