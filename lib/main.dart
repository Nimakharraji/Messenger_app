import 'package:chatthing/screens/onboarding-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

// دیگر نیازی به async نیست چون کار ناهمزمانی انجام نمی‌شود
void main() {
  // تمام کدهای مربوط به فایربیس حذف شد

  // زبان پکیج timeago را روی انگلیسی تنظیم می‌کنیم
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
