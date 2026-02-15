import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFC8E6C9);
  static const Color brown = Color(0xFF8D6E63);
  static const Color beige = Color(0xFFEFEBE9);
}

class ApiEndpoints {
  static const String baseUrl = 'https://api.plantyard.com/v1';
  static const String plants = '$baseUrl/plants';
  static const String categories = '$baseUrl/categories';
  static const String users = '$baseUrl/users';
  static const String orders = '$baseUrl/orders';

  // Endpoint pou plant yon pepinyè espesifik
  static String nurseryPlants(String nurseryId) =>
      '$baseUrl/nurseries/$nurseryId/plants';
}

class AppStrings {
  static const String appName = 'PlantYard';
  static const String welcome = 'Byenveni sou PlantYard';
  static const String email = 'Imèl';
  static const String password = 'Modpas';
  static const String login = 'Konekte';
  static const String signup = 'Enskri';
  static const String searchHint = 'Chèche yon plant...';
}
