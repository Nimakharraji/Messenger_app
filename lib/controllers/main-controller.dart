// controllers/main-controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;
  var isSettingsHovered = false.obs;
  var isThemeIconHovered = false.obs;
  var currentTime = ''.obs;
  var timestampTicker = 0.obs;
  var fabAlignment = Alignment.bottomRight.obs;

  // یک تریگر جدید برای اجرای انیمیشن نورانی
  var glowTrigger = 0.obs;

  Timer? _timer;
  Timer? _fabTimer;

  // مدت زمان انیمیشن جابجایی دکمه
  final fabMoveDuration = const Duration(milliseconds: 2500);

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      if (timer.tick % 60 == 0) {
        timestampTicker.value++;
      }
    });

    _fabTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      // تغییر مکان دکمه
      if (fabAlignment.value == Alignment.bottomRight) {
        fabAlignment.value = Alignment.bottomLeft;
      } else {
        fabAlignment.value = Alignment.bottomRight;
      }

      // بعد از اتمام انیمیشن جابجایی، انیمیشن نورانی را فعال کن
      Future.delayed(fabMoveDuration, () {
        glowTrigger.value++;
      });
    });
  }

  void _updateTime() {
    final String formattedTime = DateFormat('HH:mm').format(DateTime.now());
    currentTime.value = formattedTime;
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _fabTimer?.cancel();
    super.onClose();
  }
}
