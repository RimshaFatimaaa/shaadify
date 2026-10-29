enum SubscriptionType {
  free,
  pro,
  vendor, // Vendor subscription for business registration
}

enum SubscriptionPeriod {
  monthly,
  yearly,
}

class SubscriptionPlan {
  final String id;
  final SubscriptionType type;
  final SubscriptionPeriod period;
  final double price;
  final String currency;
  final String name;
  final String description;
  final List<String> features;

  const SubscriptionPlan({
    required this.id,
    required this.type,
    required this.period,
    required this.price,
    this.currency = 'PKR',
    required this.name,
    required this.description,
    required this.features,
  });

  String get formattedPrice {
    if (price >= 1000) {
      return 'Rs. ${(price / 1000).toStringAsFixed(1)}K';
    }
    return 'Rs. ${price.toStringAsFixed(0)}';
  }

  String get periodLabel {
    switch (period) {
      case SubscriptionPeriod.monthly:
        return 'per month';
      case SubscriptionPeriod.yearly:
        return 'per year';
    }
  }
}

class UserSubscription {
  final String id;
  final SubscriptionType type;
  final SubscriptionPeriod period;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final double pricePaid;

  UserSubscription({
    required this.id,
    required this.type,
    required this.period,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.pricePaid,
  });

  bool get isPro => type == SubscriptionType.pro && isActive;
  bool get isVendor => type == SubscriptionType.vendor && isActive;

  bool get isExpired {
    if (!isActive) return true;
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'period': period.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'pricePaid': pricePaid,
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubscriptionType.free,
      ),
      period: SubscriptionPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => SubscriptionPeriod.monthly,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isActive: json['isActive'] as bool,
      pricePaid: (json['pricePaid'] as num).toDouble(),
    );
  }
}
