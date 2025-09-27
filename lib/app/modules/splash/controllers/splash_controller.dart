import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initializeAndNavigate();
  }

  void _initializeAndNavigate() async {
    try {
      // Wait for the splash animation
      await Future.delayed(const Duration(seconds: 3));
      
      // Always navigate to onboarding for demo purposes
      // This ensures we always see the full flow: Splash → Onboarding → Login/Signup
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      // Fallback navigation to onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}