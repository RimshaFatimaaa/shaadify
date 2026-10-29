import 'vendor_review.dart';

class Vendor {
  final String id;
  final String name;
  final String category;
  final String city;
  final double rating;
  final int reviewCount;
  final String phone;
  final String email;
  final String? website;
  final List<String> images;
  final List<VendorPackage> packages;
  final String description;
  final bool isVerified;
  final double? latitude;
  final double? longitude;
  final List<VendorReview> reviews;

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    required this.email,
    this.website,
    this.images = const [],
    this.packages = const [],
    this.description = '',
    this.isVerified = false,
    this.latitude,
    this.longitude,
    this.reviews = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'city': city,
      'rating': rating,
      'reviewCount': reviewCount,
      'phone': phone,
      'email': email,
      'website': website,
      'images': images,
      'packages': packages.map((p) => p.toJson()).toList(),
      'description': description,
      'isVerified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'reviews': reviews.map((r) => r.toJson()).toList(),
    };
  }

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      phone: json['phone'] as String,
      email: json['email'] as String,
      website: json['website'] as String?,
      images: List<String>.from(json['images'] ?? []),
      packages: (json['packages'] as List<dynamic>?)
              ?.map((p) => VendorPackage.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((r) => VendorReview.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class VendorPackage {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> features;
  final List<String> images;

  VendorPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.features = const [],
    this.images = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'features': features,
      'images': images,
    };
  }

  factory VendorPackage.fromJson(Map<String, dynamic> json) {
    return VendorPackage(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

