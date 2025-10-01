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

  // Sample feed data
  final List<FeedPost> feedPosts = [
    FeedPost(
      id: '1',
      userName: 'Sarah Chen',
      userAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      timeAgo: '2h ago',
      content: 'Just finished my morning workout! 💪 Feeling energized and ready to tackle the day. Who else is hitting the gym today?',
      imageUrl: 'https://picsum.photos/400/300?random=1',
      likes: 156,
      comments: 23,
      shares: 12,
      isLiked: false,
      isVerified: true,
    ),
    FeedPost(
      id: '2',
      userName: 'Alex Rodriguez',
      userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      timeAgo: '4h ago',
      content: 'Amazing sunset from my office window today! 🌅 Sometimes the best views come when you least expect them.',
      imageUrl: 'https://picsum.photos/400/300?random=2',
      likes: 89,
      comments: 15,
      shares: 8,
      isLiked: true,
      isVerified: false,
    ),
    FeedPost(
      id: '3',
      userName: 'Maya Patel',
      userAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      timeAgo: '6h ago',
      content: 'Cooked my grandmother\'s secret recipe today! The kitchen smells incredible. Family recipes are the best kind of memories. 👩‍🍳✨',
      likes: 234,
      comments: 45,
      shares: 18,
      isLiked: false,
      isVerified: true,
    ),
    FeedPost(
      id: '4',
      userName: 'Jake Wilson',
      userAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      timeAgo: '8h ago',
      content: 'Late night coding session with some amazing coffee! ☕ Building something cool that I can\'t wait to share with you all.',
      imageUrl: 'https://picsum.photos/400/300?random=4',
      likes: 67,
      comments: 12,
      shares: 5,
      isLiked: true,
      isVerified: false,
    ),
    FeedPost(
      id: '5',
      userName: 'Emma Thompson',
      userAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
      timeAgo: '10h ago',
      content: 'Reading is my escape! 📚 Currently diving into this incredible sci-fi novel. What\'s everyone else reading these days?',
      imageUrl: 'https://picsum.photos/400/300?random=5',
      likes: 145,
      comments: 28,
      shares: 14,
      isLiked: false,
      isVerified: true,
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
          // Background particles
          ...List.generate(15, (index) => _buildBackgroundParticle(index)),
          
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
                                child: _buildFeedPost(feedPosts[index], index),
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
          
          // Floating create post button
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
      left: (index * 60.0) % MediaQuery.of(context).size.width,
      top: (index * 80.0) % MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(_shimmerController.value * 2 * math.pi + index) * 20,
              math.cos(_shimmerController.value * 2 * math.pi + index) * 15,
            ),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: [
                  AppTheme.neonPink,
                  AppTheme.neonBlue,
                  AppTheme.neonCyan,
                  AppTheme.neonPurple,
                ][index % 4].withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: [
                      AppTheme.neonPink,
                      AppTheme.neonBlue,
                      AppTheme.neonCyan,
                      AppTheme.neonPurple,
                    ][index % 4].withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
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
            child: Text(
              'Feed',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
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
          ),
          const Spacer(),
          
          // Notification icon
          FadeInRight(
            child: GestureDetector(
              onTap: () {
                // Navigate to notifications
                Get.toNamed('/notifications');
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonPink.withOpacity(0.2),
                      AppTheme.neonPurple.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppTheme.neonPink.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonPink.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_rounded,
                      color: AppTheme.neonPink,
                      size: 24,
                    ),
                    // Notification badge
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.neonCyan,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonCyan.withOpacity(0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
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

  Widget _buildCreatePostSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FadeInUp(
        child: GlassmorphismContainer(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // User avatar
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.neonBlue.withOpacity(0.3),
                        AppTheme.neonCyan.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: AppTheme.neonBlue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.neonBlue.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: AppTheme.neonBlue,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Create post text
                Expanded(
                  child: GestureDetector(
                    onTap: _showCreatePostModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Share what\'s on your mind...',
                        style: GoogleFonts.inter(
                          color: Colors.white60,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Media button
                GestureDetector(
                  onTap: _showCreatePostModal,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonCyan.withOpacity(0.2),
                          AppTheme.neonBlue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.neonCyan.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.image_rounded,
                      color: AppTheme.neonCyan,
                      size: 20,
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

  Widget _buildFeedPost(FeedPost post, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post header
              Row(
                children: [
                  // User avatar with premium ring
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.neonPink.withOpacity(0.3),
                              AppTheme.neonBlue.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.backgroundDark,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              post.userAvatar,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme.neonBlue.withOpacity(0.2),
                                  child: Icon(
                                    Icons.person,
                                    color: AppTheme.neonBlue,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      // Verified badge
                      if (post.isVerified)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppTheme.neonCyan,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.backgroundDark,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neonCyan.withOpacity(0.6),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.userName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // More options
                  GestureDetector(
                    onTap: () => _showPostOptions(post),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Post content
              Text(
                post.content,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              
              // Post image (if exists)
              if (post.imageUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white30,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Post actions
              Row(
                children: [
                  _buildActionButton(
                    icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                    label: post.likes.toString(),
                    color: post.isLiked ? AppTheme.neonPink : Colors.white60,
                    onTap: () => _toggleLike(post),
                  ),
                  const SizedBox(width: 24),
                  _buildActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: post.comments.toString(),
                    color: Colors.white60,
                    onTap: () => _showComments(post),
                  ),
                  const SizedBox(width: 24),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: post.shares.toString(),
                    color: Colors.white60,
                    onTap: () => _sharePost(post),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    icon: Icons.bookmark_border,
                    label: '',
                    color: Colors.white60,
                    onTap: () => _bookmarkPost(post),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFloatingCreateButton() {
    return GestureDetector(
      onTap: _showCreatePostModal,
      child: Container(
        width: 60,
        height: 60,
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
              color: AppTheme.neonBlue.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
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
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: GlassmorphismContainer(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Header
                Row(
                  children: [
                    Text(
                      'Create Post',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Create post content would go here
                Expanded(
                  child: Center(
                    child: Text(
                      'Create Post UI\nComing Soon!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
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
  });
}