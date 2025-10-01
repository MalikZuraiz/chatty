import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PremiumStoriesView extends StatefulWidget {
  const PremiumStoriesView({super.key});

  @override
  State<PremiumStoriesView> createState() => _PremiumStoriesViewState();
}

class _PremiumStoriesViewState extends State<PremiumStoriesView> with TickerProviderStateMixin {
  bool isGridView = false;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  final List<StoryUser> stories = [
    StoryUser(
      id: '1',
      name: 'Your Story',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=YourStory',
      isYours: true,
      hasUnviewed: false,
      storyCount: 0,
      category: 'personal',
    ),
    StoryUser(
      id: '2',
      name: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      hasUnviewed: true,
      time: '2h ago',
      storyCount: 3,
      category: 'friend',
    ),
    StoryUser(
      id: '3',
      name: 'Alex Jordan',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      hasUnviewed: true,
      time: '4h ago',
      storyCount: 1,
      category: 'friend',
    ),
    StoryUser(
      id: '4',
      name: 'Maya Patel',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      hasUnviewed: false,
      time: '8h ago',
      storyCount: 5,
      category: 'close',
    ),
    StoryUser(
      id: '5',
      name: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      hasUnviewed: true,
      time: '10h ago',
      storyCount: 2,
      category: 'work',
    ),
    StoryUser(
      id: '6',
      name: 'Emma Wilson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      hasUnviewed: false,
      time: '12h ago',
      storyCount: 4,
      category: 'friend',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A0712),
            const Color(0xFF1A1A2E).withOpacity(0.95),
            const Color(0xFF2D1B3D).withOpacity(0.3),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(),
            Expanded(
              child: isGridView ? _buildPremiumGrid() : _buildPremiumCarousel(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Animated gradient text
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                const Color(0xFFFF006E),
                const Color(0xFFFF6B9D),
                const Color(0xFFFFC6D9),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: Text(
              'Stories',
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Live indicator
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xFFFF006E),
                        const Color(0xFFFF6B9D),
                        _pulseController.value,
                      )!,
                      Color.lerp(
                        const Color(0xFFFF6B9D),
                        const Color(0xFFFF006E),
                        _pulseController.value,
                      )!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF006E).withOpacity(0.5 * _pulseController.value),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          _buildGlassButton(
            icon: isGridView ? Icons.view_carousel_rounded : Icons.grid_view_rounded,
            onTap: () => setState(() => isGridView = !isGridView),
          ),
          const SizedBox(width: 12),
          _buildGlassButton(
            icon: Icons.add_circle_outline_rounded,
            onTap: _showCreateStory,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // PREMIUM CAROUSEL VIEW - Horizontal scrolling with 3D effects
  Widget _buildPremiumCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Today',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.5),
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return _buildPremiumStoryCard(stories[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumStoryCard(StoryUser story, int index) {
    return GestureDetector(
      onTap: () => _viewStory(story),
      child: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 40, top: 10),
        child: Stack(
          children: [
            // Main card with hero image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: story.hasUnviewed
                        ? const Color(0xFFFF006E).withOpacity(0.3)
                        : Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    CachedNetworkImage(
                      imageUrl: story.avatar,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    
                    // Gradient overlays
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                    
                    // Border gradient for unviewed
                    if (story.hasUnviewed)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            width: 3,
                            color: Colors.transparent,
                          ),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF006E),
                              Color(0xFFFF6B9D),
                              Color(0xFFFFC6D9),
                              Color(0xFFFF6B9D),
                              Color(0xFFFF006E),
                            ],
                          ),
                        ),
                      ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top section with avatar
                          Row(
                            children: [
                              if (story.isYours)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF006E).withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                )
                              else
                                Container(
                                  width: 60,
                                  height: 60,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: story.hasUnviewed
                                        ? const LinearGradient(
                                            colors: [Color(0xFFFF006E), Color(0xFFFFC6D9)],
                                          )
                                        : null,
                                    color: story.hasUnviewed ? null : Colors.white.withOpacity(0.2),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF1A1A2E), width: 3),
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: story.avatar,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              // Story count badge
                              if (!story.isYours)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: Color(0xFFFF6B9D),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${story.storyCount}',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          
                          const Spacer(),
                          
                          // Bottom section with name and details
                          Text(
                            story.isYours ? 'Add Your Story' : story.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!story.isYours)
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  story.time ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(story.category).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getCategoryColor(story.category).withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _getCategoryLabel(story.category),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _getCategoryColor(story.category),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Floating play button for unviewed
            if (story.hasUnviewed && !story.isYours)
              Positioned(
                right: 24,
                bottom: 60,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFFFF006E),
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // PREMIUM GRID VIEW - Masonry style with varied heights
  Widget _buildPremiumGrid() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final story = stories[index];
                final isLarge = index % 3 == 0;
                return _buildGridStoryCard(story, isLarge);
              },
              childCount: stories.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridStoryCard(StoryUser story, bool isLarge) {
    return GestureDetector(
      onTap: () => _viewStory(story),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: story.hasUnviewed
                  ? const Color(0xFFFF006E).withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              CachedNetworkImage(
                imageUrl: story.avatar,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              
              // Unviewed border
              if (story.hasUnviewed)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      width: 3,
                      color: const Color(0xFFFF006E),
                    ),
                  ),
                ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar badge
                    if (story.isYours)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)],
                          ),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: story.hasUnviewed
                              ? const LinearGradient(
                                  colors: [Color(0xFFFF006E), Color(0xFFFFC6D9)],
                                )
                              : null,
                          color: story.hasUnviewed ? null : Colors.white.withOpacity(0.2),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: story.avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Name
                    Text(
                      story.isYours ? 'Your\nStory' : story.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                    ),
                    
                    if (!story.isYours) ...[
                      const SizedBox(height: 4),
                      Text(
                        story.time ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'close':
        return const Color(0xFFFF006E);
      case 'friend':
        return const Color(0xFF00D4FF);
      case 'work':
        return const Color(0xFF06FFA5);
      case 'personal':
        return const Color(0xFF8B5CF6);
      default:
        return Colors.white;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'close':
        return 'CLOSE FRIEND';
      case 'friend':
        return 'FRIEND';
      case 'work':
        return 'WORK';
      case 'personal':
        return 'PERSONAL';
      default:
        return '';
    }
  }

  void _viewStory(StoryUser story) {
    if (story.isYours) {
      _showCreateStory();
    } else {
      // TODO: Navigate to story viewer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Viewing ${story.name}\'s story'),
          backgroundColor: const Color(0xFF1A1A2E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showCreateStory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF2D1B3D),
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFF006E), Color(0xFFFFC6D9)],
              ).createShader(bounds),
              child: Text(
                'Create Story',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCreateOption(
                    Icons.camera_alt_rounded,
                    'Camera',
                    const LinearGradient(colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)]),
                  ),
                  _buildCreateOption(
                    Icons.photo_library_rounded,
                    'Gallery',
                    const LinearGradient(colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)]),
                  ),
                  _buildCreateOption(
                    Icons.text_fields_rounded,
                    'Text',
                    const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFB794F6)]),
                  ),
                  _buildCreateOption(
                    Icons.brush_rounded,
                    'Create',
                    const LinearGradient(colors: [Color(0xFFFFA500), Color(0xFFFFD700)]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption(IconData icon, String label, Gradient gradient) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
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
  final int storyCount;
  final String category;

  StoryUser({
    required this.id,
    required this.name,
    required this.avatar,
    this.isYours = false,
    this.hasUnviewed = false,
    this.time,
    this.storyCount = 0,
    this.category = 'friend',
  });
}
