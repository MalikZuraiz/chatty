import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color accent = Color(0xFFEC4899);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  
  // Chat Colors
  static const Color messageBubbleSent = Color(0xFF8B5CF6);
  static const Color messageBubbleReceived = Color(0xFF374151);
  static const Color onlineIndicator = Color(0xFF10B981);
  static const Color offlineIndicator = Color(0xFF6B7280);
  
  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF06B6D4),
    Color(0xFF10B981),
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
  ];
  
  static const List<Color> glassGradient = [
    Color(0x1AFFFFFF),
    Color(0x0DFFFFFF),
  ];
  
  static const List<Color> glassBorderGradient = [
    Color(0x33FFFFFF),
    Color(0x1AFFFFFF),
  ];
  
  // Status Colors
  static const Color statusOnline = Color(0xFF10B981);
  static const Color statusAway = Color(0xFFF59E0B);
  static const Color statusBusy = Color(0xFFEF4444);
  static const Color statusOffline = Color(0xFF6B7280);
  
  // Message Status Colors
  static const Color messageSending = Color(0xFF6B7280);
  static const Color messageSent = Color(0xFF94A3B8);
  static const Color messageDelivered = Color(0xFF06B6D4);
  static const Color messageRead = Color(0xFF10B981);
  
  // Premium Colors
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumSilver = Color(0xFFC0C0C0);
  static const Color premiumBronze = Color(0xFFCD7F32);
  
  // Glassmorphism Colors
  static Color glassBackground = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color glassBackgroundDark = Colors.black.withOpacity(0.1);
  static Color glassBorderDark = Colors.white.withOpacity(0.1);
  
  // Animation Colors
  static const Color shimmerBase = Color(0xFF374151);
  static const Color shimmerHighlight = Color(0xFF4B5563);
  
  // Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color whatsapp = Color(0xFF25D366);
  static const Color telegram = Color(0xFF0088CC);
}