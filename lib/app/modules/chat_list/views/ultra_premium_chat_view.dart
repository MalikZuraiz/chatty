import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/chat_list_controller.dart';
import '../../../data/models/chat_model.dart';
<<<<<<< Updated upstream
=======
import '../../../routes/app_routes.dart';
>>>>>>> Stashed changes

class UltraPremiumChatView extends StatefulWidget {
  const UltraPremiumChatView({super.key});

  @override
  State<UltraPremiumChatView> createState() => _UltraPremiumChatViewState();
}

class _UltraPremiumChatViewState extends State<UltraPremiumChatView> {
  bool isGridView = false;
  final controller = Get.put(ChatListController());

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
            _buildPremiumSearchBar(),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }
                
                final chats = controller.filteredChats;
                
                if (chats.isEmpty) {
                  return _buildEmptyState();
                }
                
                return isGridView 
                    ? _buildPremiumGrid(chats) 
                    : _buildPremiumList(chats);
              }),
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
                'Messages',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() => Text(
                '${controller.filteredChats.length} conversations',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.4),
                ),
              )),
            ],
          ),
          const Spacer(),
          _buildIconButton(
            icon: isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
            onTap: () => setState(() => isGridView = !isGridView),
          ),
          const SizedBox(width: 8),
          _buildIconButton(
            icon: Icons.edit_rounded,
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

  Widget _buildPremiumSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: TextField(
          onChanged: (value) => controller.searchQuery.value = value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Search conversations...',
            hintStyle: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumList(List<ChatModel> chats) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return GestureDetector(
<<<<<<< Updated upstream
          onTap: () => Get.toNamed('/chat-detail', arguments: chat),
=======
          onTap: () => Get.toNamed(AppRoutes.chatRoom, arguments: chat),
>>>>>>> Stashed changes
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.04),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildCompactAvatar(chat),
                const SizedBox(width: 12),
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
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(chat.lastMessageTime),
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage ?? 'No messages',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.45),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00F5FF), Color(0xFF0099FF)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${chat.unreadCount}',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumGrid(List<ChatModel> chats) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return GestureDetector(
<<<<<<< Updated upstream
          onTap: () => Get.toNamed('/chat-detail', arguments: chat),
=======
          onTap: () => Get.toNamed(AppRoutes.chatRoom, arguments: chat),
>>>>>>> Stashed changes
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF00F5FF).withOpacity(0.2),
                            const Color(0xFF0099FF).withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: chat.avatar != null
                            ? CachedNetworkImage(
                                imageUrl: chat.avatar!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 28,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.white.withOpacity(0.3),
                              ),
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF88),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0B0B0F), width: 2),
                          ),
                        ),
                      ),
                    if (chat.unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00F5FF), Color(0xFF0099FF)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    chat.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    chat.lastMessage ?? 'No messages',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactAvatar(ChatModel chat) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00F5FF).withOpacity(0.2),
                const Color(0xFF0099FF).withOpacity(0.2),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: chat.avatar != null
                ? CachedNetworkImage(
                    imageUrl: chat.avatar!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white.withOpacity(0.05),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 24,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.white.withOpacity(0.3),
                  ),
          ),
        ),
        if (chat.isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF88),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0B0B0F), width: 2),
              ),
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F5FF)),
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
