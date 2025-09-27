import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final VoidCallback? onReply;
  final Function(String)? onReaction;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final bool isSelected;

  const MessageBubble({
    Key? key,
    required this.message,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.onReply,
    this.onReaction,
    this.onLongPress,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.isFromCurrentUser;
    
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(
          top: isFirstInGroup ? 8 : 2,
          bottom: isLastInGroup ? 8 : 2,
          left: isCurrentUser ? 50 : 0,
          right: isCurrentUser ? 0 : 50,
        ),
        child: Column(
          crossAxisAlignment: isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Show sender name for group chats (non-current user)
            if (!isCurrentUser && isFirstInGroup)
              Padding(
                padding: EdgeInsets.only(left: 16, bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            
            // Reply preview if this is a reply
            if (message.isReply && message.replyToContent != null)
              _buildReplyPreview(),
            
            // Main message bubble
            Row(
              mainAxisAlignment: isCurrentUser
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Avatar for other users (only on last message in group)
                if (!isCurrentUser && isLastInGroup)
                  _buildAvatar(),
                
                // Message bubble
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: IntrinsicHeight(
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 0,
                        borderRadius: _getBorderRadius(),
                        blur: 20,
                        border: isSelected ? 2 : 1,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isCurrentUser
                              ? [
                                  Colors.purple.withValues(alpha: 0.3),
                                  Colors.blue.withValues(alpha: 0.2),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.1),
                                  Colors.white.withValues(alpha: 0.05),
                                ],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isSelected
                              ? [
                                  Colors.purple.withValues(alpha: 0.8),
                                  Colors.blue.withValues(alpha: 0.8),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white.withValues(alpha: 0.1),
                                ],
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Message content based on type
                              _buildMessageContent(),
                              
                              // Reactions
                              if (message.reactions.isNotEmpty)
                                _buildReactions(),
                              
                              // Message info (time, status, edited)
                              _buildMessageInfo(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Spacing for current user messages
                if (isCurrentUser && !isLastInGroup)
                  SizedBox(width: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.only(right: 8, bottom: 0),
      child: CircleAvatar(
        radius: 16,
        backgroundImage: message.senderAvatar != null
            ? NetworkImage(message.senderAvatar!)
            : null,
        backgroundColor: Colors.purple.withValues(alpha: 0.3),
        child: message.senderAvatar == null
            ? Icon(Icons.person, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 8,
        blur: 10,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.3),
            Colors.blue.withValues(alpha: 0.3),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You', // TODO: Get actual sender name
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      message.replyToContent!,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.isDeleted) {
      return Row(
        children: [
          Icon(Icons.block, color: Colors.white38, size: 16),
          SizedBox(width: 8),
          Text(
            message.displayContent,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    switch (message.type) {
      case MessageType.image:
        return _buildImageMessage();
      case MessageType.video:
        return _buildVideoMessage();
      case MessageType.audio:
        return _buildAudioMessage();
      case MessageType.file:
        return _buildFileMessage();
      case MessageType.location:
        return _buildLocationMessage();
      case MessageType.contact:
        return _buildContactMessage();
      case MessageType.text:
      case MessageType.emoji:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    return Text(
      message.content,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        height: 1.3,
      ),
    );
  }

  Widget _buildImageMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: 200,
            maxHeight: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: message.mediaUrl != null
                ? Image.network(
                    message.mediaUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildMediaPlaceholder(Icons.image, 'Image'),
                  )
                : _buildMediaPlaceholder(Icons.image, 'Image'),
          ),
        ),
        if (message.content.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: _buildTextMessage(),
          ),
      ],
    );
  }

  Widget _buildVideoMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: 200,
            maxHeight: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withValues(alpha: 0.1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: message.thumbnailUrl != null
                    ? Image.network(
                        message.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildMediaPlaceholder(Icons.videocam, 'Video'),
                      )
                    : _buildMediaPlaceholder(Icons.videocam, 'Video'),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        if (message.content.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: _buildTextMessage(),
          ),
      ],
    );
  }

  Widget _buildAudioMessage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.4, // Demo progress
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message.audioDuration != null
                      ? '${message.audioDuration!.inMinutes}:${(message.audioDuration!.inSeconds % 60).toString().padLeft(2, '0')}'
                      : '0:00',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.insert_drive_file,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.fileName ?? 'File',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (message.fileSize != null)
                  Text(
                    _formatFileSize(message.fileSize!),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.download,
            color: Colors.white70,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMessage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Location shared',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Icon(
            Icons.open_in_new,
            color: Colors.white70,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildContactMessage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.withValues(alpha: 0.3),
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Tap to view',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPlaceholder(IconData icon, String label) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 48),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReactions() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 4,
        children: message.reactions.map((reaction) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              reaction,
              style: TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageInfo() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isEdited)
            Text(
              'edited ',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          Text(
            message.formattedTime,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
          if (message.isFromCurrentUser) ...[
            SizedBox(width: 4),
            Text(
              _getStatusIcon(),
              style: TextStyle(
                color: _getStatusColor(),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _getBorderRadius() {
    const double defaultRadius = 18.0;
    
    if (message.isFromCurrentUser) {
      return defaultRadius;
    } else {
      return defaultRadius;
    }
  }

  String _getStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return '⏰';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.seen:
        return '✓✓';
      case MessageStatus.failed:
        return '❌';
    }
  }

  Color _getStatusColor() {
    switch (message.status) {
      case MessageStatus.sending:
        return Colors.white38;
      case MessageStatus.sent:
        return Colors.white38;
      case MessageStatus.delivered:
        return Colors.white38;
      case MessageStatus.seen:
        return Colors.blue;
      case MessageStatus.failed:
        return Colors.red;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}