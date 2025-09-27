import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/chat_list_controller.dart';
import '../../../data/models/chat_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../routes/app_routes.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(),
            _buildPremiumSearchBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerLoading();
                }
                
                final filteredChats = controller.filteredChats;
                
                if (filteredChats.isEmpty) {
                  return _buildEmptyState();
                }
                
                return _buildPremiumChatList(filteredChats);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            'Chats',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              NeonIcon(
                icon: Icons.camera_alt_rounded,
                color: AppTheme.neonBlue,
                size: 28,
              ),
              const SizedBox(width: 16),
              NeonIcon(
                icon: Icons.more_vert_rounded,
                color: AppTheme.neonPurple,
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PremiumTextField(
        hint: 'Search conversations...',
        prefixIcon: Icons.search_rounded,
        onChanged: (value) => controller.searchQuery.value = value,
      ),
    );
  }

  Widget _buildPremiumChatList(List<ChatModel> chats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: _buildPremiumChatTile(chat, index),
          );
        },
      ),
    );
  }

  Widget _buildPremiumChatTile(ChatModel chat, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        onTap: () => _openChat(chat),
        child: Row(
          children: [
            // Premium avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _getAvatarColor(index),
                        _getAvatarColor(index).withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: (chat.avatar?.isNotEmpty ?? false)
                        ? CachedNetworkImage(
                            imageUrl: chat.avatar!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: AppTheme.textPrimary,
                                size: 28,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: AppTheme.textPrimary,
                                size: 28,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              chat.name.isNotEmpty ? chat.name[0].toUpperCase() : '?',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                  ),
                ),
                if (_isUserOnline(chat))
                  Positioned(
                    bottom: 2,
                    right: 2,
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
                            color: AppTheme.neonCyan.withOpacity(0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(chat.lastMessageTime ?? DateTime.now()),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage ?? 'No messages yet',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.neonPink,
                                AppTheme.neonPink.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.neonPink.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      AppTheme.neonPink,
      AppTheme.neonCyan,
      AppTheme.neonYellow,
    ];
    return colors[index % colors.length];
  }

  void _openChat(ChatModel chat) {
    Get.toNamed(AppRoutes.chatRoom, arguments: chat);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  bool _isUserOnline(ChatModel chat) {
    // For direct chats, check if any participant is online
    if (chat.type == ChatType.direct && chat.participants.isNotEmpty) {
      return chat.participants.any((user) => user.isOnline);
    }
    // For group chats, we could show online if any participants are online
    return chat.participants.any((user) => user.isOnline);
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              title: Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              subtitle: Container(
                height: 14,
                width: double.infinity,
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(height: 20),
          Text(
            'No chats yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Start a conversation with your friends',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}