import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/message_model.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onVoiceStart;
  final VoidCallback? onVoiceStop;
  final Function(MessageType, String)? onMediaPick;
  final bool isRecording;

  const ChatInput({
    Key? key,
    required this.controller,
    required this.onSend,
    this.onVoiceStart,
    this.onVoiceStop,
    this.onMediaPick,
    this.isRecording = false,
  }) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;
  late AnimationController _recordController;
  late Animation<double> _expandAnimation;
  late Animation<double> _recordAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _recordController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    _recordAnimation = CurvedAnimation(
      parent: _recordController,
      curve: Curves.easeInOut,
    );

    // Listen to recording state changes
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _expandController.dispose();
    _recordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _recordController.repeat();
      } else {
        _recordController.stop();
        _recordController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Media options (expandable)
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return SizeTransition(
              sizeFactor: _expandAnimation,
              child: _buildMediaOptions(),
            );
          },
        ),
        
        // Main input area
        GlassmorphicContainer(
          width: double.infinity,
          height: 60,
          borderRadius: 30,
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
              // Expand media options button
              IconButton(
                onPressed: _toggleMediaOptions,
                icon: AnimatedRotation(
                  turns: _isExpanded ? 0.125 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.add,
                    color: Colors.white70,
                  ),
                ),
              ),
              
              // Text input field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              
              // Send/Voice button
              _buildActionButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaOptions() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMediaOption(
              icon: Icons.camera_alt,
              label: 'Camera',
              color: Colors.green,
              onTap: () => _pickImage(ImageSource.camera),
            ),
            _buildMediaOption(
              icon: Icons.photo_library,
              label: 'Gallery',
              color: Colors.blue,
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            _buildMediaOption(
              icon: Icons.videocam,
              label: 'Video',
              color: Colors.red,
              onTap: () => _pickVideo(),
            ),
            _buildMediaOption(
              icon: Icons.insert_drive_file,
              label: 'File',
              color: Colors.orange,
              onTap: () => _pickFile(),
            ),
            _buildMediaOption(
              icon: Icons.location_on,
              label: 'Location',
              color: Colors.purple,
              onTap: () => _shareLocation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final hasText = widget.controller.text.trim().isNotEmpty;

    if (widget.isRecording) {
      return AnimatedBuilder(
        animation: _recordAnimation,
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.all(8),
            child: GestureDetector(
              onTap: widget.onVoiceStop,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.8),
                      Colors.red.withValues(alpha: 0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: _recordAnimation.value * 0.5),
                      blurRadius: 10 + (10 * _recordAnimation.value),
                      spreadRadius: 2 + (3 * _recordAnimation.value),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.stop,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: hasText ? widget.onSend : widget.onVoiceStart,
        onLongPress: !hasText ? widget.onVoiceStart : null,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: hasText
                  ? [
                      Colors.purple.withValues(alpha: 0.8),
                      Colors.blue.withValues(alpha: 0.8),
                    ]
                  : [
                      Colors.green.withValues(alpha: 0.8),
                      Colors.teal.withValues(alpha: 0.8),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: (hasText ? Colors.purple : Colors.green).withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            hasText ? Icons.send : Icons.mic,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _toggleMediaOptions() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null && widget.onMediaPick != null) {
        widget.onMediaPick!(MessageType.image, image.path);
        _toggleMediaOptions(); // Close media options
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      
      if (video != null && widget.onMediaPick != null) {
        widget.onMediaPick!(MessageType.video, video.path);
        _toggleMediaOptions(); // Close media options
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      
      if (result != null && result.files.single.path != null && widget.onMediaPick != null) {
        widget.onMediaPick!(MessageType.file, result.files.single.path!);
        _toggleMediaOptions(); // Close media options
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareLocation() {
    // TODO: Implement location sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location sharing will be implemented'),
        backgroundColor: Colors.purple,
      ),
    );
    _toggleMediaOptions(); // Close media options
  }
}