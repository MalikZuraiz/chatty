import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/chat_model.dart';
import 'dart:math';

class ChatDetailController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  // Observables
  var messages = <MessageModel>[].obs;
  var isTyping = false.obs;
  var isRecording = false.obs;
  var replyToMessage = Rxn<MessageModel>();
  var selectedMessages = <String>[].obs;
  var isSelectionMode = false.obs;
  var isOnline = true.obs;
  var lastSeen = DateTime.now().obs;
  
  // Chat info
  late ChatModel currentChat;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get chat from arguments
    if (Get.arguments != null && Get.arguments is ChatModel) {
      currentChat = Get.arguments as ChatModel;
      loadMessages();
    }
    
    // Auto scroll to bottom on new messages
    ever(messages, (_) {
      if (scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }
  
  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
  
  void loadMessages() {
    // Demo messages
    final demoMessages = [
      MessageModel(
        id: '1',
        content: 'Hey! How are you doing? 😊',
        senderId: currentChat.participants.first.id,
        senderName: currentChat.participants.first.name,
        senderAvatar: currentChat.participants.first.avatar,
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        status: MessageStatus.seen,
      ),
      MessageModel(
        id: '2',
        content: 'I\'m doing great! Just finished a workout 💪',
        senderId: 'current_user_id',
        senderName: 'You',
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        status: MessageStatus.seen,
      ),
      MessageModel(
        id: '3',
        content: 'That\'s awesome! What kind of workout?',
        senderId: currentChat.participants.first.id,
        senderName: currentChat.participants.first.name,
        senderAvatar: currentChat.participants.first.avatar,
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        status: MessageStatus.seen,
      ),
      MessageModel(
        id: '4',
        content: 'Just some cardio and strength training. Want to join me next time?',
        senderId: 'current_user_id',
        senderName: 'You',
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
        status: MessageStatus.seen,
      ),
      MessageModel(
        id: '5',
        content: 'Absolutely! Count me in 🏃‍♀️',
        senderId: currentChat.participants.first.id,
        senderName: currentChat.participants.first.name,
        senderAvatar: currentChat.participants.first.avatar,
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        status: MessageStatus.seen,
      ),
      MessageModel(
        id: '6',
        content: 'Perfect! Let\'s plan for tomorrow morning?',
        senderId: 'current_user_id',
        senderName: 'You',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        status: MessageStatus.delivered,
      ),
    ];
    
    messages.assignAll(demoMessages);
  }
  
  void sendMessage() {
    final content = messageController.text.trim();
    if (content.isEmpty) return;
    
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      senderId: 'current_user_id',
      senderName: 'You',
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      isReply: replyToMessage.value != null,
      replyToMessageId: replyToMessage.value?.id,
      replyToContent: replyToMessage.value?.content,
    );
    
    messages.add(message);
    messageController.clear();
    replyToMessage.value = null;
    
    // Simulate message status updates
    Future.delayed(Duration(seconds: 1), () {
      final index = messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages[index] = message.copyWith(status: MessageStatus.sent);
        messages.refresh();
      }
    });
    
    Future.delayed(Duration(seconds: 2), () {
      final index = messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages[index] = message.copyWith(status: MessageStatus.delivered);
        messages.refresh();
      }
    });
    
    Future.delayed(Duration(seconds: 3), () {
      final index = messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages[index] = message.copyWith(status: MessageStatus.seen);
        messages.refresh();
      }
    });
  }
  
  void setReplyMessage(MessageModel message) {
    replyToMessage.value = message;
  }
  
  void cancelReply() {
    replyToMessage.value = null;
  }
  
  void deleteMessage(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        isDeleted: true,
        content: '',
      );
      messages.refresh();
    }
  }
  
  void editMessage(String messageId, String newContent) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        content: newContent,
        isEdited: true,
        editedAt: DateTime.now(),
      );
      messages.refresh();
    }
  }
  
  void forwardMessage(MessageModel message) {
    // TODO: Implement forward functionality
    Get.snackbar(
      'Forward',
      'Forward functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void addReaction(String messageId, String reaction) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final currentReactions = List<String>.from(messages[index].reactions);
      if (currentReactions.contains(reaction)) {
        currentReactions.remove(reaction);
      } else {
        currentReactions.add(reaction);
      }
      
      messages[index] = messages[index].copyWith(reactions: currentReactions);
      messages.refresh();
    }
  }
  
  void toggleMessageSelection(String messageId) {
    if (selectedMessages.contains(messageId)) {
      selectedMessages.remove(messageId);
    } else {
      selectedMessages.add(messageId);
    }
    
    if (selectedMessages.isEmpty) {
      isSelectionMode.value = false;
    }
  }
  
  void startSelectionMode(String messageId) {
    isSelectionMode.value = true;
    selectedMessages.add(messageId);
  }
  
  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedMessages.clear();
  }
  
  void deleteSelectedMessages() {
    for (String messageId in selectedMessages) {
      deleteMessage(messageId);
    }
    exitSelectionMode();
  }
  
  void forwardSelectedMessages() {
    // TODO: Implement forward selected messages
    Get.snackbar(
      'Forward',
      '${selectedMessages.length} messages will be forwarded',
      snackPosition: SnackPosition.BOTTOM,
    );
    exitSelectionMode();
  }
  
  void startVoiceRecording() {
    isRecording.value = true;
    // TODO: Implement voice recording
  }
  
  void stopVoiceRecording() {
    isRecording.value = false;
    // TODO: Implement voice recording stop and send
  }
  
  void sendMediaMessage(MessageType type, String filePath) {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '',
      senderId: 'current_user_id',
      senderName: 'You',
      timestamp: DateTime.now(),
      type: type,
      status: MessageStatus.sending,
      mediaUrl: filePath,
    );
    
    messages.add(message);
    
    // Simulate upload and status updates
    Future.delayed(Duration(seconds: 2), () {
      final index = messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages[index] = message.copyWith(status: MessageStatus.sent);
        messages.refresh();
      }
    });
  }
  
  void simulateTyping() {
    isTyping.value = true;
    Future.delayed(Duration(seconds: 3), () {
      isTyping.value = false;
      
      // Add a demo response
      final responses = [
        'That sounds great! 😊',
        'I agree with you',
        'Thanks for sharing!',
        'Interesting point of view',
        'Let me think about it',
      ];
      
      final randomResponse = responses[Random().nextInt(responses.length)];
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: randomResponse,
        senderId: currentChat.participants.first.id,
        senderName: currentChat.participants.first.name,
        senderAvatar: currentChat.participants.first.avatar,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );
      
      messages.add(message);
    });
  }
  
  String getStatusIcon(MessageStatus status) {
    switch (status) {
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
  
  Color getStatusColor(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Colors.grey;
      case MessageStatus.sent:
        return Colors.grey;
      case MessageStatus.delivered:
        return Colors.grey;
      case MessageStatus.seen:
        return Colors.blue;
      case MessageStatus.failed:
        return Colors.red;
    }
  }
}