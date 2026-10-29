class WeddingTheme {
  final String id;
  final String name;
  final String description;
  final List<String> colors;
  final String? imageUrl;
  final Map<String, dynamic>? styleAttributes;

  WeddingTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    this.imageUrl,
    this.styleAttributes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colors': colors,
      'imageUrl': imageUrl,
      'styleAttributes': styleAttributes,
    };
  }

  factory WeddingTheme.fromJson(Map<String, dynamic> json) {
    return WeddingTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      colors: List<String>.from(json['colors'] ?? []),
      imageUrl: json['imageUrl'] as String?,
      styleAttributes: json['styleAttributes'] as Map<String, dynamic>?,
    );
  }
}

class Moodboard {
  final String id;
  final String eventId;
  final List<String> imageUrls;
  final String theme;
  final List<String> colorPalette;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  Moodboard({
    required this.id,
    required this.eventId,
    required this.imageUrls,
    required this.theme,
    required this.colorPalette,
    required this.createdAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'imageUrls': imageUrls,
      'theme': theme,
      'colorPalette': colorPalette,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Moodboard.fromJson(Map<String, dynamic> json) {
    return Moodboard(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      theme: json['theme'] as String,
      colorPalette: List<String>.from(json['colorPalette'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

