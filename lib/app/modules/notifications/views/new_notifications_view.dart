import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  int _selectedTab = 0;

  final List<String> notificationTabs = ['All', 'Messages', 'Mentions', 'Calls', 'Groups'];

  // Enhanced notifications data specific to chat app
  final List<ChatNotification> notifications = [
    ChatNotification(
      id: '1',
      type: NotificationType.message,
      title: 'New message from Sarah Chen',
      message: 'Hey! Are you free for coffee tomorrow? ☕',
      time: '2 min ago',
      isRead: false,
      avatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      isOnline: true,
    ),
    ChatNotification(
      id: '2',
      type: NotificationType.groupMessage,
      title: 'Team Developers',
      message: 'Alex: The new feature is ready for testing! 🚀',
      time: '5 min ago',
      isRead: false,
      avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
      memberCount: 12,
    ),
    ChatNotification(
      id: '3',
      type: NotificationType.mention,
      title: 'You were mentioned in Design Team',
      message: 'Maya: @You what do you think about the new UI?',
      time: '12 min ago',
      isRead: false,
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      memberCount: 8,
    ),
    ChatNotification(
      id: '4',
      type: NotificationType.voiceCall,
      title: 'Missed call from Jake Wilson',
      message: 'Voice call • 2 minutes',
      time: '1 hour ago',
      isRead: true,
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      isOnline: false,
    ),
    ChatNotification(
      id: '5',
      type: NotificationType.videoCall,
      title: 'Video call with Emma Thompson',
      message: 'Call ended • 45 minutes',
      time: '2 hours ago',
      isRead: true,
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
      isOnline: true,
    ),
    ChatNotification(
      id: '6',
      type: NotificationType.groupJoin,
      title: 'New member joined Flutter Experts',
      message: 'David Smith joined the group',
      time: '3 hours ago',
      isRead: true,
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      memberCount: 156,
    ),
    ChatNotification(
      id: '7',
      type: NotificationType.message,
      title: 'New message from Mom',
      message: 'Don\'t forget dinner tonight! Love you ❤️',
      time: '4 hours ago',
      isRead: true,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
      isOnline: false,
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
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Dynamic background particles
          ...List.generate(15, (index) => _buildBackgroundParticle(index)),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(
                  child: _buildNotificationsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundParticle(int index) {
    return Positioned(
      left: (index * 90.0) % MediaQuery.of(context).size.width,
      top: (index * 120.0) % MediaQuery.of(context).size.height,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(_shimmerController.value * 2 * math.pi + index) * 25,
              math.cos(_shimmerController.value * 2 * math.pi + index) * 20,
            ),
            child: Container(
              width: 5,
              height: 5,
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          FadeInLeft(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: AppTheme.neonPink.withOpacity(0.3),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${notifications.where((n) => !n.isRead).length} unread',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neonCyan,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          FadeInRight(
            child: Row(
              children: [
                // Mark all as read button
                GestureDetector(
                  onTap: _markAllAsRead,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonBlue.withOpacity(0.2),
                          AppTheme.neonCyan.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppTheme.neonBlue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.done_all_rounded,
                      color: AppTheme.neonBlue,
                      size: 20,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Settings button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonPurple.withOpacity(0.2),
                          AppTheme.neonPink.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppTheme.neonPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: AppTheme.neonPurple,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FadeInUp(
        delay: const Duration(milliseconds: 200),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: notificationTabs.asMap().entries.map((entry) {
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

  Widget _buildNotificationsList() {
    final filteredNotifications = _getFilteredNotifications();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: Duration(milliseconds: 300 + (index * 50)),
          child: _buildNotificationCard(filteredNotifications[index], index),
        );
      },
    );
  }

  List<ChatNotification> _getFilteredNotifications() {
    switch (_selectedTab) {
      case 1:
        return notifications.where((n) => 
          n.type == NotificationType.message || 
          n.type == NotificationType.groupMessage).toList();
      case 2:
        return notifications.where((n) => n.type == NotificationType.mention).toList();
      case 3:
        return notifications.where((n) => 
          n.type == NotificationType.voiceCall || 
          n.type == NotificationType.videoCall).toList();
      case 4:
        return notifications.where((n) => 
          n.type == NotificationType.groupMessage || 
          n.type == NotificationType.groupJoin).toList();
      default:
        return notifications;
    }
  }

  Widget _buildNotificationCard(ChatNotification notification, int index) {
    final cardColor = _getNotificationColor(notification.type);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // Background glow effect
          if (!notification.isRead)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      cardColor.withOpacity(0.15),
                      cardColor.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardColor.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          
          // Main notification card
          GestureDetector(
            onTap: () => _handleNotificationTap(notification),
            child: GlassmorphismContainer(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced avatar with status indicator
                    _buildNotificationAvatar(notification, cardColor),
                    
                    const SizedBox(width: 16),
                    
                    // Notification content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              _buildNotificationTypeIcon(notification.type, cardColor),
                            ],
                          ),
                          
                          const SizedBox(height: 6),
                          
                          Text(
                            notification.message,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: notification.isRead ? Colors.white60 : Colors.white.withOpacity(0.8),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      cardColor.withOpacity(0.2),
                                      cardColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: cardColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  notification.time,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: cardColor,
                                  ),
                                ),
                              ),
                              
                              if (notification.memberCount != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${notification.memberCount} members',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Unread indicator
                    if (!notification.isRead)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: cardColor.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
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

  Widget _buildNotificationAvatar(ChatNotification notification, Color cardColor) {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                cardColor.withOpacity(0.3),
                cardColor.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: cardColor.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.3),
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
                notification.avatarUrl,
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
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        
        // Online status indicator
        if (notification.isOnline != null)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: notification.isOnline! ? AppTheme.neonCyan : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.backgroundDark,
                  width: 3,
                ),
                boxShadow: notification.isOnline! ? [
                  BoxShadow(
                    color: AppTheme.neonCyan.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ] : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationTypeIcon(NotificationType type, Color color) {
    IconData icon;
    switch (type) {
      case NotificationType.message:
        icon = Icons.chat_bubble_rounded;
        break;
      case NotificationType.groupMessage:
        icon = Icons.group_rounded;
        break;
      case NotificationType.mention:
        icon = Icons.alternate_email_rounded;
        break;
      case NotificationType.voiceCall:
        icon = Icons.call_rounded;
        break;
      case NotificationType.videoCall:
        icon = Icons.videocam_rounded;
        break;
      case NotificationType.groupJoin:
        icon = Icons.person_add_rounded;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return AppTheme.neonBlue;
      case NotificationType.groupMessage:
        return AppTheme.neonCyan;
      case NotificationType.mention:
        return AppTheme.neonPink;
      case NotificationType.voiceCall:
      case NotificationType.videoCall:
        return AppTheme.neonPurple;
      case NotificationType.groupJoin:
        return AppTheme.neonCyan;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  void _handleNotificationTap(ChatNotification notification) {
    // Mark as read when tapped
    setState(() {
      notification.isRead = true;
    });
    
    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.message:
      case NotificationType.groupMessage:
        // Navigate to chat
        break;
      case NotificationType.mention:
        // Navigate to mentioned message
        break;
      case NotificationType.voiceCall:
      case NotificationType.videoCall:
        // Show call details or start new call
        break;
      case NotificationType.groupJoin:
        // Navigate to group
        break;
    }
  }
}

enum NotificationType {
  message,
  groupMessage,
  mention,
  voiceCall,
  videoCall,
  groupJoin,
}

class ChatNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  bool isRead;
  final String avatarUrl;
  final bool? isOnline;
  final int? memberCount;

  ChatNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.avatarUrl,
    this.isOnline,
    this.memberCount,
  });
}