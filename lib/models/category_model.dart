class Category {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;
  final int plantCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.plantCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '🌱',
      imageUrl: json['imageUrl'] ?? '',
      plantCount: json['plantCount'] ?? 0,
    );
  }
}
