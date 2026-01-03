import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UltraPremiumFeedView extends StatefulWidget {
  const UltraPremiumFeedView({super.key});

  @override
  State<UltraPremiumFeedView> createState() => _UltraPremiumFeedViewState();
}

class _UltraPremiumFeedViewState extends State<UltraPremiumFeedView> {
  bool isHorizontalView = false;

  final List<FeedPost> posts = [
    FeedPost(
      id: '1',
      author: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      timeAgo: '2h',
      caption: 'Living my best life ✨',
      imageUrl: 'https://picsum.photos/seed/1/800/800',
      likes: 1234,
      comments: 89,
      isLiked: true,
    ),
    FeedPost(
      id: '2',
      author: 'Alex Jordan',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      timeAgo: '4h',
      caption: 'Adventure awaits! 🌄',
      imageUrl: 'https://picsum.photos/seed/2/800/800',
      likes: 856,
      comments: 45,
      isLiked: false,
    ),
    FeedPost(
      id: '3',
      author: 'Maya Patel',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      timeAgo: '6h',
      caption: 'Good vibes only 🌊',
      imageUrl: 'https://picsum.photos/seed/3/800/800',
      likes: 2341,
      comments: 156,
      isLiked: true,
    ),
    FeedPost(
      id: '4',
      author: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      timeAgo: '8h',
      caption: 'Sunset magic 🌅',
      imageUrl: 'https://picsum.photos/seed/4/800/800',
      likes: 678,
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
              child: isHorizontalView ? _buildHorizontalFeed() : _buildVerticalFeed(),
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
                'Feed',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${posts.length} new posts',
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
            icon: isHorizontalView ? Icons.view_day_rounded : Icons.view_carousel_rounded,
            onTap: () => setState(() => isHorizontalView = !isHorizontalView),
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.add_circle_outline_rounded,
            onTap: () {},
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

  Widget _buildVerticalFeed() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.04),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.5,
                          color: const Color(0xFF00F5FF).withOpacity(0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: CachedNetworkImage(
                          imageUrl: post.avatar,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white.withOpacity(0.05),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            post.timeAgo,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white.withOpacity(0.5),
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0),
                  bottom: Radius.circular(0),
                ),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 320,
                    color: Colors.white.withOpacity(0.03),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00F5FF),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 320,
                    color: Colors.white.withOpacity(0.03),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white.withOpacity(0.2),
                      size: 40,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildCompactActionButton(
                          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                          label: _formatCount(post.likes),
                          color: post.isLiked ? const Color(0xFFFF0080) : null,
                        ),
                        const SizedBox(width: 16),
                        _buildCompactActionButton(
                          icon: Icons.chat_bubble_outline,
                          label: _formatCount(post.comments),
                        ),
                        const SizedBox(width: 16),
                        _buildCompactActionButton(
                          icon: Icons.send_rounded,
                          label: '',
                        ),
                        const Spacer(),
                        _buildCompactActionButton(
                          icon: Icons.bookmark_border,
                          label: '',
                        ),
                      ],
                    ),
                    if (post.caption.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        post.caption,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalFeed() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white.withOpacity(0.03),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF00F5FF),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white.withOpacity(0.03),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white.withOpacity(0.2),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 0.2, 0.6, 1.0],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFF00F5FF).withOpacity(0.5),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: CachedNetworkImage(
                                    imageUrl: post.avatar,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.person,
                                      size: 20,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.author,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.2,
                                        shadows: const [
                                          Shadow(blurRadius: 8, color: Colors.black45),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      post.timeAgo,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.8),
                                        shadows: const [
                                          Shadow(blurRadius: 8, color: Colors.black45),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (post.caption.isNotEmpty)
                                Text(
                                  post.caption,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.4,
                                    shadows: const [
                                      Shadow(blurRadius: 8, color: Colors.black54),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildHorizontalAction(
                                    icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                                    label: _formatCount(post.likes),
                                    color: post.isLiked ? const Color(0xFFFF0080) : Colors.white,
                                  ),
                                  const SizedBox(width: 20),
                                  _buildHorizontalAction(
                                    icon: Icons.chat_bubble,
                                    label: _formatCount(post.comments),
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 20),
                                  _buildHorizontalAction(
                                    icon: Icons.send_rounded,
                                    label: '',
                                    color: Colors.white,
                                  ),
                                  const Spacer(),
                                  _buildHorizontalAction(
                                    icon: Icons.bookmark,
                                    label: '',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildCompactActionButton({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color ?? Colors.white.withOpacity(0.6),
          size: 20,
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHorizontalAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: const [
                Shadow(blurRadius: 8, color: Colors.black54),
              ],
            ),
          ),
        ],
      ],
    );
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
  final String author;
  final String avatar;
  final String timeAgo;
  final String caption;
  final String imageUrl;
  final int likes;
  final int comments;
  final bool isLiked;

  FeedPost({
    required this.id,
    required this.author,
    required this.avatar,
    required this.timeAgo,
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });
}
