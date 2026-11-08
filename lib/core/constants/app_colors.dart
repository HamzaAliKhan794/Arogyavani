import 'package:flutter/material.dart';

/// Clinical Design Tokens for Arogyavani
class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primaryTeal = Color(0xFF0B5D6E); // Deep Medical Teal
  static const Color primaryTealDark = Color(0xFF08434F);
  static const Color primaryTealLight = Color(0xFF147A8F);

  static const Color medicalBlue = Color(0xFF1A73E8); // Medical Blue
  static const Color medicalBlueLight = Color(0xFF4285F4);
  static const Color medicalBlueDark = Color(0xFF1557B0);
  static const Color medicalBlueSoft = Color(0xFFEFF6FF);

  // Surface & Canvas
  static const Color scaffoldBackground = Color(0xFFF8FAFC); // Cool Off-White
  static const Color cardSurface = Color(0xFFFFFFFF); // Crisp White
  static const Color secondarySurface = Color(0xFFF1F5F9);

  // Borders & Dividers
  static const Color borderSubtle = Color(0xFFE2E8F0); // Subtle Cool Grey
  static const Color borderFocus = Color(0xFF93C5FD);
  static const Color borderDashed = Color(0xFFBFDBFE);

  // Status & Clinical Accents
  static const Color emeraldSuccess = Color(0xFF059669);
  static const Color emeraldBg = Color(0xFFECFDF5);
  static const Color emeraldBorder = Color(0xFFA7F3D0);

  static const Color amberWarning = Color(0xFFB45309);
  static const Color amberBg = Color(0xFFFEF3C7);
  static const Color amberBorder = Color(0xFFFDE68A);
  static const Color warningText = amberWarning;
  static const Color warningBg = amberBg;

  static const Color coralError = Color(0xFFB91C1C);
  static const Color coralBg = Color(0xFFFEE2E2);
  static const Color coralBorder = Color(0xFFFECACA);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Color(0xFFFFFFFF);

  // Quick Access Pastel Tile Backgrounds
  static const Color tilePeachBg = Color(0xFFFFF7ED);
  static const Color tilePeachIcon = Color(0xFFEA580C);

  static const Color tileMintBg = Color(0xFFF0FDF4);
  static const Color tileMintIcon = Color(0xFF16A34A);

  static const Color tileYellowBg = Color(0xFFFEFCE8);
  static const Color tileYellowIcon = Color(0xFFCA8A04);

  static const Color tileLavenderBg = Color(0xFFF5F3FF);
  static const Color tileLavenderIcon = Color(0xFF7C3AED);

  // Shadows
  static const Color shadowColor = Color(0x0C0F172A);
}
