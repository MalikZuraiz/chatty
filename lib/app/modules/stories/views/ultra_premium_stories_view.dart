import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

class UltraPremiumStoriesView extends StatefulWidget {
  const UltraPremiumStoriesView({super.key});

  @override
  State<UltraPremiumStoriesView> createState() => _UltraPremiumStoriesViewState();
}

class _UltraPremiumStoriesViewState extends State<UltraPremiumStoriesView> with SingleTickerProviderStateMixin {
  bool isGridView = false;
  late AnimationController _glowController;

  final List<StoryUser> stories = [
    StoryUser(
      id: '1',
      name: 'Your Story',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=YourStory',
      isYours: true,
      hasUnviewed: false,
    ),
    StoryUser(
      id: '2',
      name: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      hasUnviewed: true,
      time: '2h',
    ),
    StoryUser(
      id: '3',
      name: 'Alex Jordan',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      hasUnviewed: true,
      time: '4h',
    ),
    StoryUser(
      id: '4',
      name: 'Maya Patel',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      hasUnviewed: false,
      time: '8h',
    ),
    StoryUser(
      id: '5',
      name: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      hasUnviewed: true,
      time: '10h',
    ),
    StoryUser(
      id: '6',
      name: 'Emma Wilson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      hasUnviewed: false,
      time: '12h',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0B0B0F),
            Color(0xFF1A1A24),
            Color(0xFF0B0B0F),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildSleekHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: isGridView ? _buildPremiumGrid() : _buildPremiumList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleekHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stories',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${stories.length} active now',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildIconButton(
            icon: isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
            onTap: () => setState(() => isGridView = !isGridView),
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.camera_alt_rounded,
            onTap: _createStory,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 18),
      ),
    );
  }

  Widget _buildPremiumList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return GestureDetector(
          onTap: () => _viewStory(story),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.04),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildStoryAvatar(story, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.name,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        story.isYours ? 'Add to your story' : '${story.time} ago',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                if (story.hasUnviewed && !story.isYours)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF0080), Color(0xFFFF8C00)],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return GestureDetector(
          onTap: () => _viewStory(story),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: story.hasUnviewed && !story.isYours
                    ? const Color(0xFFFF0080)
                    : Colors.white.withOpacity(0.08),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: story.avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white.withOpacity(0.05),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.white.withOpacity(0.05),
                      child: const Icon(Icons.person, color: Colors.white30),
                    ),
                  ),
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
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              const Shadow(blurRadius: 4, color: Colors.black54),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!story.isYours && story.time != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${story.time} ago',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                              shadows: [
                                const Shadow(blurRadius: 4, color: Colors.black54),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (story.isYours)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00F5FF), Color(0xFF0099FF)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00F5FF).withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoryAvatar(StoryUser story, {required double size}) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: story.hasUnviewed && !story.isYours
                ? LinearGradient(
                    colors: [
                      const Color(0xFFFF0080),
                      const Color(0xFFFF8C00),
                    ],
                    transform: GradientRotation(_glowController.value * 2 * math.pi),
                  )
                : null,
            border: !story.hasUnviewed || story.isYours
                ? Border.all(color: Colors.white.withOpacity(0.15), width: 2)
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: const Color(0xFF0B0B0F), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: CachedNetworkImage(
                imageUrl: story.avatar,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white.withOpacity(0.05),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _viewStory(StoryUser story) {
    if (story.isYours) {
      _createStory();
    }
  }

  void _createStory() {
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
            Text(
              'Create Story',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildStoryOption(Icons.camera_alt, 'Camera', const Color(0xFF00F5FF))),
                const SizedBox(width: 12),
                Expanded(child: _buildStoryOption(Icons.photo_library, 'Gallery', const Color(0xFFFF0080))),
                const SizedBox(width: 12),
                Expanded(child: _buildStoryOption(Icons.text_fields, 'Text', const Color(0xFF00FF88))),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryOption(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StoryUser {
  final String id;
  final String name;
  final String avatar;
  final bool isYours;
  final bool hasUnviewed;
  final String? time;

  StoryUser({
    required this.id,
    required this.name,
    required this.avatar,
    this.isYours = false,
    this.hasUnviewed = false,
    this.time,
  });
}
