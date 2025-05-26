// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF5F5F5); // fondo general
  static const Color primaryText = Color(0xFF212121); // para texto primario
  static const Color accent = Color(0xFF4CAF50); // para acentos
  static const Color cardBackground = Color(0xFFFFFFFF); // para tarjetas
  static const Color streakCompleted = Color(
    0xFFC8E6C9,
  ); // para rachas completadas
  static const Color shadow = Color(0x22000000); // para sombra
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background, // fondo general del scaffold
  primaryColor: AppColors.primaryText,
  fontFamily: 'Poppins', // fuente de texto

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    background: AppColors.background,
    primary: AppColors.primaryText,
    secondary: AppColors.accent,
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    foregroundColor: AppColors.primaryText,
    titleTextStyle: const TextStyle(
      fontFamily: 'Poppins', // fuente del título
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryText,
    ),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryText,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryText,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.primaryText,
    ),
  ),
);
