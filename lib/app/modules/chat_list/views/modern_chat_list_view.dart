// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../../core/theme/app_theme.dart';
// import '../controllers/chat_list_controller.dart';
// import '../../../data/models/chat_model.dart';

// class ModernChatListView extends StatefulWidget {
//   const ModernChatListView({super.key});

//   @override
//   State<ModernChatListView> createState() => _ModernChatListViewState();
// }

// class _ModernChatListViewState extends State<ModernChatListView> {
//   bool isGridView = false;
//   final controller = Get.put(ChatListController());

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF0A0712),
//             const Color(0xFF1A1A2E),
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           children: [
//             _buildModernHeader(),
//             _buildSearchBar(),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return _buildLoadingState();
//                 }
                
//                 final chats = controller.filteredChats;
                
//                 if (chats.isEmpty) {
//                   return _buildEmptyState();
//                 }
                
//                 return isGridView 
//                     ? _buildGridView(chats) 
//                     : _buildListView(chats);
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModernHeader() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Messages',
//                 style: GoogleFonts.inter(
//                   fontSize: 32,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                   height: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Obx(() => Text(
//                 '${controller.filteredChats.length} conversations',
//                 style: GoogleFonts.inter(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.white.withOpacity(0.5),
//                 ),
//               )),
//             ],
//           ),
//           const Spacer(),
//           _buildActionButton(
//             icon: isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
//             onTap: () => setState(() => isGridView = !isGridView),
//             color: const Color(0xFF00D4FF),
//           ),
//           const SizedBox(width: 12),
//           _buildActionButton(
//             icon: Icons.add_circle_rounded,
//             onTap: () {},
//             color: const Color(0xFF06FFA5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: color.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//         child: Icon(icon, color: color, size: 22),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.1),
//             width: 1,
//           ),
//         ),
//         child: TextField(
//           onChanged: (value) => controller.searchQuery.value = value,
//           style: GoogleFonts.inter(
//             color: Colors.white,
//             fontSize: 15,
//           ),
//           decoration: InputDecoration(
//             hintText: 'Search messages...',
//             hintStyle: GoogleFonts.inter(
//               color: Colors.white.withOpacity(0.3),
//               fontSize: 15,
//             ),
//             prefixIcon: Icon(
//               Icons.search_rounded,
//               color: Colors.white.withOpacity(0.3),
//               size: 22,
//             ),
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildListView(List<ChatModel> chats) {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
//       itemCount: chats.length,
//       itemBuilder: (context, index) {
//         final chat = chats[index];
//         return _buildChatListItem(chat, index);
//       },
//     );
//   }

//   Widget _buildGridView(List<ChatModel> chats) {
//     return GridView.builder(
//       padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: chats.length,
//       itemBuilder: (context, index) {
//         final chat = chats[index];
//         return _buildChatGridItem(chat);
//       },
//     );
//   }

//   Widget _buildChatListItem(ChatModel chat, int index) {
//     return GestureDetector(
//       onTap: () => Get.toNamed('/chat-detail', arguments: chat),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.08),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF00D4FF).withOpacity(0.3),
//                         Color(0xFF8B5CF6).withOpacity(0.3),
//                       ],
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(16),
//                     child: CachedNetworkImage(
//                       imageUrl: chat.avatar,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => Container(
//                         color: Colors.white.withOpacity(0.1),
//                       ),
//                       errorWidget: (context, url, error) => Icon(
//                         Icons.person,
//                         color: Colors.white.withOpacity(0.5),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (chat.isOnline)
//                   Positioned(
//                     right: 2,
//                     bottom: 2,
//                     child: Container(
//                       width: 14,
//                       height: 14,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF06FFA5),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: const Color(0xFF1A1A2E),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           chat.name,
//                           style: GoogleFonts.inter(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         _formatTime(chat.lastMessageTime),
//                         style: GoogleFonts.inter(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white.withOpacity(0.4),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           chat.lastMessage ?? 'No messages yet',
//                           style: GoogleFonts.inter(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.white.withOpacity(0.5),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       if (chat.unreadCount > 0)
//                         Container(
//                           margin: const EdgeInsets.only(left: 8),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF00D4FF),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             '${chat.unreadCount}',
//                             style: GoogleFonts.inter(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChatGridItem(ChatModel chat) {
//     return GestureDetector(
//       onTap: () => Get.toNamed('/chat-detail', arguments: chat),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.08),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF00D4FF).withOpacity(0.3),
//                         Color(0xFF8B5CF6).withOpacity(0.3),
//                       ],
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: chat.avatar != null
//                         ? CachedNetworkImage(
//                             imageUrl: chat.avatar!,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Container(
//                               color: Colors.white.withOpacity(0.1),
//                             ),
//                             errorWidget: (context, url, error) => Icon(
//                               Icons.person,
//                               size: 40,
//                               color: Colors.white.withOpacity(0.5),
//                             ),
//                           )
//                         : Icon(
//                             Icons.person,
//                             size: 40,
//                             color: Colors.white.withOpacity(0.5),
//                           ),
//                   ),
//                 ),
//                 if (chat.isOnline)
//                   Positioned(
//                     right: 4,
//                     bottom: 4,
//                     child: Container(
//                       width: 16,
//                       height: 16,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF06FFA5),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: const Color(0xFF1A1A2E),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 if (chat.unreadCount > 0)
//                   Positioned(
//                     right: -4,
//                     top: -4,
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF00D4FF),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Text(
//                         '${chat.unreadCount}',
//                         style: GoogleFonts.inter(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 chat.name,
//                 style: GoogleFonts.inter(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 chat.lastMessage ?? 'No messages yet',
//                 style: GoogleFonts.inter(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.white.withOpacity(0.5),
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _formatTime(chat.lastMessageTime),
//               style: GoogleFonts.inter(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(
//       child: CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.chat_bubble_outline_rounded,
//             size: 80,
//             color: Colors.white.withOpacity(0.2),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No messages yet',
//             style: GoogleFonts.inter(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.white.withOpacity(0.5),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Start a conversation with your friends',
//             style: GoogleFonts.inter(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               color: Colors.white.withOpacity(0.3),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(DateTime? dateTime) {
//     if (dateTime == null) return '';
    
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
    
//     if (difference.inDays == 0) {
//       return timeago.format(dateTime, locale: 'en_short');
//     } else if (difference.inDays == 1) {
//       return 'Yesterday';
//     } else if (difference.inDays < 7) {
//       final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//       return days[dateTime.weekday - 1];
//     } else {
//       return '${dateTime.day}/${dateTime.month}';
//     }
//   }
// }
