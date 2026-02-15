import 'package:plantyard/models/plant_model.dart';

class CartItem {
  final Plant plant;
  int quantity;

  CartItem({
    required this.plant,
    this.quantity = 1,
  });

  double get totalPrice => plant.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      plant: Plant.fromJson(json['plant']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant': plant.toJson(),
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    Plant? plant,
    int? quantity,
  }) {
    return CartItem(
      plant: plant ?? this.plant,
      quantity: quantity ?? this.quantity,
    );
  }
}
