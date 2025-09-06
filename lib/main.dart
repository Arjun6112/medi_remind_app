import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medi_remind_app/injection/injection.dart';
import 'package:medi_remind_app/features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        // If system, toggle to light
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediMinder',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      home: HomePage(onThemeToggle: _toggleTheme, currentThemeMode: _themeMode),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF81C784), // Pastel green
        onPrimary: Colors.white,
        secondary: Color(0xFFA5D6A7), // Lighter green
        onSecondary: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black87,
        background: Color(0xFFF1F8E9), // Very light green background
        onBackground: Colors.black87,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F8E9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF81C784),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF81C784),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF81C784),
        foregroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        headlineLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6A1B9A), // Purple
        onPrimary: Colors.white,
        secondary: Color(0xFF8E24AA), // Lighter purple
        onSecondary: Colors.white,
        surface: Color(0xFF1E1E1E), // Dark surface
        onSurface: Colors.white70,
        background: Colors.black,
        onBackground: Colors.white70,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A1B9A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            headlineLarge: GoogleFonts.nunito(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
            headlineMedium: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
            bodyLarge: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
            bodyMedium: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
    );
  }
}
