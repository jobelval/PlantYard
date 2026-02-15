import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/user_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  // Inisyalize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Gestion user session
  Future<void> saveUserSession(User user) async {
    await _prefs.setString('user', json.encode(user.toJson()));
    await _prefs.setBool('isLoggedIn', true);
  }

  User? getUserSession() {
    String? userJson = _prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> clearUserSession() async {
    await _prefs.remove('user');
    await _prefs.setBool('isLoggedIn', false);
  }

  bool isLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  // Gestion panyen (cart)
  Future<void> saveCart(List<Plant> cartItems) async {
    List<Map<String, dynamic>> cartJson = cartItems
        .map((item) => item.toJson())
        .toList();
    await _prefs.setString('cart', json.encode(cartJson));
  }

  List<Plant> getCart() {
    String? cartJson = _prefs.getString('cart');
    if (cartJson != null) {
      List<dynamic> decoded = json.decode(cartJson);
      return decoded.map((item) => Plant.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> clearCart() async {
    await _prefs.remove('cart');
  }

  // Gestion favoris
  Future<void> saveFavorites(List<String> favoriteIds) async {
    await _prefs.setStringList('favorites', favoriteIds);
  }

  List<String> getFavorites() {
    return _prefs.getStringList('favorites') ?? [];
  }

  // Gestion preference user (tema, notifikasyon)
  Future<void> setThemeMode(bool isDarkMode) async {
    await _prefs.setBool('darkMode', isDarkMode);
  }

  bool getThemeMode() {
    return _prefs.getBool('darkMode') ?? false;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications', enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool('notifications') ?? true;
  }

  // Gestion panyen ak kantite
  Future<void> addToCart(Plant plant) async {
    List<Plant> cart = getCart();
    cart.add(plant);
    await saveCart(cart);
  }

  Future<void> removeFromCart(String plantId) async {
    List<Plant> cart = getCart();
    cart.removeWhere((item) => item.id == plantId);
    await saveCart(cart);
  }

  Future<void> updateCartItem(Plant updatedPlant) async {
    List<Plant> cart = getCart();
    int index = cart.indexWhere((item) => item.id == updatedPlant.id);
    if (index != -1) {
      cart[index] = updatedPlant;
      await saveCart(cart);
    }
  }

  int getCartItemCount() {
    return getCart().length;
  }

  double getCartTotal() {
    return getCart().fold(0, (sum, item) => sum + item.price);
  }

  // Gestion favoris
  Future<void> toggleFavorite(String plantId) async {
    List<String> favorites = getFavorites();
    if (favorites.contains(plantId)) {
      favorites.remove(plantId);
    } else {
      favorites.add(plantId);
    }
    await saveFavorites(favorites);
  }

  bool isFavorite(String plantId) {
    return getFavorites().contains(plantId);
  }
}
