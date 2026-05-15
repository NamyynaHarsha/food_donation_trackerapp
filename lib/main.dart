import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Donation Tracker',

      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Roboto',

        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF2E7D32),
          onPrimary: Colors.white,
          secondary: Color(0xFFFFA000),
          onSecondary: Colors.white,
          error: Color(0xFFD32F2F),
          onError: Colors.white,
          background: Color(0xFFF5F5F5),
          onBackground: Color(0xFF212121),
          surface: Colors.white,
          onSurface: Color(0xFF212121),
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF5F5F5),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF2E7D32),

            foregroundColor: Colors.white,

            padding:
                const EdgeInsets.symmetric(
              vertical: 16,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15),
            ),
          ),
        ),

        cardTheme: CardThemeData(
          color: Colors.white,

          elevation: 4,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color(0xFF2E7D32),

          foregroundColor: Colors.white,

          elevation: 0,
        ),
      ),

      home: const OnboardingScreen(),
    );
  }
}