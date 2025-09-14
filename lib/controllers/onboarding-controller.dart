
import 'package:chatthing/screens/main-screen.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // یک متغیر برای نگهداری ایندکس صفحه فعلی
  var currentPageIndex = 0.obs;

  // متدی برای به‌روزرسانی ایندکس هنگام تغییر صفحه
  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void startMessaging() {
    Get.offAll(MainScreen());
  }
}
