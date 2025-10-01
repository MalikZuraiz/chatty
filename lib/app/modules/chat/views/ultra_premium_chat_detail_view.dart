import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/chat_detail_controller.dart';
import '../../../data/models/message_model.dart';

class UltraPremiumChatDetailView extends GetView<ChatDetailController> {
  const UltraPremiumChatDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: Container(
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
        child: Stack(
          children: [
            // Subtle animated background
            ...List.generate(4, (index) => 
              _AnimatedOrb(key: ValueKey('orb_$index'), index: index)
            ),
            
            SafeArea(
              child: Column(
                children: [
                  _buildSlimAppBar(context),
                  Expanded(
                    child: _buildMessageList(),
                  ),
                  _buildSlimInputArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlimAppBar(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Row(
              children: [
                // Back button
                _buildIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  onTap: () => Get.back(),
                ),
                
                const SizedBox(width: 8),
                
                // Avatar
                _buildSlimAvatar(),
                
                const SizedBox(width: 12),
                
                // Name & Status
                Expanded(
                  child: _buildNameStatus(),
                ),
                
                // Action buttons
                _buildIconButton(
                  icon: Icons.videocam_rounded,
                  size: 20,
                  color: const Color(0xFF00F5FF),
                  onTap: () {},
                ),
                
                const SizedBox(width: 4),
                
                _buildIconButton(
                  icon: Icons.call_rounded,
                  size: 18,
                  color: const Color(0xFF7B2FF7),
                  onTap: () {},
                ),
                
                const SizedBox(width: 4),
                
                _buildIconButton(
                  icon: Icons.more_vert_rounded,
                  size: 18,
                  onTap: () => _showMenu(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required double size,
    Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          shape: BoxShape.circle,
          border: Border.all(
            color: (color ?? Colors.white).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color ?? Colors.white.withOpacity(0.9),
          size: size,
        ),
      ),
    );
  }

  Widget _buildSlimAvatar() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00F5FF).withOpacity(0.3),
            const Color(0xFF7B2FF7).withOpacity(0.3),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00F5FF).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F5FF).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          controller.currentChat?.participants.isNotEmpty == true &&
                  controller.currentChat?.participants.first.avatar != null
              ? controller.currentChat!.participants.first.avatar!
              : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF7B2FF7).withOpacity(0.2),
            child: const Icon(Icons.person, color: Colors.white60, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildNameStatus() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.currentChat?.name ?? 'Chat',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isOnline.value)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF88),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FF88).withOpacity(0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            if (controller.isOnline.value) const SizedBox(width: 5),
            Flexible(
              child: Text(
                controller.isTyping.value
                    ? 'typing...'
                    : controller.isOnline.value
                        ? 'online'
                        : 'offline',
                style: GoogleFonts.inter(
                  color: controller.isTyping.value
                      ? const Color(0xFFFF2E97)
                      : controller.isOnline.value
                          ? const Color(0xFF00FF88)
                          : Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildMessageList() {
    return Obx(() => ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.messages.length && controller.isTyping.value) {
          return _buildTypingIndicator();
        }
        
        final message = controller.messages[index];
        final isMe = message.senderId == 'current_user';
        
        final showAvatar = index == controller.messages.length - 1 ||
            controller.messages[index + 1].senderId != message.senderId;
        
        final showName = !isMe && (index == 0 ||
            controller.messages[index - 1].senderId != message.senderId);
        
        final marginBottom = index == controller.messages.length - 1 ||
            controller.messages[index + 1].senderId != message.senderId ? 12.0 : 3.0;

        return FadeInUp(
          duration: const Duration(milliseconds: 350),
          delay: Duration(milliseconds: index * 20),
          child: _buildMessageBubble(
            message: message,
            isMe: isMe,
            showAvatar: showAvatar,
            showName: showName,
            marginBottom: marginBottom,
          ),
        );
      },
    ));
  }

  Widget _buildMessageBubble({
    required MessageModel message,
    required bool isMe,
    required bool showAvatar,
    required bool showName,
    required double marginBottom,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: marginBottom,
        left: isMe ? 60 : 0,
        right: isMe ? 0 : 60,
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar)
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF7B2FF7).withOpacity(0.3),
                    const Color(0xFFFF2E97).withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF7B2FF7).withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (!isMe)
            const SizedBox(width: 36),
          
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (showName)
                  Padding(
                    padding: const EdgeInsets.only(left: 14, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7B2FF7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (isMe
                                ? const Color(0xFF00F5FF)
                                : const Color(0xFF7B2FF7))
                            .withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isMe
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF00F5FF).withOpacity(0.2),
                                    const Color(0xFF0099FF).withOpacity(0.15),
                                  ],
                                )
                              : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.06),
                                    Colors.white.withOpacity(0.03),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: (isMe
                                    ? const Color(0xFF00F5FF)
                                    : Colors.white)
                                .withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message.content,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                                letterSpacing: 0.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(message.timestamp),
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    message.status == MessageStatus.delivered
                                        ? Icons.done_all_rounded
                                        : Icons.check_rounded,
                                    size: 12,
                                    color: message.status == MessageStatus.delivered
                                        ? const Color(0xFF00FF87)
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildTypingIndicator() {
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 36),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) => 
                  TweenAnimationBuilder<double>(
                    key: ValueKey('dot_$index'),
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0.4, end: 1.0),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2E97).withOpacity(value * 0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF2E97).withOpacity(value * 0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      );
                    },
                    onEnd: () {
                      // Restart animation
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlimInputArea() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.06),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Attachment button
                    _buildInputButton(
                      icon: Icons.add_circle_outline_rounded,
                      color: const Color(0xFF7B2FF7),
                      onTap: () => _showMediaOptions(),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Text input
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 100),
                        child: TextField(
                          controller: controller.messageController,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Message...',
                            hintStyle: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Emoji button
                    _buildInputButton(
                      icon: Icons.emoji_emotions_outlined,
                      color: const Color(0xFFFFD700),
                      onTap: () {},
                    ),
                    
                    const SizedBox(width: 4),
                    
                    // Send button
                    Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: _buildInputButton(
                        icon: controller.messageText.value.isEmpty
                            ? Icons.mic_rounded
                            : Icons.send_rounded,
                        color: const Color(0xFF00F5FF),
                        gradient: controller.messageText.value.isNotEmpty
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF00F5FF),
                                  Color(0xFF0099FF),
                                ],
                              )
                            : null,
                        onTap: () {
                          if (controller.messageController.text.trim().isNotEmpty) {
                            controller.sendMessage();
                            controller.messageController.clear();
                          } else {
                            controller.startVoiceRecording();
                          }
                        },
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputButton({
    required IconData icon,
    required Color color,
    Gradient? gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: gradient ??
              LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
              ),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: gradient != null
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.9),
          size: 18,
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A24).withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'View Profile',
                    color: const Color(0xFF00F5FF),
                  ),
                  _buildMenuItem(
                    icon: Icons.search_rounded,
                    title: 'Search in Chat',
                    color: const Color(0xFF7B2FF7),
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_off_outlined,
                    title: 'Mute Notifications',
                    color: const Color(0xFFFFD700),
                  ),
                  _buildMenuItem(
                    icon: Icons.image_outlined,
                    title: 'Media Gallery',
                    color: const Color(0xFF00FF87),
                  ),
                  _buildMenuItem(
                    icon: Icons.delete_outline_rounded,
                    title: 'Clear Chat',
                    color: const Color(0xFFFF2E97),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMediaOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A24).withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMediaOption(
                        icon: Icons.image_rounded,
                        title: 'Gallery',
                        color: const Color(0xFF7B2FF7),
                      ),
                      _buildMediaOption(
                        icon: Icons.camera_alt_rounded,
                        title: 'Camera',
                        color: const Color(0xFF00F5FF),
                      ),
                      _buildMediaOption(
                        icon: Icons.description_rounded,
                        title: 'File',
                        color: const Color(0xFFFFD700),
                      ),
                      _buildMediaOption(
                        icon: Icons.location_on_rounded,
                        title: 'Location',
                        color: const Color(0xFFFF2E97),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${time.day}/${time.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}

// Animated Orb Background
class _AnimatedOrb extends StatefulWidget {
  final int index;
  
  const _AnimatedOrb({Key? key, required this.index}) : super(key: key);

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + widget.index),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = [
      const Color(0xFF00F5FF),
      const Color(0xFF7B2FF7),
      const Color(0xFFFF2E97),
      const Color(0xFF00FF87),
    ];
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: (widget.index % 2 == 0 ? 0.2 : 0.7) * size.width +
              math.sin(_animation.value * math.pi * 2) * 30,
          top: (widget.index < 2 ? 0.2 : 0.6) * size.height +
              math.cos(_animation.value * math.pi * 2) * 30,
          child: Container(
            width: 150 + widget.index * 20,
            height: 150 + widget.index * 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors[widget.index].withOpacity(0.08),
                  colors[widget.index].withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
