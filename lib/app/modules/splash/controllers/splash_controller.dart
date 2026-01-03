import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('🎬 SplashController onInit');
  }

  @override
  void onReady() {
    super.onReady();
    print('🎬 SplashController onReady');
    _initializeAndNavigate();
  }

  void _initializeAndNavigate() async {
    try {
      print('⏱️ Starting splash delay...');
      // Wait for the splash animation
      await Future.delayed(const Duration(seconds: 3));
      
      print('🔄 Navigating to onboarding...');
      // Always navigate to onboarding for demo purposes
      // This ensures we always see the full flow: Splash → Onboarding → Login/Signup
      Get.offAllNamed(AppRoutes.onboarding);
      print('✅ Navigation complete');
    } catch (e, stackTrace) {
      print('❌ Error in splash navigation: $e');
      print('Stack trace: $stackTrace');
      // Fallback navigation to onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}