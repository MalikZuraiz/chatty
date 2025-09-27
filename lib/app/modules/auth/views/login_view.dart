import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glassmorphism_container.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Animated background elements
            ...List.generate(8, (index) => 
              _FloatingElement(key: ValueKey(index))
            ),
            
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Premium logo and welcome text
                      FadeInDown(
                        child: Center(
                          child: Column(
                            children: [
                              NeonGlowContainer(
                                glowColor: AppTheme.neonBlue,
                                glowRadius: 25,
                                width: 100,
                                height: 100,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_rounded,
                                    size: 50,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Welcome Back',
                                style: GoogleFonts.inter(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Sign in to your premium chat experience',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Premium email field
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: PremiumTextField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          controller: controller.loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_rounded,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Premium password field
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        child: Obx(() => PremiumTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: controller.loginPasswordController,
                          obscureText: !controller.isPasswordVisible.value,
                          prefixIcon: Icons.lock_rounded,
                          suffixIcon: controller.isPasswordVisible.value
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          onSuffixIconTap: controller.togglePasswordVisibility,
                        )),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Premium forgot password
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.inter(
                                color: AppTheme.neonBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Premium login button
                      FadeInUp(
                        delay: const Duration(milliseconds: 800),
                        child: Obx(() => PremiumButton(
                          text: 'Sign In',
                          onPressed: controller.login,
                          isLoading: controller.isLoginLoading.value,
                          color: AppTheme.neonBlue,
                          icon: Icons.arrow_forward_rounded,
                        )),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Premium social login divider
                      FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.glassBorder,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Or continue with',
                                style: GoogleFonts.inter(
                                  color: AppTheme.textTertiary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.glassBorder,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Premium social login buttons
                      FadeInUp(
                        delay: const Duration(milliseconds: 1200),
                        child: Row(
                          children: [
                            Expanded(
                              child: _PremiumSocialButton(
                                icon: Icons.g_mobiledata,
                                label: 'Google',
                                color: AppTheme.neonCyan,
                                onPressed: () {
                                  // TODO: Implement Google login
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PremiumSocialButton(
                                icon: Icons.apple,
                                label: 'Apple',
                                color: AppTheme.textPrimary,
                                onPressed: () {
                                  // TODO: Implement Apple login
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Premium sign up link
                      FadeInUp(
                        delay: const Duration(milliseconds: 1400),
                        child: Center(
                          child: GlassmorphismContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24, 
                              vertical: 16
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: GoogleFonts.inter(
                                    color: AppTheme.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.goToSignup,
                                  child: Text(
                                    'Sign Up',
                                    style: GoogleFonts.inter(
                                      color: AppTheme.neonPink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumSocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _PremiumSocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismContainer(
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingElement extends StatefulWidget {
  const _FloatingElement({super.key});

  @override
  State<_FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<_FloatingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
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
    elementSize = 15.0 + (DateTime.now().millisecond % 25);
    
    _controller = AnimationController(
      duration: Duration(seconds: 12 + (DateTime.now().millisecond % 6)),
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
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2),
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
            child: Container(
              width: elementSize,
              height: elementSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: elementColor.withOpacity(0.1),
                border: Border.all(
                  color: elementColor.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: elementColor.withOpacity(0.2),
                    blurRadius: 6,
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