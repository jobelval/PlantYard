import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/cart_item.dart';
import 'package:plantyard/services/user_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<CartItem> _cartItems = [];
  final List<Function> _listeners = [];

  List<CartItem> get items => List.unmodifiable(_cartItems);

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void addListener(Function listener) {
    _listeners.add(listener);
  }

  void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  /// Ajoute yon plant nan panyen
  Future<void> addToCart(Plant plant, {int quantity = 1}) async {
    final existingIndex =
        _cartItems.indexWhere((item) => item.plant.id == plant.id);

    if (existingIndex >= 0) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(plant: plant, quantity: quantity));
    }

    await _saveCart();
    _notifyListeners();
  }

  /// Retire yon plant nan panyen
  Future<void> removeFromCart(String plantId) async {
    _cartItems.removeWhere((item) => item.plant.id == plantId);
    await _saveCart();
    _notifyListeners();
  }

  /// Chanje kantite yon atik
  Future<void> updateQuantity(String plantId, int newQuantity) async {
    final index = _cartItems.indexWhere((item) => item.plant.id == plantId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        await removeFromCart(plantId);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
        await _saveCart();
        _notifyListeners();
      }
    }
  }

  /// Vide panyen an
  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
    _notifyListeners();
  }

  /// Konfime komand epi anrejistre li nan istwa yo
  Future<void> checkout({String? deliveryAddress}) async {
    if (_cartItems.isEmpty) return;

    // Sove komand nan istwa itilizatè a
    await UserDataService().addOrder(
      items: List.from(_cartItems),
      total: totalPrice,
      deliveryAddress: deliveryAddress,
    );

    // Vide panyen an apre konfirmasyon
    await clearCart();
  }

  /// Tcheke si yon plant nan panyen an
  bool isInCart(String plantId) {
    return _cartItems.any((item) => item.plant.id == plantId);
  }

  /// Chaje panyen an depi shared_preferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartString = prefs.getString('cart');

      if (cartString != null) {
        final List<dynamic> cartJson = json.decode(cartString);
        _cartItems = cartJson.map((json) => CartItem.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading cart: $e');
      _cartItems = [];
    }
    _notifyListeners();
  }

  /// Sove panyen an nan shared_preferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _cartItems.map((item) => item.toJson()).toList();
      await prefs.setString('cart', json.encode(cartJson));
    } catch (e) {
      print('Error saving cart: $e');
    }
  }
}