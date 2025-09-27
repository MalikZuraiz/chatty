enum ChatType {
  direct,
  group,
  broadcast,
}

enum ChatStatus {
  active,
  archived,
  muted,
  blocked,
}

class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? bio;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.bio,
    this.isOnline = false,
    this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? bio,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      bio: json['bio'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSeen'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
    );
  }
}

class ChatModel {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final ChatType type;
  final ChatStatus status;
  final List<UserModel> participants;
  final String? lastMessageId;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final Map<String, dynamic>? metadata;

  ChatModel({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    this.type = ChatType.direct,
    this.status = ChatStatus.active,
    this.participants = const [],
    this.lastMessageId,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.metadata,
  });

  bool get isGroup => type == ChatType.group;
  bool get isBroadcast => type == ChatType.broadcast;
  bool get isActive => status == ChatStatus.active;
  bool get isArchived => status == ChatStatus.archived;
  bool get isBlocked => status == ChatStatus.blocked;
  
  bool get isOnline {
    if (isGroup) return false;
    return participants.isNotEmpty && participants.first.isOnline;
  }

  String get displayName {
    if (isGroup || isBroadcast) return name;
    return participants.isNotEmpty ? participants.first.name : name;
  }

  String? get displayAvatar {
    if (avatar != null) return avatar;
    if (isGroup || isBroadcast) return null;
    return participants.isNotEmpty ? participants.first.avatar : null;
  }

  DateTime? get lastSeenTime {
    if (isGroup) return null;
    return participants.isNotEmpty ? participants.first.lastSeen : null;
  }

  String get formattedLastMessage {
    if (lastMessage == null) return '';
    
    final senderName = participants
        .where((p) => p.id == lastMessageSenderId)
        .map((p) => p.name)
        .firstOrNull;
    
    if (isGroup && senderName != null) {
      return '$senderName: $lastMessage';
    }
    
    return lastMessage!;
  }

  String get formattedLastMessageTime {
    if (lastMessageTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime!);
    
    if (difference.inMinutes < 1) {
      return "Now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}h";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d";
    } else {
      return "${lastMessageTime!.day}/${lastMessageTime!.month}/${lastMessageTime!.year}";
    }
  }

  ChatModel copyWith({
    String? id,
    String? name,
    String? description,
    String? avatar,
    ChatType? type,
    ChatStatus? status,
    List<UserModel>? participants,
    String? lastMessageId,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isPinned,
    bool? isMuted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    Map<String, dynamic>? metadata,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'type': type.name,
      'status': status.name,
      'participants': participants.map((p) => p.toJson()).toList(),
      'lastMessageId': lastMessageId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'isMuted': isMuted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'metadata': metadata,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      avatar: json['avatar'],
      type: ChatType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatType.direct,
      ),
      status: ChatStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChatStatus.active,
      ),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((p) => UserModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      lastMessageId: json['lastMessageId'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastMessageTime'])
          : null,
      lastMessageSenderId: json['lastMessageSenderId'],
      unreadCount: json['unreadCount'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      isMuted: json['isMuted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] ?? 0),
      createdBy: json['createdBy'],
      metadata: json['metadata'],
    );
  }
}