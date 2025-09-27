import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find();
  final PageController pageController = PageController();
  
  RxInt currentPage = 0.obs;
  
  final List<OnboardingData> onboardingPages = [
    OnboardingData(
      title: "Welcome to Chatty",
      subtitle: "Experience the future of social messaging with premium glassmorphism design",
      icon: Icons.chat_bubble_rounded,
    ),
    OnboardingData(
      title: "Premium Conversations",
      subtitle: "Enjoy crystal-clear voice calls, HD video chats, and rich media sharing",
      icon: Icons.video_call_rounded,
    ),
    OnboardingData(
      title: "Stories & Status",
      subtitle: "Share your moments with beautiful stories and express yourself with status updates",
      icon: Icons.auto_stories_rounded,
    ),
    OnboardingData(
      title: "Next-Gen Security",
      subtitle: "Your conversations are protected with end-to-end encryption and premium privacy",
      icon: Icons.security_rounded,
    ),
  ];

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    _storageService.isFirstTime = false;
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}