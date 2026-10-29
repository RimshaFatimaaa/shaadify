import 'wedding_item.dart';

enum EventType {
  mehndi,
  barat,
  walima,
  mayun,
  engagement,
  nikah,
  qawaliNight,
}

extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.mehndi:
        return 'Mehndi';
      case EventType.barat:
        return 'Barat';
      case EventType.walima:
        return 'Walima';
      case EventType.mayun:
        return 'Mayun';
      case EventType.engagement:
        return 'Engagement';
      case EventType.nikah:
        return 'Nikah';
      case EventType.qawaliNight:
        return 'Qawali Night';
    }
  }

  String get icon {
    switch (this) {
      case EventType.mehndi:
        return '🎨';
      case EventType.barat:
        return '💒';
      case EventType.walima:
        return '🍽️';
      case EventType.mayun:
        return '✨';
      case EventType.engagement:
        return '💍';
      case EventType.nikah:
        return '📿';
      case EventType.qawaliNight:
        return '🎵';
    }
  }
}

class WeddingEvent {
  final String id;
  final EventType type;
  final String name;
  final DateTime? date;
  final List<SelectedItem> selectedItems;
  final double budget;
  final String? theme;
  final String? colorPalette;
  final Map<String, dynamic>? timeline;

  WeddingEvent({
    required this.id,
    required this.type,
    required this.name,
    this.date,
    this.selectedItems = const [],
    this.budget = 0.0,
    this.theme,
    this.colorPalette,
    this.timeline,
  });

  double get totalCost {
    return selectedItems.fold(0.0, (sum, item) => sum + item.price);
  }

  double get remainingBudget => budget - totalCost;

  bool get isOverBudget => totalCost > budget;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'date': date?.toIso8601String(),
      'selectedItems': selectedItems.map((item) => item.toJson()).toList(),
      'budget': budget,
      'theme': theme,
      'colorPalette': colorPalette,
      'timeline': timeline,
    };
  }

  factory WeddingEvent.fromJson(Map<String, dynamic> json) {
    return WeddingEvent(
      id: json['id'] as String,
      type: EventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EventType.barat,
      ),
      name: json['name'] as String,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      selectedItems: (json['selectedItems'] as List<dynamic>?)
              ?.map((item) => SelectedItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      theme: json['theme'] as String?,
      colorPalette: json['colorPalette'] as String?,
      timeline: json['timeline'] as Map<String, dynamic>?,
    );
  }
}

class SelectedItem {
  final String id;
  final WeddingItem item;
  final double price;
  final DateTime addedAt;
  final String? vendorId;
  final String? vendorName;
  final double? vendorRating;
  final int? vendorReviewCount;
  final String? vendorCity;
  final bool? vendorIsVerified;
  final Map<String, dynamic>? customizations;

  SelectedItem({
    required this.id,
    required this.item,
    required this.price,
    required this.addedAt,
    this.vendorId,
    this.vendorName,
    this.vendorRating,
    this.vendorReviewCount,
    this.vendorCity,
    this.vendorIsVerified,
    this.customizations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item.toJson(),
      'price': price,
      'addedAt': addedAt.toIso8601String(),
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorRating': vendorRating,
      'vendorReviewCount': vendorReviewCount,
      'vendorCity': vendorCity,
      'vendorIsVerified': vendorIsVerified,
      'customizations': customizations,
    };
  }

  factory SelectedItem.fromJson(Map<String, dynamic> json) {
    return SelectedItem(
      id: json['id'] as String,
      item: WeddingItem.fromJson(json['item'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      addedAt: DateTime.parse(json['addedAt'] as String),
      vendorId: json['vendorId'] as String?,
      vendorName: json['vendorName'] as String?,
      vendorRating: json['vendorRating'] as double?,
      vendorReviewCount: json['vendorReviewCount'] as int?,
      vendorCity: json['vendorCity'] as String?,
      vendorIsVerified: json['vendorIsVerified'] as bool?,
      customizations: json['customizations'] as Map<String, dynamic>?,
    );
  }
}

