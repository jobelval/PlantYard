import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/models/cart_item.dart';

// ===================== MODÈL KOMAND =====================
class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String status;
  final String? deliveryAddress;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = 'An trete',
    this.deliveryAddress,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((i) => i.toJson()).toList(),
        'total': total,
        'date': date.toIso8601String(),
        'status': status,
        'deliveryAddress': deliveryAddress,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] ?? '',
        items: (json['items'] as List<dynamic>? ?? [])
            .map((i) => CartItem.fromJson(i))
            .toList(),
        total: (json['total'] ?? 0).toDouble(),
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        status: json['status'] ?? 'An trete',
        deliveryAddress: json['deliveryAddress'],
      );
}

// ===================== MODÈL ADRÈS =====================
class DeliveryAddress {
  final String id;
  final String label; // ex: "Kay", "Travay"
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String country;
  final bool isDefault;

  DeliveryAddress({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    this.country = 'Ayiti',
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'fullName': fullName,
        'phone': phone,
        'street': street,
        'city': city,
        'country': country,
        'isDefault': isDefault,
      };

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json['id'] ?? '',
        label: json['label'] ?? '',
        fullName: json['fullName'] ?? '',
        phone: json['phone'] ?? '',
        street: json['street'] ?? '',
        city: json['city'] ?? '',
        country: json['country'] ?? 'Ayiti',
        isDefault: json['isDefault'] ?? false,
      );

  DeliveryAddress copyWith({
    String? id,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? country,
    bool? isDefault,
  }) =>
      DeliveryAddress(
        id: id ?? this.id,
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        street: street ?? this.street,
        city: city ?? this.city,
        country: country ?? this.country,
        isDefault: isDefault ?? this.isDefault,
      );
}

// ===================== MODÈL NOTIFIKASYON =====================
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  bool isRead;
  final String type; // 'order', 'promo', 'stock', 'info'

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
    this.type = 'info',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'date': date.toIso8601String(),
        'isRead': isRead,
        'type': type,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        isRead: json['isRead'] ?? false,
        type: json['type'] ?? 'info',
      );
}

// ===================== SÈVIS DONE ITILIZATÈ =====================
class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  List<String> _favoriteIds = [];
  List<Order> _orders = [];
  List<DeliveryAddress> _addresses = [];
  List<AppNotification> _notifications = [];
  final List<Function> _listeners = [];

  // --- Getters ---
  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);
  List<Order> get orders => List.unmodifiable(_orders);
  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);
  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);
  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  void addListener(Function listener) => _listeners.add(listener);
  void removeListener(Function listener) => _listeners.remove(listener);
  void _notify() {
    for (var l in _listeners) {
      l();
    }
  }

  // --- Chajman initial ---
  Future<void> init() async {
    await _loadAll();
    if (_notifications.isEmpty) {
      _addDefaultNotifications();
      await _saveNotifications();
    }
  }

  void _addDefaultNotifications() {
    _notifications = [
      AppNotification(
        id: 'n1',
        title: 'Byenveni sou PlantYard! 🌱',
        message:
            'Nou kontan wè ou. Dekouvri koleksyon plant nou yo epi kòmanse jaden ou dèjodemen.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'info',
      ),
      AppNotification(
        id: 'n2',
        title: 'Promo: -20% sou Kaktis! 🌵',
        message:
            'Pwofite jiska fen semèn nan pou jwenn 20% rabè sou tout koleksyon kaktis nou yo.',
        date: DateTime.now().subtract(const Duration(hours: 3)),
        type: 'promo',
      ),
      AppNotification(
        id: 'n3',
        title: 'Stòk limite: Orchide',
        message:
            'Orchide Phalaenopsis yo prèske fini. Il reste sèlman 12 plantas. Kòmande vit!',
        date: DateTime.now().subtract(const Duration(minutes: 45)),
        type: 'stock',
      ),
    ];
  }

  // ===================== FAVORI =====================
  bool isFavorite(String plantId) => _favoriteIds.contains(plantId);

  Future<void> toggleFavorite(String plantId) async {
    if (_favoriteIds.contains(plantId)) {
      _favoriteIds.remove(plantId);
    } else {
      _favoriteIds.add(plantId);
    }
    await _saveFavorites();
    _notify();
  }

  // ===================== KOMAND =====================
  Future<void> addOrder({
    required List<CartItem> items,
    required double total,
    String? deliveryAddress,
  }) async {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      total: total,
      date: DateTime.now(),
      deliveryAddress: deliveryAddress,
    );
    _orders.insert(0, order); // plis resan an premye
    await _saveOrders();

    // Ajoute notifikasyon otomatikman
    final notif = AppNotification(
      id: 'n-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Komand ${order.id} konfime ✅',
      message:
          'Komand ou an pou \$${total.toStringAsFixed(2)} te pran an konsiderasyon. Nou ap livwe ou anvan 3-5 jou.',
      date: DateTime.now(),
      type: 'order',
    );
    _notifications.insert(0, notif);
    await _saveNotifications();
    _notify();
  }

  // ===================== ADRÈS =====================
  Future<void> addAddress(DeliveryAddress address) async {
    List<DeliveryAddress> updated = List.from(_addresses);
    if (address.isDefault) {
      updated = updated.map((a) => a.copyWith(isDefault: false)).toList();
    }
    updated.add(address);
    _addresses = updated;
    await _saveAddresses();
    _notify();
  }

  Future<void> deleteAddress(String id) async {
    _addresses.removeWhere((a) => a.id == id);
    await _saveAddresses();
    _notify();
  }

  Future<void> setDefaultAddress(String id) async {
    _addresses = _addresses.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
    await _saveAddresses();
    _notify();
  }

  // ===================== NOTIFIKASYON =====================
  Future<void> markNotificationRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx].isRead = true;
      await _saveNotifications();
      _notify();
    }
  }

  Future<void> markAllRead() async {
    for (var n in _notifications) {
      n.isRead = true;
    }
    await _saveNotifications();
    _notify();
  }

  // ===================== PERSISTANS =====================
  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    // Favori
    final favJson = prefs.getString('favorites');
    if (favJson != null) {
      _favoriteIds = List<String>.from(json.decode(favJson));
    }

    // Komand
    final ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      _orders = (json.decode(ordersJson) as List)
          .map((o) => Order.fromJson(o))
          .toList();
    }

    // Adrès
    final addrJson = prefs.getString('addresses');
    if (addrJson != null) {
      _addresses = (json.decode(addrJson) as List)
          .map((a) => DeliveryAddress.fromJson(a))
          .toList();
    }

    // Notifikasyon
    final notifJson = prefs.getString('notifications');
    if (notifJson != null) {
      _notifications = (json.decode(notifJson) as List)
          .map((n) => AppNotification.fromJson(n))
          .toList();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', json.encode(_favoriteIds));
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orders', json.encode(_orders.map((o) => o.toJson()).toList()));
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('addresses', json.encode(_addresses.map((a) => a.toJson()).toList()));
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(_notifications.map((n) => n.toJson()).toList()));
  }
}