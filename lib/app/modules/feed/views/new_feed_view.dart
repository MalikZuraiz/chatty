import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingPost = false;

  // Enhanced feed data with more variety
  final List<FeedPost> feedPosts = [
    FeedPost(
      id: '1',
      userName: 'Sarah Chen',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      timeAgo: '2h ago',
      content: 'Just finished an amazing workout session! 💪 The new gym has such incredible energy. Who else is ready to crush their fitness goals this week? Let\'s motivate each other! 🔥',
      imageUrl: 'https://picsum.photos/400/300?random=1',
      likes: 156,
      comments: 23,
      shares: 12,
      isLiked: false,
      isVerified: true,
      postType: PostType.image,
    ),
    FeedPost(
      id: '2',
      userName: 'Alex Rodriguez',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      timeAgo: '4h ago',
      content: 'Incredible sunset from my rooftop today! 🌅 Sometimes the most beautiful moments happen when you least expect them. Nature never fails to amaze me.',
      imageUrl: 'https://picsum.photos/400/300?random=2',
      likes: 89,
      comments: 15,
      shares: 8,
      isLiked: true,
      isVerified: false,
      postType: PostType.image,
    ),
    FeedPost(
      id: '3',
      userName: 'Maya Patel',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      timeAgo: '6h ago',
      content: 'Cooked my grandmother\'s secret recipe today! 👩‍🍳✨ The kitchen smells incredible and the memories this brings back are priceless. Family recipes are the best kind of legacy.',
      likes: 234,
      comments: 45,
      shares: 18,
      isLiked: false,
      isVerified: true,
      postType: PostType.text,
    ),
    FeedPost(
      id: '4',
      userName: 'Jake Wilson',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Jake',
      timeAgo: '8h ago',
      content: 'Late night coding session with some amazing coffee! ☕ Building something revolutionary that I can\'t wait to share with you all. The future is bright! 💻',
      imageUrl: 'https://picsum.photos/400/300?random=4',
      likes: 67,
      comments: 12,
      shares: 5,
      isLiked: true,
      isVerified: false,
      postType: PostType.image,
    ),
    FeedPost(
      id: '5',
      userName: 'Emma Thompson',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      timeAgo: '10h ago',
      content: 'Reading is my ultimate escape! 📚 Currently diving deep into this incredible sci-fi novel that\'s blowing my mind. What\'s everyone else reading these days? Drop recommendations! 🚀',
      imageUrl: 'https://picsum.photos/400/300?random=5',
      likes: 145,
      comments: 28,
      shares: 14,
      isLiked: false,
      isVerified: true,
      postType: PostType.image,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_showFloatingPost) {
        setState(() => _showFloatingPost = true);
      } else if (_scrollController.offset <= 100 && _showFloatingPost) {
        setState(() => _showFloatingPost = false);
      }
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Dynamic background particles
          ...List.generate(20, (index) => _buildBackgroundParticle(index)),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildPremiumHeader(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    backgroundColor: AppTheme.backgroundDark,
                    color: AppTheme.neonCyan,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: _buildCreatePostSection(),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return FadeInUp(
                                duration: Duration(milliseconds: 300 + (index * 100)),
                                child: _buildUniquePostCard(feedPosts[index], index),
                              );
                            },
                            childCount: feedPosts.length,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Enhanced floating create post button
          if (_showFloatingPost)
            Positioned(
              bottom: 30,
              right: 20,
              child: FadeInUp(
                child: _buildFloatingCreateButton(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackgroundParticle(int index) {
    return Positioned(
      left: (index * 80.0) % MediaQuery.of(context).size.width,
      top: (index * 100.0) % MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(_shimmerController.value * 2 * math.pi + index) * 30,
              math.cos(_shimmerController.value * 2 * math.pi + index) * 20,
            ),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: [
                  AppTheme.neonPink,
                  AppTheme.neonBlue,
                  AppTheme.neonCyan,
                  AppTheme.neonPurple,
                ][index % 4].withOpacity(0.4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: [
                      AppTheme.neonPink,
                      AppTheme.neonBlue,
                      AppTheme.neonCyan,
                      AppTheme.neonPurple,
                    ][index % 4].withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          FadeInLeft(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feed',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: AppTheme.neonCyan.withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Discover amazing stories',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white60,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          
          // Enhanced notification icon
          FadeInRight(
            child: GestureDetector(
              onTap: () {
                Get.toNamed('/notifications');
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonPink.withOpacity(0.2),
                      AppTheme.neonPurple.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.neonPink.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonPink.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_rounded,
                      color: AppTheme.neonPink,
                      size: 26,
                    ),
                    // Pulsing notification badge
                    Positioned(
                      top: -2,
                      right: -2,
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.neonCyan,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonCyan.withOpacity(
                                    0.6 + 0.4 * math.sin(_shimmerController.value * 2 * math.pi),
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '3',
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
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

  Widget _buildCreatePostSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FadeInUp(
        child: Stack(
          children: [
            // Background glow
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonBlue.withOpacity(0.1),
                      AppTheme.neonCyan.withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonBlue.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            GlassmorphismContainer(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Enhanced user avatar
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.neonBlue,
                            AppTheme.neonCyan,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.neonBlue.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.backgroundDark,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://api.dicebear.com/7.x/avataaars/png?seed=User',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.neonBlue.withOpacity(0.3),
                                      AppTheme.neonCyan.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: AppTheme.neonBlue,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Enhanced create post text
                    Expanded(
                      child: GestureDetector(
                        onTap: _showCreatePostModal,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.08),
                                Colors.white.withOpacity(0.03),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Share your thoughts with the world...',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Enhanced media buttons
                    Row(
                      children: [
                        _buildMediaButton(
                          icon: Icons.image_rounded,
                          color: AppTheme.neonCyan,
                          onTap: _showCreatePostModal,
                        ),
                        const SizedBox(width: 8),
                        _buildMediaButton(
                          icon: Icons.videocam_rounded,
                          color: AppTheme.neonPurple,
                          onTap: _showCreatePostModal,
                        ),
                      ],
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

  Widget _buildMediaButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
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
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildUniquePostCard(FeedPost post, int index) {
    final isEven = index % 2 == 0;
    final cardColor = [
      AppTheme.neonPink,
      AppTheme.neonBlue,
      AppTheme.neonCyan,
      AppTheme.neonPurple,
    ][index % 4];

    return Container(
      margin: EdgeInsets.only(
        left: isEven ? 16 : 40,
        right: isEven ? 40 : 16,
        bottom: 24,
      ),
      child: Stack(
        children: [
          // Dynamic background glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    cardColor.withOpacity(0.15),
                    cardColor.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withOpacity(0.25),
                    blurRadius: 25,
                    spreadRadius: 3,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          
          // Main post container
          GlassmorphismContainer(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revolutionary header design
                  _buildPostHeader(post, cardColor, index),
                  
                  const SizedBox(height: 20),
                  
                  // Enhanced content section
                  _buildPostContent(post, cardColor),
                  
                  // Enhanced image display
                  if (post.imageUrl != null) 
                    _buildPostImage(post, cardColor),
                  
                  const SizedBox(height: 20),
                  
                  // Revolutionary action bar
                  _buildPostActions(post, cardColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader(FeedPost post, Color cardColor, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            const SizedBox(width: 80), // Space for floating avatar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.userName,
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (post.isVerified) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.neonCyan, AppTheme.neonBlue],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonCyan.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'VERIFIED',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cardColor.withOpacity(0.2),
                          cardColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: cardColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: cardColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          post.timeAgo,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: cardColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Enhanced more options
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
        
        // Revolutionary floating avatar
        Positioned(
          left: -15,
          top: -15,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  cardColor,
                  cardColor.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: cardColor.withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.backgroundDark,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  post.userAvatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cardColor.withOpacity(0.3),
                            cardColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: cardColor,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent(FeedPost post, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        post.content,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildPostImage(FeedPost post, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            cardColor.withOpacity(0.3),
            cardColor.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppTheme.backgroundDark,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.network(
            post.imageUrl!,
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cardColor.withOpacity(0.1),
                      cardColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: cardColor.withOpacity(0.5),
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Image not available',
                      style: GoogleFonts.inter(
                        color: cardColor.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPostActions(FeedPost post, Color cardColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEnhancedActionButton(
            icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            label: post.likes.toString(),
            color: post.isLiked ? AppTheme.neonPink : Colors.white60,
            glowColor: AppTheme.neonPink,
            onTap: () => _toggleLike(post),
            isActive: post.isLiked,
          ),
          _buildEnhancedActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: post.comments.toString(),
            color: Colors.white60,
            glowColor: AppTheme.neonBlue,
            onTap: () => _showComments(post),
          ),
          _buildEnhancedActionButton(
            icon: Icons.share_rounded,
            label: post.shares.toString(),
            color: Colors.white60,
            glowColor: AppTheme.neonCyan,
            onTap: () => _sharePost(post),
          ),
          _buildEnhancedActionButton(
            icon: Icons.bookmark_border_rounded,
            label: '',
            color: Colors.white60,
            glowColor: cardColor,
            onTap: () => _bookmarkPost(post),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color glowColor,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(
            colors: [
              glowColor.withOpacity(0.25),
              glowColor.withOpacity(0.1),
            ],
          ) : null,
          borderRadius: BorderRadius.circular(15),
          border: isActive ? Border.all(
            color: glowColor.withOpacity(0.5),
            width: 1,
          ) : null,
          boxShadow: isActive ? [
            BoxShadow(
              color: glowColor.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCreateButton() {
    return GestureDetector(
      onTap: _showCreatePostModal,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.neonBlue,
              AppTheme.neonCyan,
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonBlue.withOpacity(0.5),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  void _showCreatePostModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: GlassmorphismContainer(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                // Enhanced handle
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.neonCyan, AppTheme.neonBlue],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 25),
                
                // Enhanced header
                Row(
                  children: [
                    Text(
                      'Create Post',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Enhanced content area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonBlue.withOpacity(0.1),
                          AppTheme.neonCyan.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.neonBlue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 60,
                            color: AppTheme.neonBlue,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Advanced Post Creator',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Coming Soon!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white60,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPostOptions(FeedPost post) {
    // Show post options modal
  }

  void _toggleLike(FeedPost post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
  }

  void _showComments(FeedPost post) {
    // Show comments modal
  }

  void _sharePost(FeedPost post) {
    // Share post functionality
  }

  void _bookmarkPost(FeedPost post) {
    // Bookmark post functionality
  }
}

enum PostType { text, image, video, poll }

class FeedPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  int likes;
  final int comments;
  final int shares;
  bool isLiked;
  final bool isVerified;
  final PostType postType;

  FeedPost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isLiked,
    required this.isVerified,
    required this.postType,
  });
}