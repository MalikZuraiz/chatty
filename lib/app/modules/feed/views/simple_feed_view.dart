import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final List<FeedPost> posts = [
    FeedPost(
      id: '1',
      username: 'Sarah Chen',
      avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      content: 'Just finished building an amazing Flutter app! 🚀',
      imageUrl: 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=400&h=300&fit=crop',
      timestamp: '2 hours ago',
      likes: 24,
      comments: 8,
      isLiked: false,
    ),
    FeedPost(
      id: '2',
      username: 'Alex Wilson',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      content: 'Beautiful sunset today! Nature never fails to amaze me 🌅',
      imageUrl: 'https://images.unsplash.com/photo-1566737236500-c8ac43014a8e?w=400&h=300&fit=crop',
      timestamp: '4 hours ago',
      likes: 67,
      comments: 12,
      isLiked: true,
    ),
    FeedPost(
      id: '3',
      username: 'Maya Johnson',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      content: 'Working on some exciting new designs. Can\'t wait to share! ✨',
      imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=400&h=300&fit=crop',
      timestamp: '6 hours ago',
      likes: 31,
      comments: 5,
      isLiked: false,
    ),
    FeedPost(
      id: '4',
      username: 'Emma Davis',
      avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
      content: 'Coffee and code - the perfect combination for a productive day! ☕',
      imageUrl: 'https://images.unsplash.com/photo-1461988320302-91bde64fc8e4?w=400&h=300&fit=crop',
      timestamp: '8 hours ago',
      likes: 89,
      comments: 23,
      isLiked: true,
    ),
    FeedPost(
      id: '5',
      username: 'David Kim',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      content: 'Amazing tech conference today! Learned so much about AI and machine learning 🤖',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop',
      timestamp: '12 hours ago',
      likes: 156,
      comments: 34,
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshFeed,
                backgroundColor: const Color(0xFF1E1E1E),
                color: AppTheme.neonCyan,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return _buildPostCard(posts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        backgroundColor: AppTheme.neonCyan,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Feed',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(FeedPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(post.avatar),
                    backgroundColor: AppTheme.neonCyan.withOpacity(0.2),
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
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          post.timestamp,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Post content
              Text(
                post.content,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
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
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: Colors.grey,
                          size: 40,
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
                    color: post.isLiked ? AppTheme.neonPink : Colors.white.withOpacity(0.6),
                    onTap: () => _toggleLike(post),
                  ),
                  const SizedBox(width: 20),
                  _buildActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: post.comments.toString(),
                    color: Colors.white.withOpacity(0.6),
                    onTap: () => _showComments(post),
                  ),
                  const SizedBox(width: 20),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    color: Colors.white.withOpacity(0.6),
                    onTap: () => _sharePost(post),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshFeed() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh logic here
  }

  void _createPost() {
    // Navigate to create post screen
  }

  void _toggleLike(FeedPost post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
  }

  void _showComments(FeedPost post) {
    // Show comments bottom sheet
  }

  void _sharePost(FeedPost post) {
    // Share post logic
  }
}

class FeedPost {
  final String id;
  final String username;
  final String avatar;
  final String content;
  final String? imageUrl;
  final String timestamp;
  int likes;
  final int comments;
  bool isLiked;

  FeedPost({
    required this.id,
    required this.username,
    required this.avatar,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });
}