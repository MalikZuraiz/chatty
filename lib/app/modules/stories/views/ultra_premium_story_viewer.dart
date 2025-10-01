import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UltraPremiumStoryViewer extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final List<String> storyImages;
  final int initialIndex;

  const UltraPremiumStoryViewer({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.storyImages,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<UltraPremiumStoryViewer> createState() => _UltraPremiumStoryViewerState();
}

class _UltraPremiumStoryViewerState extends State<UltraPremiumStoryViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _progressController.addListener(() {
      if (mounted) setState(() {});
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _startProgress();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
  }

  void _startProgress() {
    _progressController.forward(from: 0);
  }

  void _pauseProgress() {
    if (!_isPaused) {
      _progressController.stop();
      setState(() => _isPaused = true);
    }
  }

  void _resumeProgress() {
    if (_isPaused) {
      _progressController.forward();
      setState(() => _isPaused = false);
    }
  }

  void _nextStory() {
    if (_currentIndex < widget.storyImages.length - 1) {
      setState(() => _currentIndex++);
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgress();
    } else {
      Get.back();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgress();
    }
  }

  String _getTimeAgo() {
    final random = [
      '2h ago',
      '5h ago',
      '8h ago',
      '12h ago',
      '1d ago',
    ];
    return random[_currentIndex % random.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: GestureDetector(
        onTapDown: (details) => _pauseProgress(),
        onTapUp: (details) {
          _resumeProgress();
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 3) {
            _previousStory();
          } else if (details.localPosition.dx > screenWidth * 2 / 3) {
            _nextStory();
          }
        },
        onTapCancel: () => _resumeProgress(),
        onLongPressStart: (_) => _pauseProgress(),
        onLongPressEnd: (_) => _resumeProgress(),
        child: Stack(
          children: [
            // Story Images
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.storyImages.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
                _startProgress();
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.storyImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            // Gradient Overlays
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.15, 0.85, 1.0],
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Progress Indicators & Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Column(
                      children: [
                        // Progress Bars
                        Row(
                          children: List.generate(
                            widget.storyImages.length,
                            (index) => Expanded(
                              child: Container(
                                height: 2,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: index == _currentIndex
                                      ? _progressController.value
                                      : index < _currentIndex
                                          ? 1.0
                                          : 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Header with user info
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF00F5FF).withOpacity(0.5),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00F5FF).withOpacity(0.3),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        widget.userAvatar,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(
                                          Icons.person,
                                          color: Colors.white60,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // Name and time
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.userName,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _getTimeAgo(),
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action buttons
                                  _buildIconButton(
                                    icon: _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                    onTap: () {
                                      if (_isPaused) {
                                        _resumeProgress();
                                      } else {
                                        _pauseProgress();
                                      }
                                    },
                                  ),

                                  const SizedBox(width: 6),

                                  _buildIconButton(
                                    icon: Icons.more_vert_rounded,
                                    onTap: () => _showOptions(),
                                  ),

                                  const SizedBox(width: 6),

                                  _buildIconButton(
                                    icon: Icons.close_rounded,
                                    onTap: () => Get.back(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom interaction area
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Reply to story...',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              _buildActionButton(
                                icon: Icons.favorite_border_rounded,
                                color: const Color(0xFFFF2E97),
                              ),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                icon: Icons.send_rounded,
                                color: const Color(0xFF00F5FF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A24),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionItem(
              icon: Icons.report_outlined,
              title: 'Report Story',
              color: const Color(0xFFFF2E97),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Reported',
                  'Story has been reported',
                  backgroundColor: const Color(0xFF1A1A24),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            _buildOptionItem(
              icon: Icons.block_outlined,
              title: 'Block User',
              color: const Color(0xFFFF0080),
              onTap: () {
                Get.back();
              },
            ),
            _buildOptionItem(
              icon: Icons.copy_outlined,
              title: 'Copy Link',
              color: const Color(0xFF00F5FF),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Copied',
                  'Story link copied to clipboard',
                  backgroundColor: const Color(0xFF1A1A24),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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