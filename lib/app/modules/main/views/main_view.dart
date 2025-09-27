import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../../stories/views/story_viewer_screen.dart';
import '../../stories/controllers/story_controller.dart';

import '../../chat_list/views/chat_list_view.dart';
import '../../profile/views/simple_profile_view.dart';
import '../../feed/views/simple_feed_view.dart';

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
    const FeedView(), // Feed view
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
      icon: Icons.dynamic_feed_outlined,
      activeIcon: Icons.dynamic_feed_rounded,
      label: 'Feed',
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

class _StoriesView extends StatefulWidget {
  const _StoriesView();

  @override
  State<_StoriesView> createState() => __StoriesViewState();
}

class __StoriesViewState extends State<_StoriesView> with TickerProviderStateMixin {
  late AnimationController _shimmerController;

  // Premium dummy stories data
  final List<StoryModel> stories = [
    StoryModel(
      id: '1',
      userName: 'Your Story',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=YourStory',
      isMyStory: true,
      hasUnviewedStories: false,
      stories: [],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StoryModel(
      id: '2',
      userName: 'Sarah Chen',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      isMyStory: false,
      hasUnviewedStories: true,
      stories: ['story1', 'story2'],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    StoryModel(
      id: '3',
      userName: 'Alex Jordan',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      isMyStory: false,
      hasUnviewedStories: true,
      stories: ['story1'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    StoryModel(
      id: '4',
      userName: 'Maya Patel',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      isMyStory: false,
      hasUnviewedStories: false,
      stories: ['story1', 'story2', 'story3'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    StoryModel(
      id: '5',
      userName: 'David Kim',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      isMyStory: false,
      hasUnviewedStories: true,
      stories: ['story1', 'story2'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    StoryModel(
      id: '6',
      userName: 'Emma Wilson',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      isMyStory: false,
      hasUnviewedStories: false,
      stories: ['story1'],
      lastUpdated: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Premium floating particles
          ...List.generate(12, (index) => 
            _FloatingStoryParticle(key: ValueKey('story_particle_$index'), index: index)
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Premium header with glassmorphism
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: GlassmorphismContainer(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.neonPink.withOpacity(0.1),
                              AppTheme.neonPurple.withOpacity(0.1),
                              AppTheme.neonCyan.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: AppTheme.neonPink.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Premium Stories icon
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [AppTheme.neonPink, AppTheme.neonPurple],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.neonPink.withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Premium Stories',
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  'Discover amazing moments',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            
                            // Action buttons with neon effects
                            _buildNeonActionButton(
                              icon: Icons.search_rounded,
                              color: AppTheme.neonCyan,
                              onTap: () => _showSearchStories(),
                            ),
                            const SizedBox(width: 12),
                            _buildNeonActionButton(
                              icon: Icons.camera_alt_rounded,
                              color: AppTheme.neonPink,
                              onTap: () => _createStory(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Premium Stories Creative Layout
                Expanded(
                  child: _buildCreativeStoriesLayout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.3),
              color.withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }





  void _createStory() {
    // Show premium story creation options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: GlassmorphismContainer(
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
                
                Text(
                  'Create Story',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStoryOption(
                      icon: Icons.camera_alt,
                      title: 'Camera',
                      color: AppTheme.neonBlue,
                      onTap: () {},
                    ),
                    _buildStoryOption(
                      icon: Icons.photo_library,
                      title: 'Gallery',
                      color: AppTheme.neonPurple,
                      onTap: () {},
                    ),
                    _buildStoryOption(
                      icon: Icons.text_fields,
                      title: 'Text',
                      color: AppTheme.neonCyan,
                      onTap: () {},
                    ),
                    _buildStoryOption(
                      icon: Icons.brush,
                      title: 'Doodle',
                      color: AppTheme.neonPink,
                      onTap: () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeStoriesLayout() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        slivers: [
          // "Your Story" section with unique design
          SliverToBoxAdapter(
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: _buildYourStorySection(),
            ),
          ),
          
          // Main stories in creative staggered grid
          SliverPadding(
            padding: const EdgeInsets.only(top: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final storyIndex = index + 1; // Skip "Your Story"
                  if (storyIndex >= stories.length) return null;
                  
                  final story = stories[storyIndex];
                  return FadeInUp(
                    duration: Duration(milliseconds: 800 + (index * 100)),
                    child: _buildCreativeStoryCard(story, index),
                  );
                },
                childCount: stories.length - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourStorySection() {
    final yourStory = stories.first;
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            AppTheme.neonPurple.withOpacity(0.2),
            AppTheme.neonPink.withOpacity(0.2),
            AppTheme.neonCyan.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.neonPurple.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPurple.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppTheme.neonPurple.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Your avatar with special effects
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.neonPurple, AppTheme.neonPink],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonPurple.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(yourStory.userAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    
                    // Plus button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.neonCyan,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.backgroundDark,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonCyan.withOpacity(0.8),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 20),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Story',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share your premium moments',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Action button
                      GestureDetector(
                        onTap: () => _createStory(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.neonCyan, AppTheme.neonBlue],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonCyan.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'Create Story',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
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
          
          // Tap area
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _createStory(),
              borderRadius: BorderRadius.circular(25),
              splashColor: AppTheme.neonPurple.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeStoryCard(StoryModel story, int index) {
    final colors = [
      [AppTheme.neonPink, AppTheme.neonPurple],
      [AppTheme.neonCyan, AppTheme.neonBlue],
      [AppTheme.neonBlue, AppTheme.neonPurple],
      [AppTheme.neonPurple, AppTheme.neonPink],
      [AppTheme.neonCyan, AppTheme.neonPink],
    ];
    
    final cardColors = colors[index % colors.length];
    final isEven = index % 2 == 0;
    
    return Container(
      margin: EdgeInsets.only(
        top: isEven ? 0 : 20,
        bottom: isEven ? 20 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColors[0].withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                cardColors[0].withOpacity(0.2),
                cardColors[1].withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: cardColors[0].withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with neon ring
                    Stack(
                      children: [
                        if (story.hasUnviewedStories)
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: cardColors),
                              boxShadow: [
                                BoxShadow(
                                  color: cardColors[0].withOpacity(0.6),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: story.hasUnviewedStories 
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              story.userAvatar,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: cardColors[0].withOpacity(0.2),
                                  child: Icon(
                                    Icons.person,
                                    color: cardColors[0],
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // User name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        story.userName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Time and story count
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: cardColors[0],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: cardColors[0].withOpacity(0.8),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimeAgo(story.lastUpdated),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: cardColors[0].withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: cardColors[0].withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${story.stories.length}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: cardColors[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tap effect
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _viewStory(story),
                  borderRadius: BorderRadius.circular(20),
                  splashColor: cardColors[0].withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showSearchStories() {
    // Premium story search functionality
    Get.snackbar(
      'Search Stories',
      '🔍 Premium story search coming soon!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.neonCyan.withOpacity(0.1),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  void _viewStory(StoryModel story) {
    if (story.isMyStory) {
      _createStory();
    } else {
      // Navigate to premium story viewer with controller binding
      Get.put(StoryController());
      Get.to(
        () => const StoryViewerScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}

// Premium Story Model
class StoryModel {
  final String id;
  final String userName;
  final String userAvatar;
  final bool isMyStory;
  final bool hasUnviewedStories;
  final List<String> stories;
  final DateTime lastUpdated;

  StoryModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.isMyStory,
    required this.hasUnviewedStories,
    required this.stories,
    required this.lastUpdated,
  });
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
      duration: Duration(seconds: 10 + widget.index * 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _startX = math.Random().nextDouble() * 350;
    _startY = math.Random().nextDouble() * 700 + 100;

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
    final shapes = [Icons.star, Icons.favorite, Icons.auto_awesome, Icons.circle];
    final shape = shapes[widget.index % shapes.length];
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _startX + math.sin(_animation.value * math.pi * 2) * 40,
          top: _startY - (_animation.value * 900),
          child: Opacity(
            opacity: (1 - _animation.value) * 0.6,
            child: Transform.rotate(
              angle: _animation.value * math.pi * 4,
              child: Container(
                width: 8 + (widget.index % 4) * 3,
                height: 8 + (widget.index % 4) * 3,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: shape == Icons.circle ? null : Icon(
                  shape,
                  color: Colors.white,
                  size: 6 + (widget.index % 3) * 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}