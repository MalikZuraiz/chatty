import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class TypingIndicator extends StatefulWidget {
  final String? userName;
  final String? userAvatar;

  const TypingIndicator({
    Key? key,
    this.userName,
    this.userAvatar,
  }) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 50,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          if (widget.userAvatar != null || widget.userName != null)
            Container(
              margin: EdgeInsets.only(right: 8, bottom: 0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: widget.userAvatar != null
                    ? NetworkImage(widget.userAvatar!)
                    : null,
                backgroundColor: Colors.purple.withValues(alpha: 0.3),
                child: widget.userAvatar == null
                    ? Icon(Icons.person, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          
          // Typing bubble
          Flexible(
            child: GlassmorphicContainer(
              width: 60,
              height: 40,
              borderRadius: 18,
              blur: 20,
              alignment: Alignment.center,
              border: 1,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(0),
                  SizedBox(width: 4),
                  _buildDot(1),
                  SizedBox(width: 4),
                  _buildDot(2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Create a staggered animation for each dot
        double animationValue = _animation.value;
        double dotDelay = index * 0.2;
        double dotAnimation = (animationValue - dotDelay).clamp(0.0, 1.0);
        
        // Create a pulsing effect
        double scale = 1.0;
        double opacity = 0.3;
        
        if (dotAnimation > 0) {
          double normalizedValue = (dotAnimation * 2 - 1).abs();
          scale = 1.0 + (0.5 * (1 - normalizedValue));
          opacity = 0.3 + (0.7 * (1 - normalizedValue));
        }

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}