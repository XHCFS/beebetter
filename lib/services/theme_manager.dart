import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages app theme (light/dark mode)
class ThemeManager extends ChangeNotifier {
  static ThemeManager? _instance;
  bool _isDarkMode = false;
  bool _isInitialized = false;

  ThemeManager._();

  static ThemeManager get instance {
    _instance ??= ThemeManager._();
    return _instance!;
  }

  bool get isDarkMode => _isDarkMode;

  /// Initialize theme from preferences
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  /// Set theme mode explicitly
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) return;
    
    _isDarkMode = isDark;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  /// Get light theme
  static ThemeData getLightTheme() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1), // Modern indigo
      brightness: Brightness.light,
    );
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: baseScheme.copyWith(
        // Customize colors for a modern look
        primary: const Color(0xFF6366F1), // Indigo
        secondary: const Color(0xFF8B5CF6), // Purple
        tertiary: const Color(0xFFEC4899), // Pink
        surface: const Color(0xFFF8FAFC), // Very light gray
        onSurface: const Color(0xFF1E293B), // Dark slate
        surfaceContainerHighest: const Color(0xFFE2E8F0), // Light gray
        surfaceContainerHigh: const Color(0xFFE2E8F0), // Light gray
        surfaceContainer: const Color(0xFFF1F5F9), // Very light gray
        surfaceContainerLow: const Color(0xFFF8FAFC), // Very light gray
        surfaceContainerLowest: Colors.white, // White
        inversePrimary: const Color(0xFF818CF8), // Lighter indigo
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );
  }

  /// Get dark theme
  static ThemeData getDarkTheme() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF818CF8), // Lighter indigo for dark mode
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: baseScheme.copyWith(
        // Customize colors for a modern dark look
        primary: const Color(0xFF818CF8), // Lighter indigo
        secondary: const Color(0xFFA78BFA), // Lighter purple
        tertiary: const Color(0xFFF472B6), // Lighter pink
        surface: const Color(0xFF0F172A), // Very dark slate
        onSurface: const Color(0xFFF1F5F9), // Light slate
        surfaceContainerHighest: const Color(0xFF334155), // Medium dark slate
        surfaceContainerHigh: const Color(0xFF1E293B), // Dark slate
        surfaceContainer: const Color(0xFF1E293B), // Dark slate
        surfaceContainerLow: const Color(0xFF1E293B), // Dark slate
        surfaceContainerLowest: const Color(0xFF0F172A), // Very dark slate
        inversePrimary: const Color(0xFF6366F1), // Indigo
        onPrimary: const Color(0xFF0F172A), // Dark background
        onSecondary: const Color(0xFF0F172A),
        errorContainer: const Color(0xFF7F1D1D), // Dark red
        onErrorContainer: const Color(0xFFFCA5A5), // Light red
      ),
    );
  }
}

