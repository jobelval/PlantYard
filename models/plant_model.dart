class Plant {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final bool inStock;
  final int stockQuantity;
  final String nurseryId;
  final String nurseryName;
  final Map<String, dynamic> careInstructions;
  final double rating;
  final int reviewsCount;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.inStock,
    required this.stockQuantity,
    required this.nurseryId,
    required this.nurseryName,
    required this.careInstructions,
    required this.rating,
    required this.reviewsCount,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scientificName: json['scientificName'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      inStock: json['inStock'] ?? false,
      stockQuantity: json['stockQuantity'] ?? 0,
      nurseryId: json['nurseryId'] ?? '',
      nurseryName: json['nurseryName'] ?? '',
      careInstructions: json['careInstructions'] ?? {},
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'inStock': inStock,
      'stockQuantity': stockQuantity,
      'nurseryId': nurseryId,
      'nurseryName': nurseryName,
      'careInstructions': careInstructions,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }

  // Metod pou jwenn pri ak remise
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  // Kopi plant ak modifikasyon
  Plant copyWith({
    String? id,
    String? name,
    String? scientificName,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    bool? inStock,
    int? stockQuantity,
    String? nurseryId,
    String? nurseryName,
    Map<String, dynamic>? careInstructions,
    double? rating,
    int? reviewsCount,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      inStock: inStock ?? this.inStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      nurseryId: nurseryId ?? this.nurseryId,
      nurseryName: nurseryName ?? this.nurseryName,
      careInstructions: careInstructions ?? this.careInstructions,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}
