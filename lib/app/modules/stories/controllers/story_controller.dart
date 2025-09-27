import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/story_viewer_screen.dart';

class StoryController extends GetxController {
  late PageController pageController;
  Timer? _storyTimer;
  
  // Reactive variables
  final RxInt currentStoryIndex = 0.obs;
  final RxInt currentStoryItemIndex = 0.obs;
  final Rx<StoryModel> currentStory = StoryModel(
    id: '',
    userName: '',
    userAvatar: '',
    storyItems: [],
    createdAt: DateTime.now(),
  ).obs;
  
  final RxBool isPaused = false.obs;
  final RxDouble progress = 0.0.obs;
  
  // Premium dummy stories
  List<StoryModel> stories = [
    StoryModel(
      id: '1',
      userName: 'Sarah Chen',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      storyItems: [
        StoryItem(
          id: '1_1',
          imageUrl: 'https://picsum.photos/400/800?random=1',
          text: 'Beautiful sunset today! 🌅',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        StoryItem(
          id: '1_2',
          imageUrl: 'https://picsum.photos/400/800?random=2',
          text: 'Coffee time ☕️',
          createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        ),
      ],
    ),
    StoryModel(
      id: '2',
      userName: 'Alex Jordan',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      storyItems: [
        StoryItem(
          id: '2_1',
          imageUrl: 'https://picsum.photos/400/800?random=3',
          text: 'Weekend vibes! 🎉',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),
    StoryModel(
      id: '3',
      userName: 'Maya Patel',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      storyItems: [
        StoryItem(
          id: '3_1',
          imageUrl: 'https://picsum.photos/400/800?random=4',
          text: 'New workout routine 💪',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        StoryItem(
          id: '3_2',
          imageUrl: 'https://picsum.photos/400/800?random=5',
          text: 'Healthy lunch prep 🥗',
          createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
        ),
        StoryItem(
          id: '3_3',
          imageUrl: 'https://picsum.photos/400/800?random=6',
          text: 'Feeling great! ✨',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    
    // Initialize with first story
    if (stories.isNotEmpty) {
      currentStory.value = stories[0];
      _startStoryTimer();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    _storyTimer?.cancel();
    super.onClose();
  }

  void onPageChanged(int pageIndex) {
    currentStoryIndex.value = pageIndex;
    currentStoryItemIndex.value = 0;
    currentStory.value = stories[pageIndex];
    progress.value = 0.0;
    
    _storyTimer?.cancel();
    _startStoryTimer();
  }

  void _startStoryTimer() {
    if (isPaused.value) return;
    
    const duration = Duration(milliseconds: 50);
    const totalDuration = Duration(seconds: 5);
    
    _storyTimer = Timer.periodic(duration, (timer) {
      if (isPaused.value) return;
      
      progress.value += duration.inMilliseconds / totalDuration.inMilliseconds;
      
      if (progress.value >= 1.0) {
        timer.cancel();
        _nextStoryItem();
      }
    });
  }

  void _nextStoryItem() {
    final currentStoryItems = currentStory.value.storyItems;
    
    if (currentStoryItemIndex.value < currentStoryItems.length - 1) {
      // Next story item in current story
      currentStoryItemIndex.value++;
      progress.value = 0.0;
      _startStoryTimer();
    } else if (currentStoryIndex.value < stories.length - 1) {
      // Next story
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // End of all stories
      Get.back();
    }
  }

  void _previousStoryItem() {
    if (currentStoryItemIndex.value > 0) {
      // Previous story item in current story
      currentStoryItemIndex.value--;
      progress.value = 0.0;
      _storyTimer?.cancel();
      _startStoryTimer();
    } else if (currentStoryIndex.value > 0) {
      // Previous story
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void pauseStory() {
    isPaused.value = true;
    _storyTimer?.cancel();
  }

  void resumeStory() {
    isPaused.value = false;
    _startStoryTimer();
  }

  void tapToNext() {
    _storyTimer?.cancel();
    _nextStoryItem();
  }

  void tapToPrevious() {
    _storyTimer?.cancel();
    _previousStoryItem();
  }

  double getProgressForStoryItem(int itemIndex) {
    if (itemIndex < currentStoryItemIndex.value) {
      return 1.0; // Completed
    } else if (itemIndex == currentStoryItemIndex.value) {
      return progress.value; // Current progress
    } else {
      return 0.0; // Not started
    }
  }

  StoryItem? getCurrentStoryItem() {
    if (currentStory.value.storyItems.isEmpty) return null;
    
    final items = currentStory.value.storyItems;
    if (currentStoryItemIndex.value >= items.length) return null;
    
    return items[currentStoryItemIndex.value];
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final storyTime = currentStory.value.createdAt;
    final difference = now.difference(storyTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void addReaction(String emoji) {
    // Premium reaction animation
    Get.snackbar(
      'Reaction Sent!',
      'You reacted with $emoji',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void sendReply() {
    // Premium reply functionality
    Get.snackbar(
      'Reply Sent!',
      'Your message has been sent',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}