import 'package:flutter/material.dart';
import 'package:plantyard/screens/splash_screen.dart';
import 'package:plantyard/screens/auth/login_screen.dart';
import 'package:plantyard/screens/auth/signup_screen.dart';
import 'package:plantyard/screens/home/home_screen.dart';
import 'package:plantyard/screens/profile/profile_screen.dart';
import 'package:plantyard/screens/shop/cart_screen.dart';
import 'package:plantyard/screens/shop/plant_detail_screen.dart';
import 'package:plantyard/models/plant_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantYard',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is String) {
            return HomeScreen(email: args);
          }
          return const HomeScreen(email: 'itilizatè@email.com');
        },
        '/profile': (context) => const ProfileScreen(),
        '/cart': (context) => const CartScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/plant-detail') {
          final plant = settings.arguments as Plant;
          return MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: plant),
          );
        }
        return null;
      },
    );
  }
}
