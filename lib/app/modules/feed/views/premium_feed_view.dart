import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PremiumFeedView extends StatefulWidget {
  const PremiumFeedView({super.key});

  @override
  State<PremiumFeedView> createState() => _PremiumFeedViewState();
}

class _PremiumFeedViewState extends State<PremiumFeedView> with TickerProviderStateMixin {
  bool isHorizontalScroll = true;
  late PageController _pageController;
  int currentPage = 0;

  final List<FeedPost> posts = [
    FeedPost(
      id: '1',
      username: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      content: 'Just witnessed the most beautiful sunset at the beach! Nature never fails to amaze me 🌅✨',
      imageUrl: 'https://picsum.photos/400/600?random=1',
      timestamp: '2 hours ago',
      likes: 234,
      comments: 45,
      isLiked: false,
      category: 'lifestyle',
      tags: ['sunset', 'nature', 'beach'],
    ),
    FeedPost(
      id: '2',
      username: 'Alex Jordan',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      content: 'New project launch! So proud of what our team has accomplished 🚀',
      imageUrl: 'https://picsum.photos/400/500?random=2',
      timestamp: '4 hours ago',
      likes: 567,
      comments: 89,
      isLiked: true,
      category: 'work',
      tags: ['startup', 'tech', 'launch'],
    ),
    FeedPost(
      id: '3',
      username: 'Maya Patel',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      content: 'Exploring the hidden gems of the city. Every corner tells a story! 📸',
      imageUrl: 'https://picsum.photos/400/700?random=3',
      timestamp: '6 hours ago',
      likes: 892,
      comments: 123,
      isLiked: true,
      category: 'travel',
      tags: ['urban', 'photography', 'explore'],
    ),
    FeedPost(
      id: '4',
      username: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      content: 'Morning coffee ritual ☕️ Starting the day right!',
      imageUrl: 'https://picsum.photos/400/400?random=4',
      timestamp: '8 hours ago',
      likes: 445,
      comments: 67,
      isLiked: false,
      category: 'food',
      tags: ['coffee', 'morning', 'lifestyle'],
    ),
    FeedPost(
      id: '5',
      username: 'Emma Wilson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      content: 'Fitness journey update! Consistency is key 💪',
      imageUrl: 'https://picsum.photos/400/550?random=5',
      timestamp: '10 hours ago',
      likes: 678,
      comments: 91,
      isLiked: true,
      category: 'fitness',
      tags: ['workout', 'motivation', 'health'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            Color(0xFF0A0712),
            Color(0xFF1A1A2E),
            Color(0xFF0F3A2F),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(),
            Expanded(
              child: isHorizontalScroll
                  ? _buildHorizontalMagazineView()
                  : _buildVerticalMasonryView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        children: [
          // Gradient text
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF06FFA5),
                Color(0xFF00D4FF),
                Color(0xFF06FFA5),
              ],
            ).createShader(bounds),
            child: Text(
              'Feed',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF06FFA5), Color(0xFF00D4FF)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF06FFA5).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
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
                  'FRESH',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildGlassButton(
            icon: Icons.filter_list_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildGlassButton(
            icon: isHorizontalScroll
                ? Icons.view_agenda_rounded
                : Icons.view_carousel_rounded,
            onTap: () => setState(() => isHorizontalScroll = !isHorizontalScroll),
            gradient: const LinearGradient(
              colors: [Color(0xFF06FFA5), Color(0xFF00D4FF)],
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

  // HORIZONTAL MAGAZINE VIEW - Premium card-based scrolling
  Widget _buildHorizontalMagazineView() {
    return Column(
      children: [
        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              posts.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: currentPage == index
                      ? const LinearGradient(
                          colors: [Color(0xFF06FFA5), Color(0xFF00D4FF)],
                        )
                      : null,
                  color: currentPage == index ? null : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        
        // Horizontal scrolling posts
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _buildMagazineCard(posts[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMagazineCard(FeedPost post, int index) {
    final isActive = currentPage == index;
    
    return AnimatedScale(
      scale: isActive ? 1.0 : 0.92,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: _getCategoryColor(post.category).withOpacity(0.3),
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
              // Background image with parallax effect
              CachedNetworkImage(
                imageUrl: post.imageUrl,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.3),
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top section - User info
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _getCategoryColor(post.category),
                                _getCategoryColor(post.category).withOpacity(0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _getCategoryColor(post.category).withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF0A0712), width: 2),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: post.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(post.category).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _getCategoryColor(post.category).withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      post.category.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: _getCategoryColor(post.category),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    post.timestamp,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // More options
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Middle section - Tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: post.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bottom section - Content
                    Text(
                      post.content,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Actions row
                    Row(
                      children: [
                        _buildActionButton(
                          icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          label: _formatCount(post.likes),
                          isActive: post.isLiked,
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: _formatCount(post.comments),
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          icon: Icons.send_rounded,
                          label: 'Share',
                          onTap: () {},
                        ),
                        const Spacer(),
                        _buildActionButton(
                          icon: Icons.bookmark_border_rounded,
                          label: '',
                          onTap: () {},
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
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: label.isEmpty ? 12 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)],
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF006E).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // VERTICAL MASONRY VIEW - Pinterest-style with staggered cards
  Widget _buildVerticalMasonryView() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildMasonryCard(posts[index], index);
              },
              childCount: posts.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMasonryCard(FeedPost post, int index) {
    // Alternate between different layouts
    final isCompact = index % 3 == 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColor(post.category).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      height: isCompact ? 200 : 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black.withOpacity(0.2),
                    ),
                    
                    // Gradient overlay on image
                    Container(
                      height: isCompact ? 200 : 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    
                    // User info overlay on image
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  _getCategoryColor(post.category),
                                  _getCategoryColor(post.category).withOpacity(0.6),
                                ],
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: post.avatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.username,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  post.timestamp,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(post.category).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _getCategoryColor(post.category).withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              post.category.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Content section
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Content text
                      Text(
                        post.content,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        maxLines: isCompact ? 2 : 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: post.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '#$tag',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Actions
                      Row(
                        children: [
                          _buildCompactAction(
                            icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            label: _formatCount(post.likes),
                            isActive: post.isLiked,
                          ),
                          const SizedBox(width: 16),
                          _buildCompactAction(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: _formatCount(post.comments),
                          ),
                          const SizedBox(width: 16),
                          _buildCompactAction(
                            icon: Icons.send_rounded,
                            label: 'Share',
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.bookmark_border_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactAction({
    required IconData icon,
    required String label,
    bool isActive = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFFFF006E) : Colors.white.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFFFF006E) : Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'lifestyle':
        return const Color(0xFFFF006E);
      case 'work':
        return const Color(0xFF00D4FF);
      case 'travel':
        return const Color(0xFF8B5CF6);
      case 'food':
        return const Color(0xFFFFA500);
      case 'fitness':
        return const Color(0xFF06FFA5);
      default:
        return const Color(0xFF00D4FF);
    }
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class FeedPost {
  final String id;
  final String username;
  final String avatar;
  final String content;
  final String imageUrl;
  final String timestamp;
  final int likes;
  final int comments;
  final bool isLiked;
  final String category;
  final List<String> tags;

  FeedPost({
    required this.id,
    required this.username,
    required this.avatar,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    this.category = 'lifestyle',
    this.tags = const [],
  });
}
