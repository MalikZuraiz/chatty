import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../controllers/story_controller.dart';

class StoryViewerScreen extends GetView<StoryController> {
  const StoryViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Premium background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F0B1F),
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                ],
              ),
            ),
          ),

          // Floating particles animation
          ...List.generate(8, (index) => 
            _FloatingStoryParticle(key: ValueKey(index), index: index)
          ),

          // Story content
          GestureDetector(
            onTapDown: (details) => controller.pauseStory(),
            onTapUp: (details) => controller.resumeStory(),
            onTapCancel: () => controller.resumeStory(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.stories.length,
                itemBuilder: (context, index) {
                  final story = controller.stories[index];
                  return _buildStoryPage(story, index);
                },
              ),
            ),
          ),

          // Premium story progress indicators
          SafeArea(
            child: Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  // Progress bars
                  Obx(() => Row(
                    children: List.generate(
                      controller.currentStory.value.storyItems.length,
                      (index) => Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: controller.getProgressForStoryItem(index),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonCyan,
                                    AppTheme.neonBlue,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.neonCyan.withOpacity(0.6),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),

                  const SizedBox(height: 16),

                  // Story header with glassmorphism
                  GlassmorphismContainer(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Premium avatar with neon glow
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonPink.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                controller.currentStory.value.userAvatar,
                              ),
                              backgroundColor: AppTheme.neonPink.withOpacity(0.2),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.currentStory.value.userName,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Obx(() => Text(
                                  controller.getTimeAgo(),
                                  style: GoogleFonts.inter(
                                    color: AppTheme.neonCyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                              ],
                            ),
                          ),

                          // Premium action buttons
                          _buildStoryActionButton(
                            icon: Icons.more_vert,
                            color: Colors.white70,
                            onTap: () => _showStoryOptions(context),
                          ),

                          const SizedBox(width: 8),

                          _buildStoryActionButton(
                            icon: Icons.close,
                            color: Colors.white70,
                            onTap: () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Premium story interaction overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Story text content (if any)
                    Obx(() {
                      final currentItem = controller.getCurrentStoryItem();
                      if (currentItem?.text != null && currentItem!.text!.isNotEmpty) {
                        return FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: GlassmorphismContainer(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                currentItem.text!,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 16),

                    // Premium reply input
                    GlassmorphismContainer(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Reply to story...',
                                  hintStyle: GoogleFonts.inter(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Premium reaction buttons
                            _buildReactionButton('❤️', AppTheme.neonPink),
                            const SizedBox(width: 8),
                            _buildReactionButton('😂', AppTheme.neonCyan),
                            const SizedBox(width: 8),
                            _buildReactionButton('😱', AppTheme.neonPurple),

                            const SizedBox(width: 12),

                            _buildStoryActionButton(
                              icon: Icons.send_rounded,
                              color: AppTheme.neonBlue,
                              onTap: () => controller.sendReply(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryPage(StoryModel story, int pageIndex) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Story background with premium gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Obx(() {
              final currentItem = controller.getCurrentStoryItem();
              if (currentItem?.imageUrl != null) {
                return Image.network(
                  currentItem!.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPremiumPlaceholder();
                  },
                );
              } else {
                return _buildPremiumPlaceholder();
              }
            }),
          ),

          // Premium gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.neonPurple.withOpacity(0.3),
            AppTheme.neonBlue.withOpacity(0.3),
            AppTheme.neonCyan.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Premium Story',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildReactionButton(String emoji, Color color) {
    return GestureDetector(
      onTap: () => controller.addReaction(emoji),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  void _showStoryOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphismContainer(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: 20),
              
              _buildOptionTile(
                icon: Icons.report_outlined,
                title: 'Report Story',
                color: AppTheme.neonPink,
                onTap: () {},
              ),
              
              _buildOptionTile(
                icon: Icons.block_outlined,
                title: 'Block User',
                color: AppTheme.neonPurple,
                onTap: () {},
              ),
              
              _buildOptionTile(
                icon: Icons.share_outlined,
                title: 'Share Story',
                color: AppTheme.neonCyan,
                onTap: () {},
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.back();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Premium floating story particles
class _FloatingStoryParticle extends StatefulWidget {
  final int index;
  
  const _FloatingStoryParticle({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<_FloatingStoryParticle> createState() => _FloatingStoryParticleState();
}

class _FloatingStoryParticleState extends State<_FloatingStoryParticle>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late double _startX;
  late double _startY;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(seconds: 6 + widget.index * 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _startX = math.Random().nextDouble() * 300;
    _startY = math.Random().nextDouble() * 600 + 100;

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      AppTheme.neonPink,
      AppTheme.neonCyan,
    ];
    
    final color = colors[widget.index % colors.length];
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _startX + math.sin(_animation.value * math.pi * 4) * 50,
          top: _startY - (_animation.value * 700),
          child: Opacity(
            opacity: (1 - _animation.value) * 0.2,
            child: Container(
              width: 3 + (widget.index % 4) * 1.5,
              height: 3 + (widget.index % 4) * 1.5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Story Models
class StoryModel {
  final String id;
  final String userName;
  final String userAvatar;
  final List<StoryItem> storyItems;
  final DateTime createdAt;

  StoryModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.storyItems,
    required this.createdAt,
  });
}

class StoryItem {
  final String id;
  final String? imageUrl;
  final String? text;
  final DateTime createdAt;
  final Duration duration;

  StoryItem({
    required this.id,
    this.imageUrl,
    this.text,
    required this.createdAt,
    this.duration = const Duration(seconds: 5),
  });
}