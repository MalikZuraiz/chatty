// import 'dart:ui';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:animate_do/animate_do.dart';

// import '../controllers/chat_detail_controller.dart';
// import '../../../data/models/message_model.dart';
// import '../../../core/theme/app_theme.dart';
// import '../../../core/widgets/glassmorphism_container.dart';


// class ChatDetailView extends GetView<ChatDetailController> {
//   const ChatDetailView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundDark,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppTheme.backgroundGradient,
//         ),
//         child: Stack(
//           children: [
//             // Premium animated background particles
//             ...List.generate(6, (index) => 
//               _FloatingChatParticle(key: ValueKey(index), index: index)
//             ),
            
//             SafeArea(
//               child: Column(
//                 children: [
//                   _buildPremiumAppBar(context),
//                   Expanded(
//                     child: _buildPremiumMessageList(),
//                   ),
//                   _buildPremiumInputArea(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumAppBar(BuildContext context) {
//     return FadeInDown(
//       duration: const Duration(milliseconds: 800),
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         child: GlassmorphismContainer(
//           width: double.infinity,
//           borderRadius: BorderRadius.circular(24),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//             constraints: const BoxConstraints(minHeight: 60),
//             child: Row(
//               children: [
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(22),
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFF1A1A2E),
//                         Color(0xFF16213E),
//                       ],
//                     ),
//                     border: Border.all(
//                       color: AppTheme.neonBlue.withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
              
//               // Premium Avatar with Neon Glow
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppTheme.neonBlue.withOpacity(0.5),
//                       blurRadius: 15,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 22,
//                   backgroundColor: AppTheme.neonBlue.withOpacity(0.2),
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundImage: controller.currentChat?.participants.isNotEmpty == true &&
//                             controller.currentChat?.participants.first.avatar != null
//                         ? NetworkImage(controller.currentChat!.participants.first.avatar!)
//                         : const NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Felix'),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       controller.currentChat?.name ?? 'Chat',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                     const SizedBox(height: 2),
//                     Obx(() => Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (controller.isOnline.value)
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: AppTheme.neonCyan,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppTheme.neonCyan.withOpacity(0.6),
//                                   blurRadius: 8,
//                                   spreadRadius: 1,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if (controller.isOnline.value) const SizedBox(width: 6),
//                         Flexible(
//                           child: Text(
//                             controller.isTyping.value 
//                               ? 'typing...'
//                               : controller.isOnline.value 
//                                 ? 'online'
//                                 : 'last seen recently',
//                             style: TextStyle(
//                               color: controller.isTyping.value
//                                 ? AppTheme.neonPink
//                                 : controller.isOnline.value
//                                   ? AppTheme.neonCyan
//                                   : Colors.grey[400],
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     )),
//                   ],
//                 ),
//               ),
              
//               // Premium Action Buttons
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildNeonButton(
//                     icon: Icons.videocam_rounded,
//                     color: AppTheme.neonPurple,
//                     size: 24,
//                     onTap: () => _handleMenuAction('video_call'),
//                   ),
//                   const SizedBox(width: 8),
//                   _buildNeonButton(
//                     icon: Icons.call_rounded,
//                     color: AppTheme.neonCyan,
//                     size: 22,
//                     onTap: () => _handleMenuAction('call'),
//                   ),
//                   const SizedBox(width: 8),
//                   _buildNeonButton(
//                     icon: Icons.more_vert_rounded,
//                     color: Colors.white70,
//                     size: 20,
//                     onTap: () => _showPremiumMenu(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 8),
//             ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNeonButton({
//     required IconData icon,
//     required Color color,
//     required double size,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color.withOpacity(0.1),
//           border: Border.all(
//             color: color.withOpacity(0.3),
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.2),
//               blurRadius: 8,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: Icon(icon, color: color, size: size),
//       ),
//     );
//   }



//   Widget _buildPremiumMessageList() {
//     return Obx(() => ListView.builder(
//       controller: controller.scrollController,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index == controller.messages.length && controller.isTyping.value) {
//           return _buildPremiumTypingIndicator();
//         }
        
//         final message = controller.messages[index];
//         final isFirstInGroup = index == 0 ||
//             controller.messages[index - 1].senderId != message.senderId ||
//             message.timestamp.difference(controller.messages[index - 1].timestamp).inMinutes > 5;
//         final isLastInGroup = index == controller.messages.length - 1 ||
//             controller.messages[index + 1].senderId != message.senderId ||
//             controller.messages[index + 1].timestamp.difference(message.timestamp).inMinutes > 5;

//         return FadeInUp(
//           duration: const Duration(milliseconds: 400),
//           delay: Duration(milliseconds: index * 30),
//           child: _buildPremiumMessageBubble(
//             message: message,
//             isFirstInGroup: isFirstInGroup,
//             isLastInGroup: isLastInGroup,
//           ),
//         );
//       },
//     ));
//   }

//   Widget _buildPremiumMessageBubble({
//     required MessageModel message,
//     required bool isFirstInGroup,
//     required bool isLastInGroup,
//   }) {
//     final isMe = message.senderId == 'current_user'; // Replace with actual current user ID
    
//     return Container(
//       margin: EdgeInsets.only(
//         bottom: isLastInGroup ? 16 : 4,
//         left: isMe ? 50 : 0,
//         right: isMe ? 0 : 50,
//       ),
//       child: Column(
//         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           if (isFirstInGroup && !isMe)
//             Padding(
//               padding: const EdgeInsets.only(left: 16, bottom: 4),
//               child: Text(
//                 message.senderName,
//                 style: const TextStyle(
//                   color: AppTheme.neonBlue,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
          
//           GestureDetector(
//             onLongPress: () => controller.startSelectionMode(message.id),
//             onTap: controller.isSelectionMode.value
//                 ? () => controller.toggleMessageSelection(message.id)
//                 : null,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: (isMe ? AppTheme.neonBlue : AppTheme.neonPurple).withOpacity(0.2),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: GlassmorphismContainer(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: isMe 
//                       ? LinearGradient(
//                           colors: [
//                             AppTheme.neonBlue.withOpacity(0.3),
//                             AppTheme.neonPurple.withOpacity(0.2),
//                           ],
//                         )
//                       : LinearGradient(
//                           colors: [
//                             AppTheme.cardDark.withOpacity(0.8),
//                             AppTheme.cardDark.withOpacity(0.6),
//                           ],
//                         ),
//                     border: Border.all(
//                       color: (isMe ? AppTheme.neonBlue : AppTheme.neonPurple).withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Message content
//                       Text(
//                         message.content,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                           height: 1.4,
//                         ),
//                       ),
                      
//                       const SizedBox(height: 6),
                      
//                       // Time and status
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             _formatTime(message.timestamp),
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           if (isMe) ...[
//                             const SizedBox(width: 4),
//                             Icon(
//                               message.status == MessageStatus.sent
//                                   ? Icons.check
//                                   : message.status == MessageStatus.delivered
//                                       ? Icons.done_all
//                                       : Icons.done_all,
//                               size: 14,
//                               color: message.status == MessageStatus.delivered
//                                   ? AppTheme.neonCyan
//                                   : Colors.white70,
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPremiumTypingIndicator() {
//     return FadeInUp(
//       duration: const Duration(milliseconds: 300),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16, right: 50),
//         child: Row(
//           children: [
//             const SizedBox(width: 16),
//             Container(
//               width: 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color: AppTheme.neonPink,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppTheme.neonPink.withOpacity(0.6),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             GlassmorphismContainer(
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ...List.generate(3, (index) => 
//                       TweenAnimationBuilder<double>(
//                         duration: const Duration(milliseconds: 600),
//                         tween: Tween(begin: 0.3, end: 1.0),
//                         builder: (context, value, child) {
//                           return AnimatedContainer(
//                             duration: const Duration(milliseconds: 600),
//                             width: 6,
//                             height: 6 * value,
//                             margin: const EdgeInsets.symmetric(horizontal: 2),
//                             decoration: BoxDecoration(
//                               color: AppTheme.neonPink.withOpacity(value),
//                               shape: BoxShape.circle,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }



//   Widget _buildPremiumInputArea() {
//     return FadeInUp(
//       duration: const Duration(milliseconds: 600),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Reply preview
//             Obx(() => controller.replyToMessage.value != null
//                 ? _buildPremiumReplyPreview()
//                 : const SizedBox.shrink()),
            
//             // Selection mode actions or input
//             Obx(() => controller.isSelectionMode.value
//                 ? _buildPremiumSelectionActions()
//                 : _buildPremiumChatInput()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumChatInput() {
//     return GlassmorphismContainer(
//       borderRadius: BorderRadius.circular(25),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Media button
//             _buildNeonButton(
//               icon: Icons.add_circle_outline,
//               color: AppTheme.neonPurple,
//               size: 28,
//               onTap: () => _showMediaOptions(),
//             ),
            
//             const SizedBox(width: 12),
            
//             // Text input
//             Flexible(
//               child: Container(
//                 constraints: const BoxConstraints(maxHeight: 120),
//                 child: TextField(
//                   controller: controller.messageController,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   maxLines: null,
//                   decoration: const InputDecoration(
//                     hintText: 'Type a message...',
//                     hintStyle: TextStyle(
//                       color: Colors.white60,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ),
//             ),
            
//             const SizedBox(width: 12),
            
//             // Send/Voice button
//             _buildNeonButton(
//               icon: Icons.send_rounded,
//               color: AppTheme.neonCyan,
//               size: 28,
//               onTap: () {
//                 if (controller.messageController.text.trim().isNotEmpty) {
//                   controller.sendMessage();
//                   controller.messageController.clear();
//                 } else {
//                   controller.startVoiceRecording();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }







//   Widget _buildPremiumReplyPreview() {
//     final replyMessage = controller.replyToMessage.value!;
//     return FadeInUp(
//       duration: const Duration(milliseconds: 300),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         child: GlassmorphismContainer(
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 Container(
//                   width: 4,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [AppTheme.neonPurple, AppTheme.neonPink],
//                     ),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         replyMessage.senderName,
//                         style: const TextStyle(
//                           color: AppTheme.neonPurple,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         replyMessage.content,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildNeonButton(
//                   icon: Icons.close,
//                   color: Colors.white70,
//                   size: 20,
//                   onTap: controller.cancelReply,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumSelectionActions() {
//     return GlassmorphismContainer(
//       borderRadius: BorderRadius.circular(25),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildNeonButton(
//               icon: Icons.close,
//               color: Colors.white70,
//               size: 24,
//               onTap: controller.exitSelectionMode,
//             ),
            
//             const SizedBox(width: 16),
            
//             Flexible(
//               child: Obx(() => Text(
//                 '${controller.selectedMessages.length} selected',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               )),
//             ),
            
            
//             const SizedBox(width: 8),
            
//             _buildNeonButton(
//               icon: Icons.reply,
//               color: AppTheme.neonBlue,
//               size: 24,
//               onTap: () {
//                 // Reply to selected message
//               },
//             ),
            
//             const SizedBox(width: 8),
            
//             _buildNeonButton(
//               icon: Icons.forward,
//               color: AppTheme.neonCyan,
//               size: 24,
//               onTap: controller.forwardSelectedMessages,
//             ),
            
//             const SizedBox(width: 8),
            
//             _buildNeonButton(
//               icon: Icons.delete,
//               color: AppTheme.neonPink,
//               size: 24,
//               onTap: controller.deleteSelectedMessages,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPremiumMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//         ),
//         child: GlassmorphismContainer(
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.white30,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 _buildMenuOption(
//                   icon: Icons.info_outline,
//                   title: 'View Profile',
//                   color: AppTheme.neonBlue,
//                   onTap: () => _handleMenuAction('view_profile'),
//                 ),
                
//                 _buildMenuOption(
//                   icon: Icons.search,
//                   title: 'Search in Chat',
//                   color: AppTheme.neonCyan,
//                   onTap: () => _handleMenuAction('search'),
//                 ),
                
//                 _buildMenuOption(
//                   icon: Icons.notifications_off_outlined,
//                   title: 'Mute Notifications',
//                   color: AppTheme.neonPurple,
//                   onTap: () => _handleMenuAction('mute'),
//                 ),
                
//                 _buildMenuOption(
//                   icon: Icons.clear_all,
//                   title: 'Clear Chat',
//                   color: AppTheme.neonPink,
//                   onTap: () => _handleMenuAction('clear_chat'),
//                 ),
                
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuOption({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Get.back();
//             onTap();
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               children: [
//                 Icon(icon, color: color, size: 24),
//                 const SizedBox(width: 16),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showMediaOptions() {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//         ),
//         child: GlassmorphismContainer(
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.white30,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildMediaOption(
//                       icon: Icons.photo_library,
//                       title: 'Gallery',
//                       color: AppTheme.neonPurple,
//                       onTap: () {},
//                     ),
//                     _buildMediaOption(
//                       icon: Icons.camera_alt,
//                       title: 'Camera',
//                       color: AppTheme.neonBlue,
//                       onTap: () {},
//                     ),
//                     _buildMediaOption(
//                       icon: Icons.insert_drive_file,
//                       title: 'Document',
//                       color: AppTheme.neonCyan,
//                       onTap: () {},
//                     ),
//                     _buildMediaOption(
//                       icon: Icons.location_on,
//                       title: 'Location',
//                       color: AppTheme.neonPink,
//                       onTap: () {},
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         Get.back();
//         onTap();
//       },
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [
//                   color.withOpacity(0.3),
//                   color.withOpacity(0.1),
//                 ],
//               ),
//               border: Border.all(
//                 color: color.withOpacity(0.5),
//                 width: 1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.3),
//                   blurRadius: 12,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
//     if (messageDate == today) {
//       return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } else if (messageDate == today.subtract(const Duration(days: 1))) {
//       return 'Yesterday';
//     } else {
//       return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//     }
//   }

//   void _handleMenuAction(String action) {
//     switch (action) {
//       case 'call':
//         Get.snackbar(
//           'Voice Call',
//           '🎯 Premium voice call feature coming soon!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppTheme.neonCyan.withOpacity(0.1),
//           colorText: Colors.white,
//           borderRadius: 12,
//           margin: const EdgeInsets.all(16),
//         );
//         break;
//       case 'video_call':
//         Get.snackbar(
//           'Video Call',
//           '📹 Premium video call feature coming soon!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppTheme.neonPurple.withOpacity(0.1),
//           colorText: Colors.white,
//           borderRadius: 12,
//           margin: const EdgeInsets.all(16),
//         );
//         break;
//       case 'view_profile':
//         // Navigate to profile
//         break;
//       case 'search':
//         Get.snackbar(
//           'Search',
//           '🔍 Search in chat feature coming soon!',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: AppTheme.neonBlue.withOpacity(0.1),
//           colorText: Colors.white,
//           borderRadius: 12,
//           margin: const EdgeInsets.all(16),
//         );
//         break;
//       case 'clear_chat':
//         _showClearChatDialog();
//         break;
//     }
//   }

//   void _showClearChatDialog() {
//     Get.dialog(
//       AlertDialog(
//         backgroundColor: Colors.transparent,
//         content: GlassmorphismContainer(
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.warning_amber_rounded,
//                   color: AppTheme.neonPink,
//                   size: 48,
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Clear Chat',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Are you sure you want to clear all messages? This action cannot be undone.',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => Get.back(),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
//                             ),
//                           ),
//                           child: const Text(
//                             'Cancel',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () {
//                           controller.messages.clear();
//                           Get.back();
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             gradient: LinearGradient(
//                               colors: [AppTheme.neonPink, AppTheme.neonPink.withOpacity(0.7)],
//                             ),
//                           ),
//                           child: const Text(
//                             'Clear',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Premium floating chat particles
// class _FloatingChatParticle extends StatefulWidget {
//   final int index;
  
//   const _FloatingChatParticle({
//     Key? key,
//     required this.index,
//   }) : super(key: key);

//   @override
//   State<_FloatingChatParticle> createState() => _FloatingChatParticleState();
// }

// class _FloatingChatParticleState extends State<_FloatingChatParticle>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late double _startX;
//   late double _startY;

//   @override
//   void initState() {
//     super.initState();
    
//     _animationController = AnimationController(
//       duration: Duration(seconds: 8 + widget.index * 2),
//       vsync: this,
//     );

//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.linear,
//     ));

//     _startX = math.Random().nextDouble() * 300;
//     _startY = math.Random().nextDouble() * 600 + 100;

//     _animationController.repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = [
//       AppTheme.neonBlue,
//       AppTheme.neonPurple,
//       AppTheme.neonPink,
//       AppTheme.neonCyan,
//     ];
    
//     final color = colors[widget.index % colors.length];
    
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Positioned(
//           left: _startX + math.sin(_animation.value * math.pi * 2) * 30,
//           top: _startY - (_animation.value * 800),
//           child: Opacity(
//             opacity: (1 - _animation.value) * 0.3,
//             child: Container(
//               width: 4 + (widget.index % 3) * 2,
//               height: 4 + (widget.index % 3) * 2,
//               decoration: BoxDecoration(
//                 color: color,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: color.withOpacity(0.5),
//                     blurRadius: 8,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }