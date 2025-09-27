

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  emoji,
  location,
  contact,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  seen,
  failed,
}

class MessageModel {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? fileName;
  final int? fileSize;
  final Duration? audioDuration;
  final bool isReply;
  final String? replyToMessageId;
  final String? replyToContent;
  final bool isForwarded;
  final bool isEdited;
  final DateTime? editedAt;
  final bool isDeleted;
  final List<String> reactions;
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sending,
    this.mediaUrl,
    this.thumbnailUrl,
    this.fileName,
    this.fileSize,
    this.audioDuration,
    this.isReply = false,
    this.replyToMessageId,
    this.replyToContent,
    this.isForwarded = false,
    this.isEdited = false,
    this.editedAt,
    this.isDeleted = false,
    this.reactions = const [],
    this.metadata,
  });

  bool get isFromCurrentUser => senderId == "current_user_id"; // TODO: Implement auth service

  String get displayContent {
    if (isDeleted) return "This message was deleted";
    switch (type) {
      case MessageType.image:
        return "📷 Photo";
      case MessageType.video:
        return "🎥 Video";
      case MessageType.audio:
        return "🎵 Audio";
      case MessageType.file:
        return "📎 $fileName";
      case MessageType.location:
        return "📍 Location";
      case MessageType.contact:
        return "👤 Contact";
      case MessageType.emoji:
      case MessageType.text:
        return content;
    }
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return "Now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
  }

  MessageModel copyWith({
    String? id,
    String? content,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    String? mediaUrl,
    String? thumbnailUrl,
    String? fileName,
    int? fileSize,
    Duration? audioDuration,
    bool? isReply,
    String? replyToMessageId,
    String? replyToContent,
    bool? isForwarded,
    bool? isEdited,
    DateTime? editedAt,
    bool? isDeleted,
    List<String>? reactions,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      audioDuration: audioDuration ?? this.audioDuration,
      isReply: isReply ?? this.isReply,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToContent: replyToContent ?? this.replyToContent,
      isForwarded: isForwarded ?? this.isForwarded,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      reactions: reactions ?? this.reactions,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type.name,
      'status': status.name,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'audioDuration': audioDuration?.inMilliseconds,
      'isReply': isReply,
      'replyToMessageId': replyToMessageId,
      'replyToContent': replyToContent,
      'isForwarded': isForwarded,
      'isEdited': isEdited,
      'editedAt': editedAt?.millisecondsSinceEpoch,
      'isDeleted': isDeleted,
      'reactions': reactions,
      'metadata': metadata,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      mediaUrl: json['mediaUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      audioDuration: json['audioDuration'] != null
          ? Duration(milliseconds: json['audioDuration'])
          : null,
      isReply: json['isReply'] ?? false,
      replyToMessageId: json['replyToMessageId'],
      replyToContent: json['replyToContent'],
      isForwarded: json['isForwarded'] ?? false,
      isEdited: json['isEdited'] ?? false,
      editedAt: json['editedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['editedAt'])
          : null,
      isDeleted: json['isDeleted'] ?? false,
      reactions: List<String>.from(json['reactions'] ?? []),
      metadata: json['metadata'],
    );
  }
}