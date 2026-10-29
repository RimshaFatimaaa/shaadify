class WeddingItem {
  final String id;
  final String name;
  final String category;
  final String icon;
  final double minPrice;
  final double maxPrice;
  final String description;
  final List<String> tags;
  final String? imageUrl;

  WeddingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.minPrice,
    required this.maxPrice,
    required this.description,
    this.tags = const [],
    this.imageUrl,
  });

  double get averagePrice => (minPrice + maxPrice) / 2;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'icon': icon,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'description': description,
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }

  factory WeddingItem.fromJson(Map<String, dynamic> json) {
    return WeddingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      minPrice: (json['minPrice'] as num).toDouble(),
      maxPrice: (json['maxPrice'] as num).toDouble(),
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

