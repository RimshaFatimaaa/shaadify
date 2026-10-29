import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/wedding_event.dart';
import '../models/wedding_item.dart';
import '../models/vendor.dart';
import '../models/vendor_booking.dart';
import '../models/vendor_report.dart';
import '../models/subscription_plan.dart';
import '../services/wedding_service.dart';

class WeddingProvider with ChangeNotifier {
  final WeddingService _weddingService = WeddingService();
  final _uuid = const Uuid();

  final List<WeddingEvent> _events = [];
  WeddingEvent? _currentEvent;
  List<WeddingItem> _availableItems = [];
  List<Vendor> _savedVendors = [];
  List<VendorBooking> _bookedVendors = [];
  List<VendorReport> _vendorReports = [];
  String _userName = '';
  String _userEmail = '';
  String _vendorBusinessName = '';
  String _vendorCategory = '';
  String _vendorOwnerName = '';
  String _vendorBusinessLocation = '';
  UserSubscription? _userSubscription;
  UserSubscription? _vendorSubscription;
  static const String _vendorBusinessNameKey = 'vendor_business_name';
  static const String _vendorCategoryKey = 'vendor_category';
  static const String _vendorOwnerNameKey = 'vendor_owner_name';
  static const String _vendorBusinessLocationKey = 'vendor_business_location';
  static const String _userSubscriptionKey = 'user_subscription';
  static const String _vendorSubscriptionKey = 'vendor_subscription';
  static const String _vendorReportsKey = 'vendor_reports';

  List<WeddingEvent> get events => _events;
  WeddingEvent? get currentEvent => _currentEvent;
  List<WeddingItem> get availableItems => _availableItems;
  List<Vendor> get savedVendors {
    try {
      if (_savedVendors.isEmpty) {
        return <Vendor>[];
      }
      return List<Vendor>.from(_savedVendors);
    } catch (e) {
      debugPrint('Error getting saved vendors: $e');
      return <Vendor>[];
    }
  }

  List<VendorBooking> get bookedVendors {
    try {
      return List<VendorBooking>.from(_bookedVendors);
    } catch (e) {
      debugPrint('Error getting booked vendors: $e');
      return <VendorBooking>[];
    }
  }

  List<VendorReport> get vendorReports {
    try {
      return List<VendorReport>.from(_vendorReports);
    } catch (e) {
      debugPrint('Error getting vendor reports: $e');
      return <VendorReport>[];
    }
  }

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get vendorBusinessName => _vendorBusinessName;
  String get vendorCategory => _vendorCategory;
  String get vendorOwnerName => _vendorOwnerName;
  String get vendorBusinessLocation => _vendorBusinessLocation;
  UserSubscription? get userSubscription => _userSubscription;
  UserSubscription? get vendorSubscription => _vendorSubscription;
  bool get isProUser => _userSubscription?.isPro ?? false;
  bool get isVendorSubscribed => _vendorSubscription?.isActive ?? false;

  void setUserInfo(String name, String email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  Future<void> setVendorInfo(String businessName, String category) async {
    _vendorBusinessName = businessName;
    _vendorCategory = category;
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vendorBusinessNameKey, businessName);
    await prefs.setString(_vendorCategoryKey, category);
    notifyListeners();
  }

  Future<void> setVendorOwnerAndLocation(String ownerName, String location) async {
    _vendorOwnerName = ownerName;
    _vendorBusinessLocation = location;
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vendorOwnerNameKey, ownerName);
    await prefs.setString(_vendorBusinessLocationKey, location);
    notifyListeners();
  }

  Future<void> _loadVendorInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _vendorBusinessName = prefs.getString(_vendorBusinessNameKey) ?? '';
      _vendorCategory = prefs.getString(_vendorCategoryKey) ?? '';
      _vendorOwnerName = prefs.getString(_vendorOwnerNameKey) ?? '';
      _vendorBusinessLocation = prefs.getString(_vendorBusinessLocationKey) ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading vendor info: $e');
    }
  }

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void updateUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  WeddingProvider() {
    _savedVendors = [];
    _bookedVendors = [];
    _vendorReports = [];
    _loadAvailableItems();
    _loadVendorInfo();
    _loadUserSubscription();
    loadVendorSubscription();
    _loadVendorReports();
    _initializeSampleBookedVendors();
    _ensureVenueInConfirmed();
  }

  void _initializeSampleBookedVendors() {
    // Only initialize if list is empty (to avoid duplicates on hot reload)
    if (_bookedVendors.isNotEmpty) return;

    // Sample data: Only create randomly selected vendors (no event types)
    // Event-based vendors should only be created when user selects vendors through events
    final categories = ['Venue', 'Décor', 'Catering', 'Makeup', 'Photography', 'Music'];
    final planNames = ['Premium', 'Medium', 'Basic'];
    final prices = [250000.0, 150000.0, 180000.0, 120000.0, 200000.0, 100000.0];
    // Mix of pending and confirmed statuses - Venue is confirmed
    final statuses = ['confirmed', 'pending', 'confirmed', 'pending', 'confirmed', 'pending'];
    
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final vendors = _weddingService.getVendorsByCategory(category);
      
      if (vendors.isNotEmpty) {
        final vendor = vendors[0]; // Get first vendor from each category
        final planName = planNames[i % planNames.length];
        final price = prices[i % prices.length];
        final status = statuses[i % statuses.length];
        
        // No eventType - these are randomly selected vendors
        final booking = VendorBooking(
          id: _uuid.v4(),
          vendor: vendor,
          planName: planName,
          price: price,
          bookedAt: DateTime.now().subtract(Duration(days: i + 1)),
          status: status, // Mix of pending and confirmed
          eventType: null, // No event type - randomly selected
        );
        
        _bookedVendors.add(booking);
      }
    }
    
    notifyListeners();
  }

  void _ensureVenueInConfirmed() {
    // Check if there's already a venue vendor with confirmed status
    final hasConfirmedVenue = _bookedVendors.any(
      (booking) => booking.vendor.category == 'Venue' && booking.status == 'confirmed',
    );
    
    // If no confirmed venue exists, add one
    if (!hasConfirmedVenue) {
      final venueVendors = _weddingService.getVendorsByCategory('Venue');
      if (venueVendors.isNotEmpty) {
        final venueVendor = venueVendors[0];
        final booking = VendorBooking(
          id: _uuid.v4(),
          vendor: venueVendor,
          planName: 'Premium',
          price: 250000.0,
          bookedAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'confirmed',
          eventType: null, // No event type - randomly selected
        );
        _bookedVendors.add(booking);
        notifyListeners();
      }
    }
  }

  void _loadAvailableItems() {
    _availableItems = _weddingService.getAvailableItems();
    notifyListeners();
  }

  void createEvent(EventType type, {String? name, double? budget}) {
    final event = WeddingEvent(
      id: _uuid.v4(),
      type: type,
      name: name ?? type.displayName,
      budget: budget ?? 0.0,
      selectedItems: [],
    );
    _events.add(event);
    _currentEvent = event;
    notifyListeners();
  }

  void setCurrentEvent(WeddingEvent event) {
    _currentEvent = event;
    notifyListeners();
  }

  void addItemToEvent(WeddingItem item, {String? vendorId}) {
    if (_currentEvent == null) return;

    final price = _weddingService.calculatePrice(item, vendorId: vendorId);
    final vendor = vendorId != null 
        ? _weddingService.getVendorById(vendorId)
        : null;
    
    final selectedItem = SelectedItem(
      id: _uuid.v4(),
      item: item,
      price: price,
      addedAt: DateTime.now(),
      vendorId: vendorId,
      vendorName: vendor?.name,
      vendorRating: vendor?.rating,
      vendorReviewCount: vendor?.reviewCount,
      vendorCity: vendor?.city,
      vendorIsVerified: vendor?.isVerified,
    );

    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index != -1) {
      _events[index] = WeddingEvent(
        id: _events[index].id,
        type: _events[index].type,
        name: _events[index].name,
        date: _events[index].date,
        selectedItems: [..._events[index].selectedItems, selectedItem],
        budget: _events[index].budget,
        theme: _events[index].theme,
        colorPalette: _events[index].colorPalette,
        timeline: _events[index].timeline,
      );
      _currentEvent = _events[index];
      notifyListeners();
    }
  }

  void addItemToEventWithVendor(WeddingItem item, Vendor vendor) {
    if (_currentEvent == null) return;

    final price = _weddingService.calculatePrice(item, vendorId: vendor.id);
    
    final selectedItem = SelectedItem(
      id: _uuid.v4(),
      item: item,
      price: price,
      addedAt: DateTime.now(),
      vendorId: vendor.id,
      vendorName: vendor.name,
      vendorRating: vendor.rating,
      vendorReviewCount: vendor.reviewCount,
      vendorCity: vendor.city,
      vendorIsVerified: vendor.isVerified,
    );

    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index != -1) {
      _events[index] = WeddingEvent(
        id: _events[index].id,
        type: _events[index].type,
        name: _events[index].name,
        date: _events[index].date,
        selectedItems: [..._events[index].selectedItems, selectedItem],
        budget: _events[index].budget,
        theme: _events[index].theme,
        colorPalette: _events[index].colorPalette,
        timeline: _events[index].timeline,
      );
      _currentEvent = _events[index];
      notifyListeners();
    }
  }

  void removeItemFromEvent(String selectedItemId) {
    if (_currentEvent == null) return;

    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index != -1) {
      _events[index] = WeddingEvent(
        id: _events[index].id,
        type: _events[index].type,
        name: _events[index].name,
        date: _events[index].date,
        selectedItems: _events[index].selectedItems
            .where((item) => item.id != selectedItemId)
            .toList(),
        budget: _events[index].budget,
        theme: _events[index].theme,
        colorPalette: _events[index].colorPalette,
        timeline: _events[index].timeline,
      );
      _currentEvent = _events[index];
      notifyListeners();
    }
  }

  void updateEventBudget(double budget) {
    if (_currentEvent == null) return;

    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index != -1) {
      _events[index] = WeddingEvent(
        id: _events[index].id,
        type: _events[index].type,
        name: _events[index].name,
        date: _events[index].date,
        selectedItems: _events[index].selectedItems,
        budget: budget,
        theme: _events[index].theme,
        colorPalette: _events[index].colorPalette,
        timeline: _events[index].timeline,
      );
      _currentEvent = _events[index];
      notifyListeners();
    }
  }

  void updateEventTheme(String theme, String? colorPalette) {
    if (_currentEvent == null) return;

    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index != -1) {
      _events[index] = WeddingEvent(
        id: _events[index].id,
        type: _events[index].type,
        name: _events[index].name,
        date: _events[index].date,
        selectedItems: _events[index].selectedItems,
        budget: _events[index].budget,
        theme: theme,
        colorPalette: colorPalette,
        timeline: _events[index].timeline,
      );
      _currentEvent = _events[index];
      notifyListeners();
    }
  }

  void generateTimeline() {
    if (_currentEvent == null) return;

    final timeline = _weddingService.generateTimeline(_currentEvent!);
    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index != -1) {
      _events[index] = WeddingEvent(
        id: _events[index].id,
        type: _events[index].type,
        name: _events[index].name,
        date: _events[index].date,
        selectedItems: _events[index].selectedItems,
        budget: _events[index].budget,
        theme: _events[index].theme,
        colorPalette: _events[index].colorPalette,
        timeline: timeline,
      );
      _currentEvent = _events[index];
      notifyListeners();
    }
  }

  List<WeddingItem> getItemsByCategory(String category) {
    return _weddingService.getItemsByCategory(category);
  }

  List<Vendor> getVendorsByCategory(String category, {String? city}) {
    final vendors = _weddingService.getVendorsByCategory(category);
    if (city != null) {
      return vendors.where((v) => v.city == city).toList();
    }
    return vendors;
  }

  bool isVendorSaved(String vendorId) {
    try {
      if (vendorId.isEmpty) {
        debugPrint('isVendorSaved: vendorId is empty');
        return false;
      }
      if (_savedVendors.isEmpty) {
        debugPrint('isVendorSaved: saved vendors list is empty');
        return false;
      }
      final found = _savedVendors.any((v) => v.id == vendorId);
      debugPrint('isVendorSaved: checking vendorId=$vendorId, found=$found');
      if (found) {
        debugPrint('Saved vendor IDs: ${_savedVendors.map((v) => v.id).toList()}');
      }
      return found;
    } catch (e) {
      debugPrint('Error in isVendorSaved: $e');
      return false;
    }
  }

  void saveVendor(Vendor vendor) {
    try {
      debugPrint('saveVendor called: ${vendor.name}, ID: ${vendor.id}');
      if (vendor.id.isEmpty) {
        debugPrint('ERROR: Cannot save vendor with empty ID');
        return;
      }
      if (isVendorSaved(vendor.id)) {
        debugPrint('Vendor already saved, skipping');
        return;
      }
      _savedVendors.add(vendor);
      debugPrint('Vendor saved: ${vendor.name}, ID: ${vendor.id}, Total saved: ${_savedVendors.length}');
      // Don't call notifyListeners here - let toggleVendorSave handle it
    } catch (e, stackTrace) {
      debugPrint('Error saving vendor: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void unsaveVendor(String vendorId) {
    try {
      debugPrint('unsaveVendor called: vendorId=$vendorId');
      final beforeCount = _savedVendors.length;
      _savedVendors.removeWhere((v) => v.id == vendorId);
      final afterCount = _savedVendors.length;
      debugPrint('Before unsave: $beforeCount, After unsave: $afterCount');
      // Don't call notifyListeners here - let toggleVendorSave handle it
    } catch (e, stackTrace) {
      debugPrint('Error unsaving vendor: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void toggleVendorSave(Vendor vendor) {
    try {
      debugPrint('toggleVendorSave called for vendor: ${vendor.name}, ID: ${vendor.id}');
      if (vendor.id.isEmpty) {
        debugPrint('ERROR: Vendor ID is empty!');
        return;
      }
      
      final currentlySaved = isVendorSaved(vendor.id);
      debugPrint('Vendor currently saved: $currentlySaved');
      debugPrint('Current saved vendors count: ${_savedVendors.length}');
      
      if (currentlySaved) {
        debugPrint('Unsaving vendor: ${vendor.id}');
        unsaveVendor(vendor.id);
        debugPrint('After unsave, saved vendors count: ${_savedVendors.length}');
      } else {
        debugPrint('Saving vendor: ${vendor.id}');
        saveVendor(vendor);
        debugPrint('After save, saved vendors count: ${_savedVendors.length}');
      }
      
      // Force notify listeners
      notifyListeners();
      debugPrint('notifyListeners() called');
    } catch (e, stackTrace) {
      debugPrint('Error toggling vendor save: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Map<String, dynamic> generateBudgetPlan({String priceLevel = 'balanced', String? city}) {
    if (_currentEvent == null || _currentEvent!.budget <= 0) {
      return {'success': false, 'message': 'No budget set'};
    }

    final budget = _currentEvent!.budget;
    
    // Clear existing items
    final index = _events.indexWhere((e) => e.id == _currentEvent!.id);
    if (index == -1) {
      return {'success': false, 'message': 'Event not found'};
    }

    // Category priority order (essential first)
    final categoryPriority = [
      'Venue',
      'Catering',
      'Décor',
      'Photography',
      'Makeup',
      'Music',
      'Nikah Setup',
      'Gifts',
      'Car Entry',
    ];

    // Budget allocation percentages for each category
    final budgetAllocation = {
      'Venue': 0.30,      // 30%
      'Catering': 0.25,   // 25%
      'Décor': 0.20,      // 20%
      'Photography': 0.10, // 10%
      'Makeup': 0.05,     // 5%
      'Music': 0.04,      // 4%
      'Nikah Setup': 0.03, // 3%
      'Gifts': 0.02,      // 2%
      'Car Entry': 0.01,  // 1%
    };

    final selectedItems = <SelectedItem>[];
    final planBreakdown = <String, Map<String, dynamic>>{};
    double remainingBudget = budget;
    double totalUsed = 0;

    String vendorLabel(String category) {
      // Creative vendor names based on category and price level
      final vendorNames = {
        'budget': {
          'Venue': 'Affordable Elegance Halls',
          'Catering': 'Tasteful Bites Catering',
          'Décor': 'Bloom & Shine Décor',
          'Photography': 'Capture Moments Studio',
          'Makeup': 'Glamour Touch Beauty',
          'Music': 'Rhythm & Melody Band',
          'Nikah Setup': 'Sacred Moments Setup',
          'Gifts': 'Thoughtful Treasures',
          'Car Entry': 'Grand Entrance Décor',
        },
        'premium': {
          'Venue': 'Royal Palace Venues',
          'Catering': 'Gourmet Delights Catering',
          'Décor': 'Luxury Dreams Décor',
          'Photography': 'Elite Vision Studios',
          'Makeup': 'Celebrity Glamour Artists',
          'Music': 'Symphony Orchestra',
          'Nikah Setup': 'Regal Ceremony Designs',
          'Gifts': 'Prestige Gift Collections',
          'Car Entry': 'Luxury Car Décor Co.',
        },
        'balanced': {
          'Venue': 'Elegant Occasions Hall',
          'Catering': 'Delicious Feasts Catering',
          'Décor': 'Enchanted Décor Studio',
          'Photography': 'Perfect Shots Photography',
          'Makeup': 'Bridal Beauty Studio',
          'Music': 'Harmony Entertainment',
          'Nikah Setup': 'Elegant Ceremony Setup',
          'Gifts': 'Elegant Gift Boutique',
          'Car Entry': 'Classic Car Décor',
        },
      };
      
      return vendorNames[priceLevel]?[category] ?? 
             '$category Services';
    }

    // Helper to pick target price based on preferred level
    double targetPrice(WeddingItem item) {
      switch (priceLevel) {
        case 'budget':
          return item.minPrice;
        case 'premium':
          return item.maxPrice;
        default:
          return (item.minPrice + item.maxPrice) / 2;
      }
    }

    // Select one item from each priority category that fits the budget
    for (final category in categoryPriority) {
      if (remainingBudget <= 0) break;

      final categoryBudget = budget * (budgetAllocation[category] ?? 0.0);
      final itemsInCategory = _weddingService.getItemsByCategory(category);
      
      if (itemsInCategory.isEmpty) continue;

      // Find the best item that fits within the category budget
      WeddingItem? bestItem;
      double bestTarget = 0;
      for (final item in itemsInCategory) {
        final target = targetPrice(item);
        if (target <= categoryBudget && target <= remainingBudget) {
          if (bestItem == null || target > bestTarget) {
            bestItem = item;
            bestTarget = target;
          }
        }
      }

      // If no item fits, try to find the cheapest one
      if (bestItem == null) {
        if (priceLevel == 'premium') {
          itemsInCategory.sort((a, b) => b.maxPrice.compareTo(a.maxPrice));
        } else {
          itemsInCategory.sort((a, b) => a.minPrice.compareTo(b.minPrice));
        }
        for (final item in itemsInCategory) {
          final target = targetPrice(item);
          if (target <= remainingBudget) {
            bestItem = item;
            bestTarget = target;
            break;
          }
        }
      }

      if (bestItem != null) {
        // Use the target price (clamped) to stay within the intended range
        final price = targetPrice(bestItem)
            .clamp(bestItem.minPrice, bestItem.maxPrice)
            .toDouble();
        if (price <= remainingBudget) {
          // Get a vendor for this category based on price level and city
          final allVendors = _weddingService.getVendorsByCategory(category);
          // Filter by city if specified
          final vendors = city != null
              ? allVendors.where((v) => v.city == city).toList()
              : allVendors;
          
          Vendor? selectedVendor;
          if (vendors.isNotEmpty) {
            // Select vendor based on price level
            if (priceLevel == 'premium') {
              vendors.sort((a, b) => b.rating.compareTo(a.rating));
            } else if (priceLevel == 'budget') {
              vendors.sort((a, b) => a.rating.compareTo(b.rating));
            }
            selectedVendor = vendors.first;
          } else if (allVendors.isNotEmpty) {
            // Fallback to any vendor if no vendors in selected city
            if (priceLevel == 'premium') {
              allVendors.sort((a, b) => b.rating.compareTo(a.rating));
            } else if (priceLevel == 'budget') {
              allVendors.sort((a, b) => a.rating.compareTo(b.rating));
            }
            selectedVendor = allVendors.first;
          }
          
          selectedItems.add(SelectedItem(
            id: _uuid.v4(),
            item: bestItem,
            price: price,
            addedAt: DateTime.now(),
            vendorId: selectedVendor?.id,
            vendorName: selectedVendor?.name ?? vendorLabel(category),
            vendorRating: selectedVendor?.rating,
            vendorReviewCount: selectedVendor?.reviewCount,
            vendorCity: selectedVendor?.city,
            vendorIsVerified: selectedVendor?.isVerified,
          ));
          
          // Create VendorBooking for selected vendor if vendor exists
          if (selectedVendor != null) {
            // Determine plan name based on price level
            String planName = 'Basic';
            if (priceLevel == 'premium') {
              planName = 'Premium';
            } else if (priceLevel == 'balanced') {
              planName = 'Medium';
            }
            
            // Get event type name
            final eventTypeName = _currentEvent?.type.displayName ?? _currentEvent?.name ?? 'Event';
            
            // Check if this vendor is already booked for this event type to avoid duplicates
            final isDuplicate = _bookedVendors.any(
              (b) => b.vendor.id == selectedVendor!.id && 
                     b.eventType == eventTypeName && 
                     b.status == 'pending' &&
                     b.vendor.category == category,
            );
            
            // Only add if it's a new booking (not a duplicate)
            if (!isDuplicate) {
              final booking = VendorBooking(
                id: _uuid.v4(),
                vendor: selectedVendor!,
                planName: planName,
                price: price,
                bookedAt: DateTime.now(),
                status: 'pending',
                eventType: eventTypeName,
              );
              _bookedVendors.add(booking);
            }
          }
          
          // Store breakdown info
          planBreakdown[category] = {
            'item': bestItem,
            'price': price,
            'allocatedBudget': categoryBudget,
            'percentage': (budgetAllocation[category] ?? 0.0) * 100,
            'priceRange': '${bestItem.minPrice} - ${bestItem.maxPrice}',
            'vendorName': selectedVendor?.name ?? vendorLabel(category),
            'vendorRating': selectedVendor?.rating,
            'vendorCity': selectedVendor?.city,
          };
          
          remainingBudget -= price;
          totalUsed += price;
        }
      }
    }

    // Update event with selected items
    _events[index] = WeddingEvent(
      id: _events[index].id,
      type: _events[index].type,
      name: _events[index].name,
      date: _events[index].date,
      selectedItems: selectedItems,
      budget: _events[index].budget,
      theme: _events[index].theme,
      colorPalette: _events[index].colorPalette,
      timeline: _events[index].timeline,
    );
    _currentEvent = _events[index];
    notifyListeners(); // Notify listeners after adding bookings

    return {
      'success': true,
      'budget': budget,
      'totalUsed': totalUsed,
      'remaining': remainingBudget,
      'breakdown': planBreakdown,
    };
  }

  void bookVendor(Vendor vendor, String planName, double price, {String? eventType}) {
    try {
      // Get event type from current event if not provided
      final eventTypeName = eventType ?? _currentEvent?.type.displayName ?? _currentEvent?.name;
      
      final booking = VendorBooking(
        id: _uuid.v4(),
        vendor: vendor,
        planName: planName,
        price: price,
        bookedAt: DateTime.now(),
        status: 'pending',
        eventType: eventTypeName,
      );
      _bookedVendors.add(booking);
      notifyListeners();
      debugPrint('Vendor booked: ${vendor.name}, Plan: $planName, Price: $price, Event: $eventTypeName');
    } catch (e) {
      debugPrint('Error booking vendor: $e');
    }
  }

  void cancelBooking(String bookingId) {
    try {
      final index = _bookedVendors.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookedVendors[index] = VendorBooking(
          id: _bookedVendors[index].id,
          vendor: _bookedVendors[index].vendor,
          planName: _bookedVendors[index].planName,
          price: _bookedVendors[index].price,
          bookedAt: _bookedVendors[index].bookedAt,
          status: 'cancelled',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
    }
  }

  // Subscription Management
  Future<void> _loadUserSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionJson = prefs.getString(_userSubscriptionKey);
      if (subscriptionJson != null) {
        final json = jsonDecode(subscriptionJson) as Map<String, dynamic>;
        _userSubscription = UserSubscription.fromJson(json);
        // Check if subscription is expired
        if (_userSubscription!.isExpired) {
          _userSubscription = UserSubscription(
            id: _userSubscription!.id,
            type: _userSubscription!.type,
            period: _userSubscription!.period,
            startDate: _userSubscription!.startDate,
            endDate: _userSubscription!.endDate,
            isActive: false,
            pricePaid: _userSubscription!.pricePaid,
          );
          await _saveUserSubscription();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user subscription: $e');
    }
  }

  Future<void> _saveUserSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_userSubscription != null) {
        await prefs.setString(
          _userSubscriptionKey,
          jsonEncode(_userSubscription!.toJson()),
        );
      } else {
        await prefs.remove(_userSubscriptionKey);
      }
    } catch (e) {
      debugPrint('Error saving user subscription: $e');
    }
  }

  Future<bool> subscribeToPro(SubscriptionPeriod period) async {
    try {
      final now = DateTime.now();
      DateTime endDate;
      double price;

      if (period == SubscriptionPeriod.monthly) {
        endDate = DateTime(now.year, now.month + 1, now.day);
        price = 999.0; // Rs. 999 per month
      } else {
        endDate = DateTime(now.year + 1, now.month, now.day);
        price = 9999.0; // Rs. 9,999 per year (save ~17%)
      }

      _userSubscription = UserSubscription(
        id: _uuid.v4(),
        type: SubscriptionType.pro,
        period: period,
        startDate: now,
        endDate: endDate,
        isActive: true,
        pricePaid: price,
      );

      await _saveUserSubscription();
      notifyListeners();
      debugPrint('User subscribed to Pro plan: ${period.name}');
      return true;
    } catch (e) {
      debugPrint('Error subscribing to Pro: $e');
      return false;
    }
  }

  Future<void> cancelSubscription() async {
    try {
      if (_userSubscription != null) {
        _userSubscription = UserSubscription(
          id: _userSubscription!.id,
          type: _userSubscription!.type,
          period: _userSubscription!.period,
          startDate: _userSubscription!.startDate,
          endDate: _userSubscription!.endDate,
          isActive: false,
          pricePaid: _userSubscription!.pricePaid,
        );
        await _saveUserSubscription();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cancelling subscription: $e');
    }
  }

  // Get pro discount percentage for a vendor
  double getProDiscount(String vendorId) {
    if (!isProUser) return 0.0;
    // Check if vendor offers pro discounts (you can customize this logic)
    // For now, return 10% discount for pro users
    return 10.0;
  }

  // Get discounted price for pro users
  double getDiscountedPrice(double originalPrice, String vendorId) {
    if (!isProUser) return originalPrice;
    final discount = getProDiscount(vendorId);
    return originalPrice * (1 - discount / 100);
  }

  // Vendor Subscription Management
  Future<void> loadVendorSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionJson = prefs.getString(_vendorSubscriptionKey);
      if (subscriptionJson != null) {
        final json = jsonDecode(subscriptionJson) as Map<String, dynamic>;
        _vendorSubscription = UserSubscription.fromJson(json);
        // Check if subscription is expired
        if (_vendorSubscription!.isExpired) {
          _vendorSubscription = UserSubscription(
            id: _vendorSubscription!.id,
            type: _vendorSubscription!.type,
            period: _vendorSubscription!.period,
            startDate: _vendorSubscription!.startDate,
            endDate: _vendorSubscription!.endDate,
            isActive: false,
            pricePaid: _vendorSubscription!.pricePaid,
          );
          await _saveVendorSubscription();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading vendor subscription: $e');
    }
  }

  // Create default active subscription for vendor login
  Future<void> ensureVendorHasActiveSubscription() async {
    try {
      // Only create if no subscription exists or subscription is not active
      if (_vendorSubscription == null || !_vendorSubscription!.isActive) {
        final now = DateTime.now();
        final endDate = DateTime(now.year, now.month + 1, now.day);
        
        _vendorSubscription = UserSubscription(
          id: _uuid.v4(),
          type: SubscriptionType.vendor,
          period: SubscriptionPeriod.monthly,
          startDate: now,
          endDate: endDate,
          isActive: true,
          pricePaid: 1999.0, // Rs. 1,999 per month
        );

        await _saveVendorSubscription();
        notifyListeners();
        debugPrint('Default active subscription created for vendor login');
      }
    } catch (e) {
      debugPrint('Error ensuring vendor has active subscription: $e');
    }
  }

  Future<void> _saveVendorSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_vendorSubscription != null) {
        await prefs.setString(
          _vendorSubscriptionKey,
          jsonEncode(_vendorSubscription!.toJson()),
        );
      } else {
        await prefs.remove(_vendorSubscriptionKey);
      }
    } catch (e) {
      debugPrint('Error saving vendor subscription: $e');
    }
  }

  Future<bool> subscribeVendor(SubscriptionPeriod period) async {
    try {
      final now = DateTime.now();
      DateTime endDate;
      double price;

      if (period == SubscriptionPeriod.monthly) {
        endDate = DateTime(now.year, now.month + 1, now.day);
        price = 1999.0; // Rs. 1,999 per month
      } else {
        endDate = DateTime(now.year + 1, now.month, now.day);
        price = 19999.0; // Rs. 19,999 per year (save ~17%)
      }

      _vendorSubscription = UserSubscription(
        id: _uuid.v4(),
        type: SubscriptionType.vendor,
        period: period,
        startDate: now,
        endDate: endDate,
        isActive: true,
        pricePaid: price,
      );

      await _saveVendorSubscription();
      notifyListeners();
      debugPrint('Vendor subscribed: ${period.name}');
      return true;
    } catch (e) {
      debugPrint('Error subscribing vendor: $e');
      return false;
    }
  }

  Future<void> cancelVendorSubscription() async {
    try {
      if (_vendorSubscription != null) {
        _vendorSubscription = UserSubscription(
          id: _vendorSubscription!.id,
          type: _vendorSubscription!.type,
          period: _vendorSubscription!.period,
          startDate: _vendorSubscription!.startDate,
          endDate: _vendorSubscription!.endDate,
          isActive: false,
          pricePaid: _vendorSubscription!.pricePaid,
        );
        await _saveVendorSubscription();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cancelling vendor subscription: $e');
    }
  }

  // Vendor Report Management
  Future<void> _loadVendorReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getString(_vendorReportsKey);
      if (reportsJson != null) {
        final json = jsonDecode(reportsJson) as List<dynamic>;
        _vendorReports = json
            .map((item) => VendorReport.fromJson(item as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading vendor reports: $e');
    }
  }

  Future<void> _saveVendorReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsList = _vendorReports.map((report) => report.toJson()).toList();
      final reportsJson = jsonEncode(reportsList);
      final success = await prefs.setString(_vendorReportsKey, reportsJson);
      if (!success) {
        debugPrint('Warning: SharedPreferences.setString returned false');
        // Don't throw - setString can return false but still work
      }
      debugPrint('Vendor reports saved successfully: ${_vendorReports.length} reports');
    } catch (e, stackTrace) {
      debugPrint('Error saving vendor reports: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow; // Re-throw to let caller know save failed
    }
  }

  Future<bool> reportVendor({
    required Vendor vendor,
    required String reason,
    required String description,
  }) async {
    try {
      // Ensure we have a valid reporter identifier
      final reporter = _userEmail.isNotEmpty 
          ? _userEmail 
          : (_userName.isNotEmpty ? _userName : 'Anonymous User');
      
      final report = VendorReport(
        id: _uuid.v4(),
        vendorId: vendor.id,
        vendorName: vendor.name,
        vendorCategory: vendor.category,
        reportReason: reason,
        reportDescription: description,
        reportedAt: DateTime.now(),
        reportedBy: reporter,
        status: 'pending',
      );

      _vendorReports.add(report);
      
      // Save reports and check if it was successful
      try {
        await _saveVendorReports();
        notifyListeners();
        debugPrint('Vendor reported successfully: ${vendor.name}');
        debugPrint('Total reports: ${_vendorReports.length}');
        return true;
      } catch (saveError) {
        debugPrint('Error saving vendor report: $saveError');
        // Remove the report from memory if save failed
        _vendorReports.removeLast();
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('Error reporting vendor: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }
}

