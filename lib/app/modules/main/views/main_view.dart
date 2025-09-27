import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../chat_list/views/chat_list_view.dart';
import '../../profile/views/profile_view.dart';
import '../../settings/views/settings_view.dart';
import '../../notifications/views/notifications_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  final List<Widget> screens = [
    const ChatListView(),
    const _StoriesView(), // Stories/Status view
    const NotificationsView(),
    const ProfileView(),
  ];

  final List<MainNavItem> navItems = [
    MainNavItem(
      icon: Icons.chat_bubble_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Chats',
      color: AppTheme.neonBlue,
    ),
    MainNavItem(
      icon: Icons.auto_stories_outlined,
      activeIcon: Icons.auto_stories_rounded,
      label: 'Stories',
      color: AppTheme.neonPink,
    ),
    MainNavItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications_rounded,
      label: 'Updates',
      color: AppTheme.neonCyan,
    ),
    MainNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
      color: AppTheme.neonPurple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    ));
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          
          // Premium floating action button for new chat
          if (currentIndex == 0) // Only show on chats tab
            Positioned(
              bottom: 100,
              right: 20,
              child: ScaleTransition(
                scale: _fabAnimation,
                child: NeonGlowContainer(
                  glowColor: AppTheme.neonBlue,
                  glowRadius: 15,
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(30),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // TODO: Open new chat screen
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: AppTheme.textPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildPremiumBottomNav(),
    );
  }

  Widget _buildPremiumBottomNav() {
    return Container(
      height: 85,
      margin: const EdgeInsets.all(16),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(25),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = currentIndex == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
                _fabController.reset();
                _fabController.forward();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? LinearGradient(
                    colors: [
                      item.color.withOpacity(0.2),
                      item.color.withOpacity(0.1),
                    ],
                  ) : null,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? Border.all(
                    color: item.color.withOpacity(0.3),
                    width: 1,
                  ) : null,
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: item.color.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ] : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? item.color : AppTheme.textTertiary,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? item.color : AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MainNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  MainNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}

class _StoriesView extends StatelessWidget {
  const _StoriesView();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Premium header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Stories',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  NeonIcon(
                    icon: Icons.camera_alt_rounded,
                    color: AppTheme.neonPink,
                    size: 28,
                  ),
                ],
              ),
            ),
            
            // Stories content placeholder
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeonIcon(
                      icon: Icons.auto_stories_rounded,
                      color: AppTheme.neonPink,
                      size: 80,
                      isAnimated: true,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Stories Yet',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share your first story with friends',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}