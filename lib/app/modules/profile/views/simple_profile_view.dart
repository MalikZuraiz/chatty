import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final List<UserPost> userPosts = [
    UserPost(
      id: '1',
      content: 'Just deployed my new Flutter app! So excited to share it with everyone 🚀',
      imageUrl: 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=400&h=300&fit=crop',
      timestamp: '2 days ago',
      likes: 45,
      comments: 12,
    ),
    UserPost(
      id: '2',
      content: 'Working late but loving every moment of coding ✨',
      timestamp: '1 week ago',
      likes: 23,
      comments: 8,
    ),
    UserPost(
      id: '3',
      content: 'Beautiful sunset from my office window today!',
      imageUrl: 'https://images.unsplash.com/photo-1566737236500-c8ac43014a8e?w=400&h=300&fit=crop',
      timestamp: '2 weeks ago',
      likes: 67,
      comments: 15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildProfileInfo(),
              _buildStats(),
              _buildActions(),
              _buildSettings(),
              _buildUserPosts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            'Profile',
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
              Icons.edit,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile picture
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
                    ),
                    backgroundColor: AppTheme.neonCyan.withOpacity(0.2),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.neonCyan,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.backgroundDark,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Name and username
              Text(
                'Alex Johnson',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@alexjohnson',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neonCyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Bio
              Text(
                'Flutter Developer | Tech Enthusiast\nLove building amazing mobile apps 🚀',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Messages', '2,847', AppTheme.neonBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Friends', '1,234', AppTheme.neonCyan),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Groups', '156', AppTheme.neonPink),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return GlassmorphismContainer(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Message',
              Icons.chat_bubble_rounded,
              AppTheme.neonBlue,
              () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              'Call',
              Icons.call_rounded,
              AppTheme.neonCyan,
              () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    final settingsItems = [
      SettingItem('Account Settings', Icons.person_rounded),
      SettingItem('Privacy & Security', Icons.security_rounded),
      SettingItem('Notifications', Icons.notifications_rounded),
      SettingItem('Help & Support', Icons.help_rounded),
      SettingItem('About', Icons.info_rounded),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: settingsItems
              .asMap()
              .entries
              .map((entry) => _buildSettingItem(
                    entry.value,
                    isLast: entry.key == settingsItems.length - 1,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSettingItem(SettingItem item, {bool isLast = false}) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: Colors.white.withOpacity(0.7),
        size: 20,
      ),
      title: Text(
        item.title,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white.withOpacity(0.4),
        size: 14,
      ),
      onTap: () {},
    );
  }

  Widget _buildUserPosts() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'My Posts',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          ...userPosts.map((post) => _buildUserPostCard(post)).toList(),
        ],
      ),
    );
  }

  Widget _buildUserPostCard(UserPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post content
              Text(
                post.content,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
              
              // Post image if exists
              if (post.imageUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.imageUrl!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180,
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
              
              const SizedBox(height: 12),
              
              // Post stats
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppTheme.neonPink,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    post.likes.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neonPink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.chat_bubble,
                    color: AppTheme.neonBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    post.comments.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neonBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    post.timestamp,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserPost {
  final String id;
  final String content;
  final String? imageUrl;
  final String timestamp;
  final int likes;
  final int comments;

  UserPost({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });
}

class SettingItem {
  final String title;
  final IconData icon;

  SettingItem(this.title, this.icon);
}