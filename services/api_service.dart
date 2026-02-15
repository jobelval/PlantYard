import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/category_model.dart';
import 'package:plantyard/utils/constants.dart';

class ApiService {
  // Jwenn tout plant yo
  Future<List<Plant>> fetchPlants() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.plants));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Plant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plants');
      }
    } catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }

  // Jwenn plant pa kategori
  Future<List<Plant>> fetchPlantsByCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.plants}?category=$categoryId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Plant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plants for category');
      }
    } catch (e) {
      throw Exception('Error fetching plants by category: $e');
    }
  }

  // Jwenn detay yon plant
  Future<Plant> fetchPlantDetails(String plantId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.plants}/$plantId'),
      );

      if (response.statusCode == 200) {
        return Plant.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load plant details');
      }
    } catch (e) {
      throw Exception('Error fetching plant details: $e');
    }
  }

  // Jwenn kategori yo
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.categories));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Chèche plant
  Future<List<Plant>> searchPlants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.plants}?search=$query'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Plant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search plants');
      }
    } catch (e) {
      throw Exception('Error searching plants: $e');
    }
  }

  // Jwenn plant yon pepinyè
  Future<List<Plant>> fetchNurseryPlants(String nurseryId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.nurseryPlants(nurseryId)),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Plant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nursery plants');
      }
    } catch (e) {
      throw Exception('Error fetching nursery plants: $e');
    }
  }
}
