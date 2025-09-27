import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  
  bool _isOnline = true;
  int _selectedTab = 0;
  
  final List<String> profileTabs = ['Stats', 'Media', 'Groups', 'Settings'];

  // Enhanced profile data
  final UserProfile profile = UserProfile(
    name: 'Alex Johnson',
    username: '@alexj_dev',
    bio: 'Flutter Developer | Tech Enthusiast | Coffee Lover ☕\n🚀 Building amazing mobile experiences',
    avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
    coverUrl: 'https://images.unsplash.com/photo-1557683316-973673baf926?w=800&h=400&fit=crop',
    isVerified: true,
    messageCount: 2847,
    groupCount: 156,
    friendCount: 1234,
    mediaCount: 892,
    joinedDate: 'Joined March 2022',
    lastSeen: 'Active now',
    location: 'San Francisco, CA',
    phone: '+1 (555) 123-4567',
    email: 'alex.johnson@email.com',
  );

  final List<MediaItem> mediaItems = [
    MediaItem(
      id: '1',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1555212697-194d092e3b8f?w=300&h=300&fit=crop',
      timestamp: '2 days ago',
    ),
    MediaItem(
      id: '2',
      type: MediaType.video,
      url: 'https://images.unsplash.com/photo-1611262588024-d12430b98920?w=300&h=300&fit=crop',
      timestamp: '1 week ago',
      duration: '0:45',
    ),
    MediaItem(
      id: '3',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1515378791036-0648a814c963?w=300&h=300&fit=crop',
      timestamp: '2 weeks ago',
    ),
    MediaItem(
      id: '4',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?w=300&h=300&fit=crop',
      timestamp: '3 weeks ago',
    ),
    MediaItem(
      id: '5',
      type: MediaType.video,
      url: 'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=300&h=300&fit=crop',
      timestamp: '1 month ago',
      duration: '1:23',
    ),
    MediaItem(
      id: '6',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=300&h=300&fit=crop',
      timestamp: '1 month ago',
    ),
  ];

  final List<GroupItem> groups = [
    GroupItem(
      id: '1',
      name: 'Flutter Developers',
      memberCount: 2847,
      avatarUrl: 'https://api.dicebear.com/7.x/initials/png?seed=FD',
      isAdmin: true,
    ),
    GroupItem(
      id: '2',
      name: 'Design Team',
      memberCount: 156,
      avatarUrl: 'https://api.dicebear.com/7.x/initials/png?seed=DT',
      isAdmin: false,
    ),
    GroupItem(
      id: '3',
      name: 'Coffee Enthusiasts',
      memberCount: 892,
      avatarUrl: 'https://api.dicebear.com/7.x/initials/png?seed=CE',
      isAdmin: true,
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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Dynamic background particles
          ...List.generate(12, (index) => _buildBackgroundParticle(index)),
          
          // Main content
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildProfileInfo(),
                    _buildStatsCards(),
                    _buildActionButtons(),
                    _buildTabBar(),
                    _buildTabContent(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundParticle(int index) {
    return Positioned(
      left: (index * 110.0) % MediaQuery.of(context).size.width,
      top: (index * 150.0) % MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(_shimmerController.value * 2 * math.pi + index) * 30,
              math.cos(_shimmerController.value * 2 * math.pi + index) * 25,
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
                    blurRadius: 10,
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

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Cover image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(profile.coverUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppTheme.backgroundDark.withOpacity(0.7),
                      AppTheme.backgroundDark,
                    ],
                  ),
                ),
              ),
            ),
            
            // Profile avatar and basic info
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: FadeInUp(
                child: Row(
                  children: [
                    _buildProfileAvatar(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profile.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                    shadows: [
                                      Shadow(
                                        color: AppTheme.neonCyan.withOpacity(0.5),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (profile.isVerified) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.neonBlue,
                                        AppTheme.neonCyan,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.neonBlue.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.username,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.neonCyan,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildOnlineStatus(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: FadeInLeft(
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        FadeInRight(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        // Animated glow effect
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 90 + (_pulseController.value * 10),
              height: 90 + (_pulseController.value * 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.neonCyan.withOpacity(0.3 * _pulseController.value),
                    AppTheme.neonBlue.withOpacity(0.2 * _pulseController.value),
                  ],
                ),
              ),
            );
          },
        ),
        
        // Main avatar
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.neonCyan.withOpacity(0.3),
                AppTheme.neonBlue.withOpacity(0.2),
              ],
            ),
            border: Border.all(
              color: AppTheme.neonCyan,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.neonCyan.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundDark,
            ),
            child: ClipOval(
              child: Image.network(
                profile.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonCyan.withOpacity(0.3),
                          AppTheme.neonBlue.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: AppTheme.neonCyan,
                      size: 45,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        // Online indicator
        Positioned(
          bottom: 5,
          right: 5,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _isOnline ? AppTheme.neonCyan : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.backgroundDark,
                    width: 3,
                  ),
                  boxShadow: _isOnline ? [
                    BoxShadow(
                      color: AppTheme.neonCyan.withOpacity(0.8 * _pulseController.value),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ] : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isOnline ? AppTheme.neonCyan.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
            _isOnline ? AppTheme.neonBlue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _isOnline ? AppTheme.neonCyan.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _isOnline ? AppTheme.neonCyan : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            profile.lastSeen,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isOnline ? AppTheme.neonCyan : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 200),
        child: GlassmorphismContainer(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.bio,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on_rounded, profile.location),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.calendar_today_rounded, profile.joinedDate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.neonPink.withOpacity(0.2),
                AppTheme.neonPurple.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.neonPink,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 300),
        child: Row(
          children: [
            Expanded(child: _buildStatCard('Messages', profile.messageCount.toString(), AppTheme.neonBlue, Icons.chat_bubble_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Friends', profile.friendCount.toString(), AppTheme.neonCyan, Icons.people_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Groups', profile.groupCount.toString(), AppTheme.neonPink, Icons.group_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Media', profile.mediaCount.toString(), AppTheme.neonPurple, Icons.photo_library_rounded)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return GlassmorphismContainer(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 400),
        child: Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Message',
                Icons.chat_bubble_rounded,
                [AppTheme.neonBlue, AppTheme.neonCyan],
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Call',
                Icons.call_rounded,
                [AppTheme.neonPink, AppTheme.neonPurple],
                () {},
              ),
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              '',
              Icons.videocam_rounded,
              [AppTheme.neonCyan, AppTheme.neonBlue],
              () {},
              isSquare: true,
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              '',
              Icons.more_horiz_rounded,
              [AppTheme.neonPurple, AppTheme.neonPink],
              () {},
              isSquare: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    List<Color> gradientColors,
    VoidCallback onTap, {
    bool isSquare = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSquare ? 16 : 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(isSquare ? 20 : 25),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: isSquare
            ? Icon(icon, color: Colors.white, size: 24)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
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
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FadeInUp(
        delay: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: profileTabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = _selectedTab == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? LinearGradient(
                      colors: [
                        AppTheme.neonCyan,
                        AppTheme.neonBlue,
                      ],
                    ) : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                        ? AppTheme.neonCyan.withOpacity(0.5)
                        : Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppTheme.neonCyan.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ] : null,
                  ),
                  child: Text(
                    tab,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.white70,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildStatsTab();
      case 1:
        return _buildMediaTab();
      case 2:
        return _buildGroupsTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildStatsTab();
    }
  }

  Widget _buildStatsTab() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        child: Column(
          children: [
            _buildStatisticCard('Total Messages Sent', profile.messageCount.toString(), AppTheme.neonBlue, Icons.send_rounded),
            const SizedBox(height: 16),
            _buildStatisticCard('Active Groups', profile.groupCount.toString(), AppTheme.neonCyan, Icons.group_work_rounded),
            const SizedBox(height: 16),
            _buildStatisticCard('Friends Connected', profile.friendCount.toString(), AppTheme.neonPink, Icons.people_alt_rounded),
            const SizedBox(height: 16),
            _buildStatisticCard('Media Shared', profile.mediaCount.toString(), AppTheme.neonPurple, Icons.perm_media_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard(String title, String value, Color color, IconData icon) {
    return GlassmorphismContainer(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTab() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: mediaItems.length,
          itemBuilder: (context, index) {
            final media = mediaItems[index];
            return _buildMediaItem(media);
          },
        ),
      ),
    );
  }

  Widget _buildMediaItem(MediaItem media) {
    return GestureDetector(
      onTap: () => _showMediaDetail(media),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                media.url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.broken_image_rounded,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Video indicator
          if (media.type == MediaType.video)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      media.duration ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupsTab() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        child: Column(
          children: groups.map((group) => _buildGroupItem(group)).toList(),
        ),
      ),
    );
  }

  Widget _buildGroupItem(GroupItem group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassmorphismContainer(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonCyan.withOpacity(0.3),
                      AppTheme.neonBlue.withOpacity(0.2),
                    ],
                  ),
                  border: Border.all(
                    color: AppTheme.neonCyan.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    group.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.neonCyan.withOpacity(0.3),
                              AppTheme.neonBlue.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.group_rounded,
                          color: AppTheme.neonCyan,
                          size: 25,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (group.isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.neonPink,
                                  AppTheme.neonPurple,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Admin',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${group.memberCount} members',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    final settingsItems = [
      SettingItem('Privacy & Security', Icons.security_rounded, AppTheme.neonBlue),
      SettingItem('Notifications', Icons.notifications_rounded, AppTheme.neonCyan),
      SettingItem('Data & Storage', Icons.storage_rounded, AppTheme.neonPink),
      SettingItem('Account Settings', Icons.account_box_rounded, AppTheme.neonPurple),
      SettingItem('Help & Support', Icons.help_rounded, AppTheme.neonBlue),
      SettingItem('About', Icons.info_rounded, AppTheme.neonCyan),
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      child: FadeInUp(
        delay: const Duration(milliseconds: 600),
        child: Column(
          children: settingsItems.map((item) => _buildSettingItem(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildSettingItem(SettingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {},
        child: GlassmorphismContainer(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        item.color.withOpacity(0.3),
                        item.color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMediaDetail(MediaItem media) {
    // Show media in full screen
  }
}

// Data models
class UserProfile {
  final String name;
  final String username;
  final String bio;
  final String avatarUrl;
  final String coverUrl;
  final bool isVerified;
  final int messageCount;
  final int groupCount;
  final int friendCount;
  final int mediaCount;
  final String joinedDate;
  final String lastSeen;
  final String location;
  final String phone;
  final String email;

  UserProfile({
    required this.name,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    required this.coverUrl,
    required this.isVerified,
    required this.messageCount,
    required this.groupCount,
    required this.friendCount,
    required this.mediaCount,
    required this.joinedDate,
    required this.lastSeen,
    required this.location,
    required this.phone,
    required this.email,
  });
}

class MediaItem {
  final String id;
  final MediaType type;
  final String url;
  final String timestamp;
  final String? duration;

  MediaItem({
    required this.id,
    required this.type,
    required this.url,
    required this.timestamp,
    this.duration,
  });
}

enum MediaType { image, video }

class GroupItem {
  final String id;
  final String name;
  final int memberCount;
  final String avatarUrl;
  final bool isAdmin;

  GroupItem({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.avatarUrl,
    required this.isAdmin,
  });
}

class SettingItem {
  final String title;
  final IconData icon;
  final Color color;

  SettingItem(this.title, this.icon, this.color);
}