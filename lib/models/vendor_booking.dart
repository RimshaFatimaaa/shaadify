import 'vendor.dart';

class VendorBooking {
  final String id;
  final Vendor vendor;
  final String planName; // 'Premium' or 'Medium'
  final double price;
  final DateTime bookedAt;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final String? eventType; // Event type (e.g., 'Mehndi', 'Barat', 'Walima')

  VendorBooking({
    required this.id,
    required this.vendor,
    required this.planName,
    required this.price,
    required this.bookedAt,
    this.status = 'pending',
    this.eventType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor': vendor.toJson(),
      'planName': planName,
      'price': price,
      'bookedAt': bookedAt.toIso8601String(),
      'status': status,
      'eventType': eventType,
    };
  }

  factory VendorBooking.fromJson(Map<String, dynamic> json) {
    return VendorBooking(
      id: json['id'] as String,
      vendor: Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
      planName: json['planName'] as String,
      price: (json['price'] as num).toDouble(),
      bookedAt: DateTime.parse(json['bookedAt'] as String),
      status: json['status'] as String? ?? 'pending',
      eventType: json['eventType'] as String?,
    );
  }
}

