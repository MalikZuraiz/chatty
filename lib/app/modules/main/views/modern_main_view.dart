import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/main_view_controller.dart';

import '../../chat_list/views/ultra_premium_chat_view.dart';
import '../../stories/views/ultra_premium_stories_view.dart';
import '../../feed/views/ultra_premium_feed_view.dart';
import '../../profile/views/modern_profile_view.dart';

class ModernMainView extends StatelessWidget {
  ModernMainView({super.key});
  
  final controller = Get.put(MainViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0712),
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          UltraPremiumChatView(),
          UltraPremiumStoriesView(),
          UltraPremiumFeedView(),
          ModernProfileView(),
        ],
      )),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernBottomNav() {
    return Obx(() => Container(
<<<<<<< Updated upstream
      height: 70,
=======
      height: 80,
>>>>>>> Stashed changes
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.chat_bubble_rounded,
              label: 'Chats',
              color: const Color(0xFF00D4FF),
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.auto_awesome_rounded,
              label: 'Stories',
              color: const Color(0xFFFF006E),
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.explore_rounded,
              label: 'Feed',
              color: const Color(0xFF06FFA5),
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person_rounded,
              label: 'Profile',
              color: const Color(0xFF8B5CF6),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = controller.currentIndex.value == index;
    
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.white.withOpacity(0.4),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
