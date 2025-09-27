import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/chat_detail_controller.dart';
import '../../../data/models/message_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../../../core/widgets/premium_widgets.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(6, (index) => 
              _FloatingChatParticle(key: ValueKey(index))
            ),
            
            SafeArea(
              child: Column(
                children: [
                  _buildPremiumAppBar(context),
                  Expanded(
                    child: _buildPremiumMessageList(),
                  ),
                  _buildPremiumInputArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return FadeInDown(
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 70,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: controller.currentChat.participants.isNotEmpty &&
                        controller.currentChat.participants.first.avatar != null
                    ? NetworkImage(controller.currentChat.participants.first.avatar!)
                    : null,
                backgroundColor: Colors.purple.withValues(alpha: 0.3),
                child: controller.currentChat.participants.isEmpty ||
                        controller.currentChat.participants.first.avatar == null
                    ? Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.currentChat.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(() => Text(
                          controller.isTyping.value
                              ? 'Typing...'
                              : controller.isOnline.value
                                  ? 'Online'
                                  : 'Last seen ${controller.lastSeen.value.toString().split(' ')[1].substring(0, 5)}',
                          style: TextStyle(
                            color: controller.isTyping.value
                                ? Colors.green
                                : controller.isOnline.value
                                    ? Colors.green
                                    : Colors.white70,
                            fontSize: 12,
                          ),
                        )),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                color: Colors.black.withValues(alpha: 0.8),
                onSelected: (value) => _handleMenuAction(value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'call',
                    child: Row(
                      children: [
                        Icon(Icons.call, color: Colors.white70),
                        SizedBox(width: 12),
                        Text('Voice Call', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'video_call',
                    child: Row(
                      children: [
                        Icon(Icons.videocam, color: Colors.white70),
                        SizedBox(width: 12),
                        Text('Video Call', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'view_profile',
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.white70),
                        SizedBox(width: 12),
                        Text('View Profile', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'search',
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white70),
                        SizedBox(width: 12),
                        Text('Search', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_chat',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Clear Chat', style: TextStyle(color: Colors.red)),
                      ],
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

  Widget _buildMessageList() {
    return Obx(() => ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.messages.length && controller.isTyping.value) {
              return TypingIndicator();
            }
            
            final message = controller.messages[index];
            final isFirstInGroup = index == 0 ||
                controller.messages[index - 1].senderId != message.senderId ||
                message.timestamp.difference(controller.messages[index - 1].timestamp).inMinutes > 5;
            final isLastInGroup = index == controller.messages.length - 1 ||
                controller.messages[index + 1].senderId != message.senderId ||
                controller.messages[index + 1].timestamp.difference(message.timestamp).inMinutes > 5;

            return FadeInUp(
              duration: Duration(milliseconds: 300),
              delay: Duration(milliseconds: index * 50),
              child: MessageBubble(
                message: message,
                isFirstInGroup: isFirstInGroup,
                isLastInGroup: isLastInGroup,
                onReply: () => controller.setReplyMessage(message),
                onReaction: (reaction) => controller.addReaction(message.id, reaction),
                onLongPress: () => controller.startSelectionMode(message.id),
                isSelected: controller.selectedMessages.contains(message.id),
                onTap: controller.isSelectionMode.value
                    ? () => controller.toggleMessageSelection(message.id)
                    : null,
              ),
            );
          },
        ));
  }

  Widget _buildInputArea() {
    return FadeInUp(
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Reply preview
            Obx(() => controller.replyToMessage.value != null
                ? _buildReplyPreview()
                : SizedBox.shrink()),
            
            // Selection mode actions
            Obx(() => controller.isSelectionMode.value
                ? _buildSelectionActions()
                : ChatInput(
                    controller: controller.messageController,
                    onSend: controller.sendMessage,
                    onVoiceStart: controller.startVoiceRecording,
                    onVoiceStop: controller.stopVoiceRecording,
                    onMediaPick: (type, path) => controller.sendMediaMessage(type, path),
                    isRecording: controller.isRecording.value,
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyPreview() {
    final replyMessage = controller.replyToMessage.value!;
    return FadeInUp(
      duration: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 60,
          borderRadius: 12,
          blur: 10,
          alignment: Alignment.centerLeft,
          border: 1,
          linearGradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              Colors.purple.withValues(alpha: 0.3),
              Colors.blue.withValues(alpha: 0.3),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      replyMessage.senderName,
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      replyMessage.displayContent,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: controller.cancelReply,
                icon: Icon(Icons.close, color: Colors.white70, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionActions() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: controller.exitSelectionMode,
            icon: Icon(Icons.close, color: Colors.white),
          ),
          Obx(() => Text(
                '${controller.selectedMessages.length} selected',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          IconButton(
            onPressed: controller.forwardSelectedMessages,
            icon: Icon(Icons.forward, color: Colors.white),
          ),
          IconButton(
            onPressed: controller.deleteSelectedMessages,
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'call':
        Get.snackbar(
          'Voice Call',
          'Voice call feature will be implemented',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'video_call':
        Get.snackbar(
          'Video Call',
          'Video call feature will be implemented',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'view_profile':
        Get.toNamed('/profile', arguments: controller.currentChat.participants.first);
        break;
      case 'search':
        Get.snackbar(
          'Search',
          'Search in chat feature will be implemented',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'clear_chat':
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            title: Text('Clear Chat', style: TextStyle(color: Colors.white)),
            content: Text(
              'Are you sure you want to clear all messages?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () {
                  controller.messages.clear();
                  Get.back();
                },
                child: Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        break;
    }
  }
}