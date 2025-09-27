import 'package:get/get.dart';
import '../../../data/models/chat_model.dart';

class ChatListController extends GetxController {
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  void loadChats() {
    isLoading.value = true;
    
    // Premium mock data with varied conversations
    Future.delayed(Duration(milliseconds: 1200), () {
      chats.value = [
        // Recent active conversations
        ChatModel(
          id: '1',
          name: 'Luna Martinez',
          lastMessage: 'Just saw your story! That sunset was incredible 🌅',
          lastMessageTime: DateTime.now().subtract(Duration(minutes: 2)),
          unreadCount: 3,
          avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user1',
              name: 'Luna Martinez',
              avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 45)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 12)),
          updatedAt: DateTime.now().subtract(Duration(minutes: 2)),
        ),
        ChatModel(
          id: '2',
          name: 'Alex Chen',
          lastMessage: '🎮 Want to hop on a game later?',
          lastMessageTime: DateTime.now().subtract(Duration(minutes: 8)),
          unreadCount: 1,
          avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user2',
              name: 'Alex Chen',
              avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 28)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 8)),
          updatedAt: DateTime.now().subtract(Duration(minutes: 8)),
        ),
        ChatModel(
          id: '3',
          name: 'Design Squad',
          description: 'Creative minds unite ✨',
          lastMessage: 'Maya: New mockups are fire! 🔥',
          lastMessageTime: DateTime.now().subtract(Duration(minutes: 15)),
          unreadCount: 5,
          avatar: '',
          type: ChatType.group,
          participants: [
            UserModel(
              id: 'user3',
              name: 'Maya Singh',
              avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 60)),
              updatedAt: DateTime.now(),
            ),
            UserModel(
              id: 'user4',
              name: 'Chris Taylor',
              avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(minutes: 30)),
              createdAt: DateTime.now().subtract(Duration(days: 40)),
              updatedAt: DateTime.now(),
            ),
            UserModel(
              id: 'user5',
              name: 'Zara Kim',
              avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 35)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 20)),
          updatedAt: DateTime.now().subtract(Duration(minutes: 15)),
        ),
        ChatModel(
          id: '4',
          name: 'Emma Watson',
          lastMessage: '📱 Check out this new app concept!',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
          unreadCount: 0,
          avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user6',
              name: 'Emma Watson',
              avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(minutes: 45)),
              createdAt: DateTime.now().subtract(Duration(days: 22)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 6)),
          updatedAt: DateTime.now().subtract(Duration(hours: 1)),
        ),
        ChatModel(
          id: '5',
          name: 'Dev Team 💻',
          description: 'Building the future, one commit at a time',
          lastMessage: 'Ryan: Deploy is live! 🚀',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
          unreadCount: 12,
          avatar: '',
          type: ChatType.group,
          participants: [
            UserModel(
              id: 'user7',
              name: 'Ryan Park',
              avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 55)),
              updatedAt: DateTime.now(),
            ),
            UserModel(
              id: 'user8',
              name: 'Sarah Johnson',
              avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(hours: 1)),
              createdAt: DateTime.now().subtract(Duration(days: 42)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 15)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
        ChatModel(
          id: '6',
          name: 'Marcus Rodriguez',
          lastMessage: 'Yo! Coffee meetup tomorrow? ☕',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 3)),
          unreadCount: 0,
          avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user9',
              name: 'Marcus Rodriguez',
              avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(hours: 2)),
              createdAt: DateTime.now().subtract(Duration(days: 18)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 3)),
        ),
        ChatModel(
          id: '7',
          name: 'Fitness Buddies 💪',
          description: 'Stay strong, stay motivated!',
          lastMessage: 'Lisa: Morning run anyone? 🏃‍♀️',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 5)),
          unreadCount: 2,
          avatar: '',
          type: ChatType.group,
          participants: [
            UserModel(
              id: 'user10',
              name: 'Lisa Chen',
              avatar: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(hours: 4)),
              createdAt: DateTime.now().subtract(Duration(days: 25)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(hours: 5)),
        ),
        ChatModel(
          id: '8',
          name: 'Aria Thompson',
          lastMessage: '🎵 Just dropped my new track!',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 8)),
          unreadCount: 0,
          avatar: 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user11',
              name: 'Aria Thompson',
              avatar: 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(hours: 6)),
              createdAt: DateTime.now().subtract(Duration(days: 30)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 9)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
        ),
        ChatModel(
          id: '9',
          name: 'Travel Squad ✈️',
          description: 'Wanderlust and adventures await',
          lastMessage: 'Jake: Bali pics are insane! 🏝️',
          lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
          unreadCount: 7,
          avatar: '',
          type: ChatType.group,
          participants: [
            UserModel(
              id: 'user12',
              name: 'Jake Wilson',
              avatar: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 38)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 25)),
          updatedAt: DateTime.now().subtract(Duration(days: 1)),
        ),
        ChatModel(
          id: '10',
          name: 'Sophie Williams',
          lastMessage: 'Thanks for the book recommendation! 📚',
          lastMessageTime: DateTime.now().subtract(Duration(days: 2)),
          unreadCount: 0,
          avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user13',
              name: 'Sophie Williams',
              avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              lastSeen: DateTime.now().subtract(Duration(days: 1)),
              createdAt: DateTime.now().subtract(Duration(days: 50)),
              updatedAt: DateTime.now(),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 14)),
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
        ),
        ChatModel(
          id: '3',
          name: 'Emma Wilson',
          lastMessage: '🎵 Voice message',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 3)),
          unreadCount: 1,
          avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
          participants: [
            UserModel(
              id: 'user3',
              name: 'Emma Wilson',
              avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 20)),
              updatedAt: DateTime.now().subtract(Duration(minutes: 30)),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 3)),
        ),
        ChatModel(
          id: '4',
          name: 'Team Flutter',
          lastMessage: 'Meeting at 3 PM today',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 5)),
          unreadCount: 5,
          avatar: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=150&h=150&fit=crop&crop=face',
          type: ChatType.group,
          participants: [
            UserModel(
              id: 'user4',
              name: 'John Team Lead',
              avatar: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=150&h=150&fit=crop&crop=face',
              isOnline: false,
              createdAt: DateTime.now().subtract(Duration(days: 60)),
              updatedAt: DateTime.now().subtract(Duration(hours: 6)),
            ),
            UserModel(
              id: 'user5',
              name: 'Sarah Dev',
              avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face',
              isOnline: true,
              createdAt: DateTime.now().subtract(Duration(days: 40)),
              updatedAt: DateTime.now().subtract(Duration(minutes: 15)),
            ),
          ],
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(hours: 5)),
        ),
      ];
      isLoading.value = false;
    });
  }

  List<ChatModel> get filteredChats {
    if (searchQuery.value.isEmpty) {
      return chats;
    }
    return chats.where((chat) => 
      chat.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      (chat.lastMessage?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)
    ).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void markAsRead(String chatId) {
    final chatIndex = chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex] = chats[chatIndex].copyWith(unreadCount: 0);
      chats.refresh();
    }
  }

  void deleteChat(String chatId) {
    chats.removeWhere((chat) => chat.id == chatId);
  }

  void archiveChat(String chatId) {
    final chatIndex = chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      chats[chatIndex] = chats[chatIndex].copyWith(status: ChatStatus.archived);
      chats.refresh();
    }
  }
}