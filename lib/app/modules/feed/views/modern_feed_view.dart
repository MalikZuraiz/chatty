import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ModernFeedView extends StatefulWidget {
  const ModernFeedView({super.key});

  @override
  State<ModernFeedView> createState() => _ModernFeedViewState();
}

class _ModernFeedViewState extends State<ModernFeedView> {
  bool isHorizontalScroll = false;

  final List<FeedPost> posts = [
    FeedPost(
      id: '1',
      username: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      content: 'Just finished building an amazing Flutter app! 🚀',
      imageUrl: 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=600&h=400&fit=crop',
      timestamp: '2 hours ago',
      likes: 24,
      comments: 8,
      isLiked: false,
    ),
    FeedPost(
      id: '2',
      username: 'Alex Wilson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      content: 'Beautiful sunset today! Nature never fails to amaze me 🌅',
      imageUrl: 'https://images.unsplash.com/photo-1566737236500-c8ac43014a8e?w=600&h=400&fit=crop',
      timestamp: '4 hours ago',
      likes: 67,
      comments: 12,
      isLiked: true,
    ),
    FeedPost(
      id: '3',
      username: 'Maya Johnson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      content: 'Working on some exciting new designs. Can\'t wait to share! ✨',
      imageUrl: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=600&h=400&fit=crop',
      timestamp: '6 hours ago',
      likes: 31,
      comments: 5,
      isLiked: false,
    ),
    FeedPost(
      id: '4',
      username: 'Emma Davis',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      content: 'Coffee and code - the perfect combination for a productive day! ☕',
      imageUrl: 'https://images.unsplash.com/photo-1461988320302-91bde64fc8e4?w=600&h=400&fit=crop',
      timestamp: '8 hours ago',
      likes: 89,
      comments: 23,
      isLiked: true,
    ),
    FeedPost(
      id: '5',
      username: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      content: 'Amazing tech conference today! Learned so much about AI 🤖',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&h=400&fit=crop',
      timestamp: '12 hours ago',
      likes: 156,
      comments: 34,
      isLiked: false,
    ),
  ];

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
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: isHorizontalScroll ? _buildHorizontalView() : _buildVerticalView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${posts.length} new posts',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildActionButton(
            icon: isHorizontalScroll ? Icons.view_column_rounded : Icons.view_carousel_rounded,
            onTap: () => setState(() => isHorizontalScroll = !isHorizontalScroll),
            color: const Color(0xFF06FFA5),
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            icon: Icons.add_circle_rounded,
            onTap: _createPost,
            color: const Color(0xFF00D4FF),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _buildVerticalView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      itemCount: posts.length,
      itemBuilder: (context, index) => _buildPostCard(posts[index]),
    );
  }

  Widget _buildHorizontalView() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: posts.length,
      itemBuilder: (context, index) => _buildFullScreenPost(posts[index]),
    );
  }

  Widget _buildPostCard(FeedPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post),
          if (post.content.isNotEmpty) _buildPostContent(post),
          if (post.imageUrl != null) _buildPostImage(post),
          _buildPostActions(post),
        ],
      ),
    );
  }

  Widget _buildFullScreenPost(FeedPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (post.imageUrl != null)
                      CachedNetworkImage(
                        imageUrl: post.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.white.withOpacity(0.05),
                          child: const Icon(Icons.image, color: Colors.white30),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: _buildPostHeaderOverlay(post),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.content,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.4,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          _buildPostActionsOverlay(post),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPostHeader(FeedPost post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF06FFA5).withOpacity(0.3),
                  const Color(0xFF00D4FF).withOpacity(0.3),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: post.avatar,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white.withOpacity(0.1),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  color: Colors.white30,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  post.timestamp,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeaderOverlay(FeedPost post) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: post.avatar,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(
                Icons.person,
                color: Colors.white,
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
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [const Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                post.timestamp,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  shadows: [const Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent(FeedPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        post.content,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.9),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildPostImage(FeedPost post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: post.imageUrl!,
          fit: BoxFit.cover,
          height: 250,
          width: double.infinity,
          placeholder: (context, url) => Container(
            height: 250,
            color: Colors.white.withOpacity(0.05),
          ),
          errorWidget: (context, url, error) => Container(
            height: 250,
            color: Colors.white.withOpacity(0.05),
            child: const Icon(Icons.image, size: 50, color: Colors.white30),
          ),
        ),
      ),
    );
  }

  Widget _buildPostActions(FeedPost post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildActionItem(
            icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
            label: '${post.likes}',
            color: post.isLiked ? const Color(0xFFFF006E) : Colors.white.withOpacity(0.5),
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildActionItem(
            icon: Icons.chat_bubble_outline,
            label: '${post.comments}',
            color: Colors.white.withOpacity(0.5),
            onTap: () {},
          ),
          const SizedBox(width: 24),
          _buildActionItem(
            icon: Icons.share_outlined,
            label: 'Share',
            color: Colors.white.withOpacity(0.5),
            onTap: () {},
          ),
          const Spacer(),
          _buildActionItem(
            icon: Icons.bookmark_border,
            label: '',
            color: Colors.white.withOpacity(0.5),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPostActionsOverlay(FeedPost post) {
    return Row(
      children: [
        _buildActionItem(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          label: '${post.likes}',
          color: post.isLiked ? const Color(0xFFFF006E) : Colors.white,
          onTap: () {},
        ),
        const SizedBox(width: 24),
        _buildActionItem(
          icon: Icons.chat_bubble_outline,
          label: '${post.comments}',
          color: Colors.white,
          onTap: () {},
        ),
        const SizedBox(width: 24),
        _buildActionItem(
          icon: Icons.share_outlined,
          label: 'Share',
          color: Colors.white,
          onTap: () {},
        ),
        const Spacer(),
        _buildActionItem(
          icon: Icons.bookmark_border,
          label: '',
          color: Colors.white,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildActionItem({
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _createPost() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
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
            const SizedBox(height: 24),
            Text(
              'Create Post',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              maxLines: 5,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                hintStyle: GoogleFonts.inter(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF06FFA5)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMediaOption(Icons.image, 'Photo'),
                const SizedBox(width: 16),
                _buildMediaOption(Icons.videocam, 'Video'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06FFA5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Post',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOption(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF06FFA5), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedPost {
  final String id;
  final String username;
  final String avatar;
  final String content;
  final String? imageUrl;
  final String timestamp;
  final int likes;
  final int comments;
  final bool isLiked;

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
