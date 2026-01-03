import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PremiumChatListView extends StatefulWidget {
  const PremiumChatListView({super.key});

  @override
  State<PremiumChatListView> createState() => _PremiumChatListViewState();
}

class _PremiumChatListViewState extends State<PremiumChatListView> with TickerProviderStateMixin {
  bool isGridView = false;
  String selectedFilter = 'all';
  late AnimationController _filterAnimController;

  final List<ChatModel> chats = [
    ChatModel(
      id: '1',
      name: 'Sarah Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      lastMessage: 'That sounds amazing! Can\'t wait to see you 🎉',
      time: '2m ago',
      unreadCount: 3,
      isOnline: true,
      isPinned: true,
      category: 'close',
      mood: 'excited',
    ),
    ChatModel(
      id: '2',
      name: 'Alex Jordan',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Alex',
      lastMessage: 'Just sent you the files you requested',
      time: '15m ago',
      unreadCount: 1,
      isOnline: true,
      category: 'work',
      mood: 'professional',
    ),
    ChatModel(
      id: '3',
      name: 'Maya Patel',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Maya',
      lastMessage: 'Loved your story! Where did you take that photo?',
      time: '1h ago',
      unreadCount: 0,
      isOnline: false,
      isPinned: true,
      category: 'friend',
      mood: 'curious',
    ),
    ChatModel(
      id: '4',
      name: 'David Kim',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=David',
      lastMessage: 'Meeting rescheduled to 3 PM tomorrow',
      time: '2h ago',
      unreadCount: 0,
      isOnline: true,
      category: 'work',
      mood: 'neutral',
    ),
    ChatModel(
      id: '5',
      name: 'Emma Wilson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Emma',
      lastMessage: 'Haha that meme was hilarious 😂',
      time: '3h ago',
      unreadCount: 5,
      isOnline: false,
      category: 'friend',
      mood: 'happy',
    ),
    ChatModel(
      id: '6',
      name: 'James Taylor',
      avatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=James',
      lastMessage: 'Thanks for your help today!',
      time: '5h ago',
      unreadCount: 0,
      isOnline: false,
      category: 'work',
      mood: 'grateful',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filterAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _filterAnimController.dispose();
    super.dispose();
  }

  List<ChatModel> get filteredChats {
    if (selectedFilter == 'all') return chats;
    if (selectedFilter == 'unread') {
      return chats.where((chat) => chat.unreadCount > 0).toList();
    }
    return chats.where((chat) => chat.category == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0712),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildPremiumHeader(),
            _buildFilterChips(),
            Expanded(
              child: isGridView ? _buildPremiumGrid() : _buildPremiumList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          // Gradient text title
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF00D4FF),
                Color(0xFF06FFA5),
                Color(0xFF00D4FF),
              ],
            ).createShader(bounds),
            child: Text(
              'Chats',
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Unread badge
          if (chats.where((c) => c.unreadCount > 0).isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF006E).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                '${chats.where((c) => c.unreadCount > 0).length}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          const Spacer(),
          _buildGlassButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildGlassButton(
            icon: isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
            onTap: () => setState(() => isGridView = !isGridView),
            gradient: const LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? Colors.white.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'id': 'all', 'label': 'All', 'icon': Icons.chat_bubble_rounded},
      {'id': 'unread', 'label': 'Unread', 'icon': Icons.mark_chat_unread_rounded},
      {'id': 'close', 'label': 'Close', 'icon': Icons.favorite_rounded},
      {'id': 'work', 'label': 'Work', 'icon': Icons.business_center_rounded},
      {'id': 'friend', 'label': 'Friends', 'icon': Icons.people_rounded},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['id'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => selectedFilter = filter['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: _getFilterGradient(filter['id'] as String),
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _getFilterGradient(filter['id'] as String)[0].withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      filter['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Color> _getFilterGradient(String filterId) {
    switch (filterId) {
      case 'unread':
        return [const Color(0xFFFF006E), const Color(0xFFFF6B9D)];
      case 'close':
        return [const Color(0xFFFF006E), const Color(0xFFFFC6D9)];
      case 'work':
        return [const Color(0xFF06FFA5), const Color(0xFF00D4FF)];
      case 'friend':
        return [const Color(0xFF8B5CF6), const Color(0xFFB794F6)];
      default:
        return [const Color(0xFF00D4FF), const Color(0xFF06FFA5)];
    }
  }

  // PREMIUM LIST VIEW with swipe actions
  Widget _buildPremiumList() {
    final displayChats = filteredChats;
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: displayChats.length,
      itemBuilder: (context, index) {
        return _buildPremiumChatCard(displayChats[index], index);
      },
    );
  }

  Widget _buildPremiumChatCard(ChatModel chat, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(chat.id),
        background: _buildSwipeBackground(true),
        secondaryBackground: _buildSwipeBackground(false),
        child: GestureDetector(
          onTap: () => _openChat(chat),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: chat.unreadCount > 0
                    ? const Color(0xFF00D4FF).withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: chat.unreadCount > 0
                      ? const Color(0xFF00D4FF).withOpacity(0.2)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar with status
                Stack(
                  children: [
                    // Glowing ring for unread
                    if (chat.unreadCount > 0)
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D4FF).withOpacity(0.5),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    Container(
                      width: 66,
                      height: 66,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: chat.unreadCount > 0
                            ? const LinearGradient(
                                colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)],
                              )
                            : null,
                        color: chat.unreadCount > 0 ? null : Colors.white.withOpacity(0.15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1A1A2E),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: chat.avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Online indicator
                    if (chat.isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF06FFA5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1A1A2E),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF06FFA5).withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Pin indicator
                    if (chat.isPinned)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF006E), Color(0xFFFF6B9D)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF006E).withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.push_pin_rounded,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Message content
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
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(chat.category).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getCategoryColor(chat.category).withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getCategoryLabel(chat.category),
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: _getCategoryColor(chat.category),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Mood emoji
                          Text(
                            _getMoodEmoji(chat.mood),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                                color: chat.unreadCount > 0
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.white.withOpacity(0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Time and unread badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat.time,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: chat.unreadCount > 0
                            ? const Color(0xFF00D4FF)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (chat.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D4FF).withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          '${chat.unreadCount}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isLeft) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLeft
              ? [const Color(0xFF06FFA5), const Color(0xFF00D4FF)]
              : [const Color(0xFFFF006E), const Color(0xFFFF6B9D)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(
        isLeft ? Icons.archive_rounded : Icons.delete_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  // PREMIUM GRID VIEW with staggered cards
  Widget _buildPremiumGrid() {
    final displayChats = filteredChats;
    
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: displayChats.length,
      itemBuilder: (context, index) {
        return _buildGridChatCard(displayChats[index]);
      },
    );
  }

  Widget _buildGridChatCard(ChatModel chat) {
    return GestureDetector(
      onTap: () => _openChat(chat),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: chat.unreadCount > 0
                ? const Color(0xFF00D4FF).withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: chat.unreadCount > 0
                  ? const Color(0xFF00D4FF).withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar and badge
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: chat.unreadCount > 0
                              ? const LinearGradient(
                                  colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)],
                                )
                              : null,
                          color: chat.unreadCount > 0 ? null : Colors.white.withOpacity(0.15),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: chat.avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (chat.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF06FFA5),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1A1A2E), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF06FFA5).withOpacity(0.6),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (chat.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D4FF), Color(0xFF06FFA5)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D4FF).withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        '${chat.unreadCount}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Name
              Text(
                chat.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 6),
              
              // Message with mood
              Row(
                children: [
                  Text(
                    _getMoodEmoji(chat.mood),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      chat.lastMessage,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Time and category
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(chat.category).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getCategoryColor(chat.category).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getCategoryLabel(chat.category),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _getCategoryColor(chat.category),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    chat.time,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.5),
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'close':
        return const Color(0xFFFF006E);
      case 'work':
        return const Color(0xFF06FFA5);
      case 'friend':
        return const Color(0xFF00D4FF);
      default:
        return Colors.white;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'close':
        return 'CLOSE';
      case 'work':
        return 'WORK';
      case 'friend':
        return 'FRIEND';
      default:
        return '';
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'excited':
        return '🎉';
      case 'professional':
        return '💼';
      case 'curious':
        return '🤔';
      case 'happy':
        return '😂';
      case 'grateful':
        return '🙏';
      default:
        return '💬';
    }
  }

  void _openChat(ChatModel chat) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${chat.name}'),
        backgroundColor: const Color(0xFF1A1A2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class ChatModel {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isPinned;
  final String category;
  final String mood;

  ChatModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isPinned = false,
    this.category = 'friend',
    this.mood = 'neutral',
  });
}
