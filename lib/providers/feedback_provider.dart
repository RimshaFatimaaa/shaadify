import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/vendor_feedback.dart';
import '../services/wedding_service.dart';

class FeedbackProvider with ChangeNotifier {
  List<VendorFeedback> _feedbacks = [];
  static const String _feedbackKey = 'vendor_feedbacks';

  List<VendorFeedback> get feedbacks => List.unmodifiable(_feedbacks);

  bool _sampleFeedbacksInitialized = false;

  FeedbackProvider() {
    _loadFeedbacks().then((_) {
      if (!_sampleFeedbacksInitialized) {
        _initializeSampleFeedbacks();
      }
    });
  }

  void _initializeSampleFeedbacks() async {
    // Only add sample feedbacks if no feedbacks exist and haven't been initialized yet
    if (_feedbacks.isEmpty && !_sampleFeedbacksInitialized) {
      _sampleFeedbacksInitialized = true;
      final weddingService = WeddingService();
      
      // Get vendors to match by name
      final allVendors = <String, String>{}; // vendorName -> vendorId
      for (final category in ['Venue', 'Décor', 'Catering', 'Makeup', 'Photography', 'Music']) {
        final vendors = weddingService.getVendorsByCategory(category);
        for (final vendor in vendors) {
          allVendors[vendor.name] = vendor.id;
        }
      }
      
      // Helper function to get vendor ID by name, or create a placeholder
      String getVendorId(String vendorName) {
        return allVendors[vendorName] ?? 'vendor_${vendorName.replaceAll(' ', '_').toLowerCase()}';
      }
      
      final sampleFeedbacks = [
        VendorFeedback(
          id: 'sample_1',
          vendorId: getVendorId('Royal Palace KHI'),
          vendorName: 'Royal Palace KHI',
          userId: 'user_sample_1',
          userName: 'Ahmed Ali',
          type: FeedbackType.good,
          comment: 'Excellent venue! The decoration was beautiful and the staff was very professional. Highly recommended!',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        VendorFeedback(
          id: 'sample_2',
          vendorId: getVendorId('Garden Paradise LHR'),
          vendorName: 'Garden Paradise LHR',
          userId: 'user_sample_2',
          userName: 'Fatima Khan',
          type: FeedbackType.good,
          comment: 'Amazing outdoor venue with beautiful garden setting. Perfect for a traditional wedding!',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        VendorFeedback(
          id: 'sample_3',
          vendorId: getVendorId('Royal Décor Lahore'),
          vendorName: 'Royal Décor Lahore',
          userId: 'user_sample_3',
          userName: 'Hassan Malik',
          type: FeedbackType.average,
          comment: 'Decoration was okay, but could have been better. Some items were not as shown in pictures.',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        VendorFeedback(
          id: 'sample_4',
          vendorId: getVendorId('Lahore Wedding Studios'),
          vendorName: 'Lahore Wedding Studios',
          userId: 'user_sample_4',
          userName: 'Ayesha Sheikh',
          type: FeedbackType.good,
          comment: 'Professional photography services! They captured all the special moments beautifully. Great work!',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        VendorFeedback(
          id: 'sample_5',
          vendorId: getVendorId("Zara's Salon"),
          vendorName: "Zara's Salon",
          userId: 'user_sample_5',
          userName: 'Sana Ahmed',
          type: FeedbackType.bad,
          comment: 'Makeup artist arrived late and the final look was not as expected. Very disappointed.',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        VendorFeedback(
          id: 'sample_6',
          vendorId: getVendorId('Golden Ballroom ISB'),
          vendorName: 'Golden Ballroom ISB',
          userId: 'user_sample_6',
          userName: 'Bilal Raza',
          type: FeedbackType.good,
          comment: 'Beautiful ballroom venue! The lighting and ambiance were perfect for our event.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        VendorFeedback(
          id: 'sample_7',
          vendorId: getVendorId('Royal Palace KHI'),
          vendorName: 'Royal Palace KHI',
          userId: 'user_sample_7',
          userName: 'Zainab Ali',
          type: FeedbackType.average,
          comment: 'Venue is nice but parking was an issue. Food quality was average.',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        VendorFeedback(
          id: 'sample_8',
          vendorId: getVendorId('Royal Cuisine LHR'),
          vendorName: 'Royal Cuisine LHR',
          userId: 'user_sample_8',
          userName: 'Usman Khan',
          type: FeedbackType.good,
          comment: 'Food was delicious and served on time. Great variety of dishes. Everyone loved it!',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ];

      _feedbacks.addAll(sampleFeedbacks);
      await _saveFeedbacks();
      notifyListeners();
    }
  }

  Future<void> _loadFeedbacks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbacksJson = prefs.getString(_feedbackKey);
      if (feedbacksJson != null && feedbacksJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(feedbacksJson);
        _feedbacks = decoded
            .map((json) => VendorFeedback.fromJson(json as Map<String, dynamic>))
            .toList();
        // Sort by date (newest first) after loading
        _feedbacks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading feedbacks: $e');
    }
  }

  Future<void> _saveFeedbacks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbacksJson = json.encode(
        _feedbacks.map((f) => f.toJson()).toList(),
      );
      await prefs.setString(_feedbackKey, feedbacksJson);
    } catch (e) {
      debugPrint('Error saving feedbacks: $e');
    }
  }

  Future<void> addFeedback({
    required String vendorId,
    required String vendorName,
    required String userId,
    required String userName,
    required FeedbackType type,
    required String comment,
  }) async {
    final feedback = VendorFeedback(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vendorId: vendorId,
      vendorName: vendorName,
      userId: userId,
      userName: userName,
      type: type,
      comment: comment,
      createdAt: DateTime.now(),
    );

    // Add new feedback at the beginning (most recent first)
    _feedbacks.insert(0, feedback);
    await _saveFeedbacks();
    notifyListeners();
  }

  List<VendorFeedback> getFeedbacksByVendor(String vendorId) {
    final filtered = _feedbacks.where((f) => f.vendorId == vendorId).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  List<VendorFeedback> getFeedbacksByType(FeedbackType type) {
    final filtered = _feedbacks.where((f) => f.type == type).toList();
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  int getFeedbackCountByVendor(String vendorId, FeedbackType type) {
    return _feedbacks
        .where((f) => f.vendorId == vendorId && f.type == type)
        .length;
  }

  bool hasUserGivenFeedback(String vendorId, String userId) {
    return _feedbacks.any(
      (f) => f.vendorId == vendorId && f.userId == userId,
    );
  }
}
