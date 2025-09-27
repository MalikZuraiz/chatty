import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

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
            ...List.generate(15, (index) => 
              _AnimatedBackgroundElement(key: ValueKey(index))
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // Premium skip button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GlassmorphismContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 10
                          ),
                          child: GestureDetector(
                            onTap: controller.skipOnboarding,
                            child: Text(
                              'Skip',
                              style: GoogleFonts.inter(
                                color: AppTheme.textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  // Premium page content
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: (index) => controller.currentPage.value = index,
                      itemCount: controller.onboardingPages.length,
                      itemBuilder: (context, index) {
                        final data = controller.onboardingPages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Premium glassmorphism card with icon
                              FadeInDown(
                                delay: Duration(milliseconds: 300 * index),
                                child: PremiumCard(
                                  width: 240,
                                  height: 240,
                                  showNeonBorder: true,
                                  neonColor: _getColorForIndex(index),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      NeonIcon(
                                        icon: data.icon,
                                        color: _getColorForIndex(index),
                                        size: 80,
                                        isAnimated: true,
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        width: 60,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              _getColorForIndex(index),
                                              _getColorForIndex(index).withOpacity(0.3),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 80),
                              
                              // Premium title
                              FadeInUp(
                                delay: Duration(milliseconds: 500 + 300 * index),
                                child: Text(
                                  data.title,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    height: 1.1,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Premium subtitle
                              FadeInUp(
                                delay: Duration(milliseconds: 700 + 300 * index),
                                child: Text(
                                  data.subtitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: AppTheme.textSecondary,
                                    height: 1.4,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              
                  // Premium bottom section
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        // Premium page indicators
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.onboardingPages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: controller.currentPage.value == index ? 32 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: controller.currentPage.value == index
                                    ? LinearGradient(
                                        colors: [
                                          _getColorForIndex(index),
                                          _getColorForIndex(index).withOpacity(0.6),
                                        ],
                                      )
                                    : null,
                                color: controller.currentPage.value == index
                                    ? null
                                    : AppTheme.textTertiary.withOpacity(0.3),
                                boxShadow: controller.currentPage.value == index
                                    ? [
                                        BoxShadow(
                                          color: _getColorForIndex(index).withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        )),
                        
                        const SizedBox(height: 50),
                        
                        // Premium navigation buttons
                        Row(
                          children: [
                            // Previous button
                            Obx(() => controller.currentPage.value > 0
                              ? Expanded(
                                  child: GlassmorphismContainer(
                                    height: 56,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: controller.previousPage,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Center(
                                          child: Text(
                                            'Previous',
                                            style: GoogleFonts.inter(
                                              color: AppTheme.textSecondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                            ),
                            
                            if (controller.currentPage.value > 0) const SizedBox(width: 16),
                            
                            // Next/Get Started button
                            Expanded(
                              child: Obx(() => PremiumButton(
                                text: controller.currentPage.value == controller.onboardingPages.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                onPressed: controller.nextPage,
                                color: _getColorForIndex(controller.currentPage.value),
                                icon: controller.currentPage.value == controller.onboardingPages.length - 1
                                    ? Icons.arrow_forward_rounded
                                    : Icons.navigate_next_rounded,
                              )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      AppTheme.neonPink,
      AppTheme.neonCyan,
    ];
    return colors[index % colors.length];
  }
}

class _AnimatedBackgroundElement extends StatefulWidget {
  const _AnimatedBackgroundElement({super.key});

  @override
  State<_AnimatedBackgroundElement> createState() => _AnimatedBackgroundElementState();
}

class _AnimatedBackgroundElementState extends State<_AnimatedBackgroundElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Color elementColor;
  late double elementSize;

  @override
  void initState() {
    super.initState();
    
    final colors = [
      AppTheme.neonBlue,
      AppTheme.neonPurple,
      AppTheme.neonPink,
      AppTheme.neonCyan,
    ];
    
    elementColor = colors[DateTime.now().millisecond % colors.length];
    elementSize = 20.0 + (DateTime.now().millisecond % 30);
    
    _controller = AnimationController(
      duration: Duration(seconds: 10 + (DateTime.now().millisecond % 8)),
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
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3),
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
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
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: elementSize,
                height: elementSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: elementColor.withOpacity(0.1),
                  border: Border.all(
                    color: elementColor.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: elementColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}