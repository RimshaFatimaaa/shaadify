import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/wedding_item.dart';
import '../models/wedding_event.dart';
import '../models/vendor.dart';
import '../models/vendor_review.dart';
import '../constants/app_constants.dart';

class WeddingService {
  static final WeddingService _instance = WeddingService._internal();
  factory WeddingService() => _instance;
  WeddingService._internal();

  final _uuid = const Uuid();
  
  // Cache vendors to ensure consistent IDs
  Map<String, List<Vendor>>? _vendorCache;
  
  Map<String, List<Vendor>> get vendorCache {
    _vendorCache ??= <String, List<Vendor>>{};
    return _vendorCache!;
  }

  // Mock data - In production, this would come from a database/API
  List<WeddingItem> getAvailableItems() {
    return [
      WeddingItem(
        id: _uuid.v4(),
        name: 'Banquet Hall',
        category: 'Venue',
        icon: '🏛️',
        minPrice: 200000,
        maxPrice: 1000000,
        description: 'Elegant banquet hall for your event',
        tags: ['indoor', 'air-conditioned', 'spacious'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Outdoor Garden',
        category: 'Venue',
        icon: '🌳',
        minPrice: 150000,
        maxPrice: 800000,
        description: 'Beautiful outdoor garden venue',
        tags: ['outdoor', 'natural', 'scenic'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Stage Décor - Royal',
        category: 'Décor',
        icon: '👑',
        minPrice: 100000,
        maxPrice: 500000,
        description: 'Luxurious royal stage decoration',
        tags: ['royal', 'luxury', 'elegant'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Stage Décor - Pastel',
        category: 'Décor',
        icon: '🌸',
        minPrice: 80000,
        maxPrice: 400000,
        description: 'Soft pastel stage decoration',
        tags: ['pastel', 'soft', 'romantic'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Buffet Catering',
        category: 'Catering',
        icon: '🍽️',
        minPrice: 50000,
        maxPrice: 300000,
        description: 'Full buffet service for guests',
        tags: ['buffet', 'traditional', 'variety'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Bridal Makeup - Premium',
        category: 'Makeup',
        icon: '💄',
        minPrice: 50000,
        maxPrice: 200000,
        description: 'Professional bridal makeup artist',
        tags: ['premium', 'professional', 'bridal'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Photography & Videography',
        category: 'Photography',
        icon: '📸',
        minPrice: 80000,
        maxPrice: 500000,
        description: 'Complete photography and videography package',
        tags: ['photography', 'videography', 'complete'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Dhol & Music',
        category: 'Music',
        icon: '🥁',
        minPrice: 30000,
        maxPrice: 150000,
        description: 'Traditional dhol and music entertainment',
        tags: ['dhol', 'traditional', 'entertainment'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Nikah Setup',
        category: 'Nikah Setup',
        icon: '📿',
        minPrice: 20000,
        maxPrice: 100000,
        description: 'Beautiful Nikah ceremony setup',
        tags: ['nikah', 'ceremony', 'traditional'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Gifts & Favours',
        category: 'Gifts',
        icon: '🎁',
        minPrice: 10000,
        maxPrice: 100000,
        description: 'Customized gifts for guests',
        tags: ['gifts', 'favours', 'customized'],
      ),
      WeddingItem(
        id: _uuid.v4(),
        name: 'Car Entry Setup',
        category: 'Car Entry',
        icon: '🚗',
        minPrice: 15000,
        maxPrice: 80000,
        description: 'Decorated car entry with flowers',
        tags: ['car', 'entry', 'decorated'],
      ),
    ];
  }

  List<WeddingItem> getItemsByCategory(String category) {
    return getAvailableItems()
        .where((item) => item.category == category)
        .toList();
  }

  double calculatePrice(WeddingItem item, {String? vendorId}) {
    // If vendorId is provided, try to get vendor package price
    if (vendorId != null) {
      // Search for vendor in all categories
      for (final category in AppConstants.itemCategories) {
        final vendors = getVendorsByCategory(category);
        final vendor = vendors.firstWhere(
          (v) => v.id == vendorId,
          orElse: () => vendors.first,
        );
        if (vendor.id == vendorId && vendor.packages.isNotEmpty) {
          // Return the first package price (or average if multiple)
          final avgPrice = vendor.packages
              .map((p) => p.price)
              .reduce((a, b) => a + b) /
              vendor.packages.length;
          return avgPrice.clamp(item.minPrice, item.maxPrice);
        }
      }
    }
    
    // Fallback: return a random price between min and max
    final random = Random();
    return item.minPrice +
        (random.nextDouble() * (item.maxPrice - item.minPrice));
  }

  String? getVendorName(String? vendorId) {
    if (vendorId == null) return null;
    
    // Search for vendor in all categories
    for (final category in AppConstants.itemCategories) {
      final vendors = getVendorsByCategory(category);
      try {
        final vendor = vendors.firstWhere((v) => v.id == vendorId);
        return vendor.name;
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  Vendor? getVendorById(String? vendorId) {
    if (vendorId == null) return null;
    
    // Search for vendor in all categories
    for (final category in AppConstants.itemCategories) {
      final vendors = getVendorsByCategory(category);
      try {
        return vendors.firstWhere((v) => v.id == vendorId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  String _getCreativeVendorName(String category, String city, int index) {
    final categoryNames = {
      'Venue': ['Royal Palace', 'Grand Hall', 'Elegant Venue', 'Luxury Banquet', 'Crystal Ballroom', 'Garden Paradise', 'Regal Hall', 'Starlight Venue', 'Emerald Palace', 'Diamond Hall', 'Golden Ballroom', 'Pearl Banquet', 'Majestic Venue', 'Opulent Hall', 'Prestige Palace', 'Elite Ballroom'],
      'Décor': ['Royal Décor', 'Elegant Designs', 'Luxury Styling', 'Crystal Creations', 'Golden Touch', 'Pearl Décor', 'Emerald Designs', 'Diamond Styling', 'Starlight Décor', 'Regal Creations', 'Grand Designs', 'Elite Styling', 'Majestic Décor', 'Opulent Designs', 'Prestige Styling', 'Luxury Creations'],
      'Catering': ['Royal Cuisine', 'Grand Feast', 'Elegant Caterers', 'Luxury Food', 'Crystal Kitchen', 'Golden Platter', 'Pearl Catering', 'Emerald Cuisine', 'Diamond Feast', 'Starlight Food', 'Regal Kitchen', 'Elite Caterers', 'Majestic Cuisine', 'Opulent Feast', 'Prestige Caterers', 'Luxury Kitchen'],
      'Makeup': ['Glamour Studio', 'Beauty Palace', 'Elegant Makeup', 'Luxury Beauty', 'Crystal Glow', 'Golden Touch', 'Pearl Beauty', 'Emerald Studio', 'Diamond Glow', 'Starlight Makeup', 'Regal Beauty', 'Elite Studio', 'Majestic Glow', 'Opulent Beauty', 'Prestige Studio', 'Luxury Glow'],
      'Photography': ['Royal Shots', 'Grand Studios', 'Elegant Capture', 'Luxury Lens', 'Crystal Vision', 'Golden Frame', 'Pearl Studios', 'Emerald Capture', 'Diamond Vision', 'Starlight Shots', 'Regal Lens', 'Elite Studios', 'Majestic Shots', 'Opulent Studios', 'Prestige Capture', 'Luxury Vision'],
      'Music': ['Royal Melodies', 'Grand Sounds', 'Elegant Beats', 'Luxury Music', 'Crystal Tunes', 'Golden Rhythm', 'Pearl Sounds', 'Emerald Melodies', 'Diamond Beats', 'Starlight Music', 'Regal Tunes', 'Elite Sounds', 'Majestic Melodies', 'Opulent Sounds', 'Prestige Beats', 'Luxury Tunes'],
      'Nikah Setup': ['Royal Nikah', 'Grand Setup', 'Elegant Ceremony', 'Luxury Nikah', 'Crystal Setup', 'Golden Ceremony', 'Pearl Nikah', 'Emerald Setup', 'Diamond Ceremony', 'Starlight Nikah', 'Regal Setup', 'Elite Ceremony', 'Majestic Nikah', 'Opulent Setup', 'Prestige Ceremony', 'Luxury Setup'],
      'Gifts': ['Royal Gifts', 'Grand Presents', 'Elegant Souvenirs', 'Luxury Gifts', 'Crystal Presents', 'Golden Souvenirs', 'Pearl Gifts', 'Emerald Presents', 'Diamond Souvenirs', 'Starlight Gifts', 'Regal Presents', 'Elite Souvenirs', 'Majestic Gifts', 'Opulent Presents', 'Prestige Souvenirs', 'Luxury Presents'],
      'Car Entry': ['Royal Entry', 'Grand Decorations', 'Elegant Setup', 'Luxury Entry', 'Crystal Decorations', 'Golden Setup', 'Pearl Entry', 'Emerald Decorations', 'Diamond Setup', 'Starlight Entry', 'Regal Decorations', 'Elite Setup', 'Majestic Entry', 'Opulent Decorations', 'Prestige Setup', 'Luxury Decorations'],
      'Other': ['Royal Services', 'Grand Solutions', 'Elegant Services', 'Luxury Solutions', 'Crystal Services', 'Golden Solutions', 'Pearl Services', 'Emerald Solutions', 'Diamond Services', 'Starlight Solutions', 'Regal Services', 'Elite Solutions', 'Majestic Services', 'Opulent Solutions', 'Prestige Services', 'Luxury Solutions'],
    };
    
    final names = categoryNames[category] ?? ['Professional Services'];
    // Use a combination that ensures uniqueness: city index + global index
    final cityIndex = AppConstants.pakistaniCities.indexOf(city);
    final uniqueIndex = (cityIndex * 100 + index) % names.length;
    final baseName = names[uniqueIndex];
    
    // Add city-specific suffix
    final citySuffixes = {
      'Karachi': 'KHI',
      'Lahore': 'LHR',
      'Islamabad': 'ISB',
      'Rawalpindi': 'RWP',
      'Faisalabad': 'FSD',
      'Multan': 'MUL',
      'Peshawar': 'PSH',
      'Quetta': 'QTA',
      'Sialkot': 'SKT',
      'Gujranwala': 'GRW',
      'Hyderabad': 'HYD',
      'Sargodha': 'SRG',
    };
    
    return '$baseName ${citySuffixes[city] ?? city}';
  }

  List<VendorReview> _generateReviews(String vendorId, int count) {
    final reviews = <VendorReview>[];
    final random = Random();
    final userNames = [
      'Ahmed Khan', 'Fatima Ali', 'Hassan Malik', 'Ayesha Sheikh', 'Usman Raza',
      'Sana Ahmed', 'Bilal Hassan', 'Zainab Khan', 'Omar Ali', 'Maryam Sheikh',
      'Tariq Malik', 'Hina Raza', 'Faisal Khan', 'Nida Ali', 'Kamran Sheikh',
      'Sara Ahmed', 'Waseem Malik', 'Rabia Khan', 'Adnan Ali', 'Amina Sheikh'
    ];
    final comments = [
      'Excellent service! Highly recommended.',
      'Very professional and on time. Great quality!',
      'Amazing experience, exceeded expectations.',
      'Good service, would book again.',
      'Professional team, beautiful work!',
      'Satisfied with the service quality.',
      'Outstanding service, very happy!',
      'Great value for money, highly recommended.',
      'Very responsive and professional.',
      'Excellent quality and timely delivery.',
      'Perfect service for our event!',
      'Very satisfied, great experience.',
      'Professional and reliable service.',
      'Amazing work, exceeded our expectations!',
      'Great team, highly professional.',
      'Excellent quality, would definitely recommend.',
      'Very happy with the service!',
      'Outstanding work, very satisfied.',
      'Professional and timely service.',
      'Great experience, highly recommended!'
    ];
    
    // Generate 5-9 reviews
    final reviewCount = 5 + random.nextInt(5); // Random between 5-9
    
    for (int i = 0; i < reviewCount; i++) {
      final rating = 3.5 + (random.nextDouble() * 1.5); // Rating between 3.5-5.0
      final userName = userNames[random.nextInt(userNames.length)];
      final comment = comments[random.nextInt(comments.length)];
      final daysAgo = random.nextInt(180); // Reviews from last 6 months
      
      reviews.add(
        VendorReview(
          id: _uuid.v4(),
          vendorId: vendorId,
          userName: userName,
          rating: double.parse(rating.toStringAsFixed(1)),
          comment: comment,
          date: DateTime.now().subtract(Duration(days: daysAgo)),
        ),
      );
    }
    
    // Sort by date (newest first)
    reviews.sort((a, b) => b.date.compareTo(a.date));
    
    return reviews;
  }

  List<Vendor> getVendorsByCategory(String category) {
    try {
      // Return cached vendors if available to ensure consistent IDs
      final cache = vendorCache;
      if (cache.isNotEmpty && cache.containsKey(category)) {
        final cached = cache[category];
        if (cached != null && cached.isNotEmpty) {
          return List<Vendor>.from(cached);
        }
      }
    } catch (e) {
      // If cache access fails, continue to generate vendors
      debugPrint('Error accessing vendor cache: $e');
    }
    
    // Mock vendors - In production, fetch from API
    final vendors = <Vendor>[];
    final cities = AppConstants.pakistaniCities;
    
    // Generate vendors for ALL cities
    for (int i = 0; i < cities.length; i++) {
      final city = cities[i];
      final rating = 4.3 + ((i % 5) * 0.1); // Vary ratings from 4.3 to 4.7
      final reviewCount = 100 + ((i % 5) * 30); // Vary review counts
      final price = 50000 + ((i % 5) * 50000); // Vary prices
      final vendorId = _uuid.v4();
      final reviews = _generateReviews(vendorId, 5 + (i % 5)); // 5-9 reviews
      
      vendors.add(
        Vendor(
          id: vendorId,
          name: _getCreativeVendorName(category, city, i),
          category: category,
          city: city,
          rating: rating,
          reviewCount: reviewCount,
          phone: '+92-300-${1000000 + (i * 1000)}',
          email: '${category.toLowerCase().replaceAll(' ', '').replaceAll('é', 'e')}${city.toLowerCase()}${i + 1}@example.com',
          packages: [
            VendorPackage(
              id: _uuid.v4(),
              name: 'Basic Package',
              description: 'Basic $category services in $city',
              price: price.toDouble(),
              features: ['Feature 1', 'Feature 2'],
            ),
            VendorPackage(
              id: _uuid.v4(),
              name: 'Premium Package',
              description: 'Premium $category services in $city',
              price: (price * 2.5).toDouble(),
              features: ['Feature 1', 'Feature 2', 'Feature 3'],
            ),
          ],
          description: 'Professional $category services in $city',
          isVerified: i % 2 == 0, // Alternate verified status
          reviews: reviews,
        ),
      );
    }
    
    // Add special named vendors for specific categories
    if (category == 'Makeup') {
      final zaraId = _uuid.v4();
      final zaraReviews = _generateReviews(zaraId, 7);
      vendors.add(
        Vendor(
          id: zaraId,
          name: "Zara's Salon",
          category: category,
          city: 'Lahore',
          rating: 4.9,
          reviewCount: 245,
          phone: '+92-300-9876543',
          email: 'zara@salon.com',
          packages: [
            VendorPackage(
              id: _uuid.v4(),
              name: 'Bridal Package',
              description: 'Complete bridal makeup and hair',
              price: 150000,
              features: ['Bridal makeup', 'Hair styling', 'Trial session'],
            ),
          ],
          description: 'Premium bridal makeup and salon services',
          isVerified: true,
          reviews: zaraReviews,
        ),
      );
    } else if (category == 'Photography') {
      final photoId = '${category}_Lahore_Studios';
      final photoReviews = _generateReviews(photoId, 8);
      vendors.add(
        Vendor(
          id: photoId,
          name: 'Lahore Wedding Studios',
          category: category,
          city: 'Lahore',
          rating: 4.8,
          reviewCount: 189,
          phone: '+92-300-9876544',
          email: 'info@lahorestudios.com',
          packages: [
            VendorPackage(
              id: _uuid.v4(),
              name: 'Premium Package',
              description: 'Full day photography and videography',
              price: 200000,
              features: ['Photography', 'Videography', 'Drone shots'],
            ),
          ],
          description: 'Professional wedding photography services',
          isVerified: true,
          reviews: photoReviews,
        ),
      );
    } else if (category == 'Décor') {
      final decorId = '${category}_Lahore_Royal';
      final decorReviews = _generateReviews(decorId, 6);
      vendors.add(
        Vendor(
          id: decorId,
          name: 'Royal Décor Lahore',
          category: category,
          city: 'Lahore',
          rating: 4.7,
          reviewCount: 156,
          phone: '+92-300-9876545',
          email: 'info@royaldecor.com',
          packages: [
            VendorPackage(
              id: _uuid.v4(),
              name: 'Royal Stage Setup',
              description: 'Complete stage decoration',
              price: 300000,
              features: ['Stage setup', 'Lighting', 'Floral arrangements'],
            ),
          ],
          description: 'Luxurious wedding decoration services',
          isVerified: true,
          reviews: decorReviews,
        ),
      );
    }
    
    // Cache the vendors for this category
    try {
      vendorCache[category] = List<Vendor>.from(vendors);
    } catch (e) {
      debugPrint('Error caching vendors: $e');
    }
    
    return vendors;
  }
  
  List<Vendor> getTopRatedVendorsInCity(String city) {
    // Get top rated vendors in a specific city
    final allVendors = <Vendor>[];
    for (final category in AppConstants.itemCategories) {
      allVendors.addAll(getVendorsByCategory(category));
    }
    
    final cityVendors = allVendors.where((v) => v.city == city).toList();
    cityVendors.sort((a, b) => b.rating.compareTo(a.rating));
    return cityVendors.take(5).toList();
  }
  
  List<Vendor> getAllVendors({int minCount = 5, int maxCount = 7}) {
    // Get all vendors from all categories and cities
    final allVendors = <Vendor>[];
    for (final category in AppConstants.itemCategories) {
      allVendors.addAll(getVendorsByCategory(category));
    }
    
    // Shuffle to get variety across categories and cities
    allVendors.shuffle();
    
    // Return between min and max vendors
    final count = (minCount + (allVendors.length % (maxCount - minCount + 1))).clamp(minCount, maxCount);
    return allVendors.take(count).toList();
  }

  Map<String, dynamic> generateTimeline(WeddingEvent event) {
    // Generate timeline based on event type and selected items
    final timeline = <String, String>{};

    if (event.type == EventType.barat) {
      timeline['8:00 AM'] = 'Bridal makeup starts';
      timeline['12:00 PM'] = 'Photography session begins';
      timeline['3:00 PM'] = 'Stage setup completion';
      timeline['4:00 PM'] = 'Catering setup';
      timeline['5:00 PM'] = 'Car entry decoration';
      timeline['6:00 PM'] = 'Barat arrival';
      timeline['7:00 PM'] = 'Nikah ceremony';
      timeline['8:00 PM'] = 'Dinner service';
    } else if (event.type == EventType.mehndi) {
      timeline['2:00 PM'] = 'Venue setup';
      timeline['4:00 PM'] = 'Mehndi application starts';
      timeline['6:00 PM'] = 'Dhol and music begins';
      timeline['7:00 PM'] = 'Dinner service';
    } else if (event.type == EventType.walima) {
      timeline['5:00 PM'] = 'Venue decoration';
      timeline['6:00 PM'] = 'Guests arrival';
      timeline['7:00 PM'] = 'Dinner service';
      timeline['9:00 PM'] = 'Entertainment program';
    } else if (event.type == EventType.nikah) {
      timeline['3:00 PM'] = 'Venue setup and decoration';
      timeline['4:00 PM'] = 'Guests arrival';
      timeline['5:00 PM'] = 'Nikah ceremony begins';
      timeline['6:00 PM'] = 'Dua and prayers';
      timeline['7:00 PM'] = 'Dinner service';
      timeline['8:00 PM'] = 'Photography session';
    } else if (event.type == EventType.qawaliNight) {
      timeline['6:00 PM'] = 'Venue setup and lighting';
      timeline['7:00 PM'] = 'Guests arrival';
      timeline['8:00 PM'] = 'Qawali performance begins';
      timeline['9:00 PM'] = 'Dinner service';
      timeline['10:00 PM'] = 'Musical entertainment continues';
      timeline['11:00 PM'] = 'Closing performance';
    }

    return timeline;
  }
}

