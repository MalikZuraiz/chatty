import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Animated background particles
            ...List.generate(20, (index) => 
              _AnimatedParticle(key: ValueKey(index))
            ),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Premium logo with glassmorphism
                  FadeInDown(
                    duration: const Duration(milliseconds: 1200),
                    child: NeonGlowContainer(
                      glowColor: AppTheme.neonBlue,
                      glowRadius: 30,
                      width: 140,
                      height: 140,
                      borderRadius: BorderRadius.circular(35),
                      child: GlassmorphismContainer(
                        width: 140,
                        height: 140,
                        padding: const EdgeInsets.all(0),
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_rounded,
                            size: 70,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // App name with premium typography
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 1200),
                    child: ShaderMask(
                      shaderCallback: (bounds) => AppTheme.primaryGradient
                          .createShader(bounds),
                      child: Text(
                        'Chatty',
                        style: GoogleFonts.inter(
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Premium tagline
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 1200),
                    child: Text(
                      'Premium Social Chat Experience',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 100),
                  
                  // Premium loading indicator
                  FadeInUp(
                    delay: const Duration(milliseconds: 1200),
                    duration: const Duration(milliseconds: 1200),
                    child: _PremiumLoadingIndicator(),
                  ),
                ],
              ),
            ),
            
            // Bottom branding
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FadeInUp(
                delay: const Duration(milliseconds: 1600),
                duration: const Duration(milliseconds: 1200),
                child: Column(
                  children: [
                    Text(
                      'Next-Gen Messaging',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textTertiary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: AppTheme.secondaryGradient,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumLoadingIndicator extends StatefulWidget {
  @override
  State<_PremiumLoadingIndicator> createState() => _PremiumLoadingIndicatorState();
}

class _PremiumLoadingIndicatorState extends State<_PremiumLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: AppTheme.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonBlue.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppTheme.backgroundDark,
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  color: AppTheme.neonBlue,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedParticle extends StatefulWidget {
  const _AnimatedParticle({super.key});

  @override
  State<_AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<_AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late Color particleColor;
  late double particleSize;

  @override
  void initState() {
    super.initState();
    
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPink,
      AppTheme.neonPurple,
      AppTheme.neonCyan,
    ];
    
    particleColor = colors[DateTime.now().millisecond % colors.length];
    particleSize = 2.0 + (DateTime.now().millisecond % 4);
    
    _controller = AnimationController(
      duration: Duration(seconds: 8 + (DateTime.now().millisecond % 5)),
      vsync: this,
    );
    
    _positionAnimation = Tween<Offset>(
      begin: Offset(
        (DateTime.now().millisecondsSinceEpoch % 100) / 100,
        1.2,
      ),
      end: Offset(
        (DateTime.now().millisecondsSinceEpoch % 100) / 100,
        -0.2,
      ),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3),
    ));
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: MediaQuery.of(context).size.width * _positionAnimation.value.dx,
          top: MediaQuery.of(context).size.height * _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: particleSize,
              height: particleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: particleColor,
                boxShadow: [
                  BoxShadow(
                    color: particleColor.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}