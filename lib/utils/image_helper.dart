import 'package:flutter/services.dart';
import 'dart:math';
import '../models/wedding_event.dart';

class ImageHelper {
  static final Random _random = Random();

  /// Get local asset path for event images
  /// Returns a random event image for the given event type
  static String getEventImagePath(EventType eventType, {int? index}) {
    final eventName = _getEventFolderName(eventType);
    // If index is provided, use it; otherwise use a random one
    final imageIndex = index ?? (_random.nextInt(8) + 1); // Random between 1-8
    return 'assets/images/$eventName/event_$imageIndex.jpg';
  }

  /// Get all event images for an event type
  static List<String> getEventImages(EventType eventType) {
    final eventName = _getEventFolderName(eventType);
    final imageCounts = {
      'barat': 8,
      'mayun': 6,
      'mehndi': 10,
      'engagement': 6,
      'nikah': 7,
      'qawali night': 5,
      'walima': 6,
    };
    final count = imageCounts[eventName] ?? 6;
    return List.generate(count, (i) => 'assets/images/$eventName/event_${i + 1}.jpg');
  }

  /// Get outfit images for an event type
  static List<String> getOutfitImages(EventType eventType) {
    final eventName = _getEventFolderName(eventType);
    final outfitCounts = {
      'barat': 3,
      'mayun': 2,
      'mehndi': 2,
      'engagement': 3,
      'nikah': 3,
      'qawali night': 3,
      'walima': 3,
    };
    final count = outfitCounts[eventName] ?? 2;
    return List.generate(count, (i) => 'assets/images/$eventName/outfit_${i + 1}.jpg');
  }

  /// Get a random outfit image for an event type
  static String getRandomOutfitImage(EventType eventType) {
    final eventName = _getEventFolderName(eventType);
    final outfitCounts = {
      'barat': 3,
      'mayun': 2,
      'mehndi': 2,
      'engagement': 3,
      'nikah': 3,
      'qawali night': 3,
      'walima': 3,
    };
    final count = outfitCounts[eventName] ?? 2;
    final index = _random.nextInt(count) + 1;
    return 'assets/images/$eventName/outfit_$index.jpg';
  }

  /// Convert EventType to folder name
  static String _getEventFolderName(EventType eventType) {
    switch (eventType) {
      case EventType.barat:
        return 'barat';
      case EventType.mayun:
        return 'mayun';
      case EventType.mehndi:
        return 'mehndi';
      case EventType.engagement:
        return 'engagement';
      case EventType.nikah:
        return 'nikah';
      case EventType.qawaliNight:
        return 'qawali night';
      case EventType.walima:
        return 'walima';
    }
  }

  /// Get local asset path for moodboard images
  /// Returns null if image doesn't exist
  static String? getMoodboardImagePath(String theme, int index) {
    final themeLower = theme.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/moodboards/$themeLower/${themeLower}_$index.jpg';
  }

  /// Get local asset path for vendor image
  static String? getVendorImagePath(String vendorId) {
    return 'assets/images/vendors/vendor_$vendorId.jpg';
  }

  /// Get local asset path for wedding item image
  static String? getItemImagePath(String category, String itemName) {
    final categoryLower = category.toLowerCase().replaceAll(' ', '_');
    final itemLower = itemName.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/items/${categoryLower}_$itemLower.jpg';
  }

  /// Get local asset path for theme preview
  static String? getThemePreviewPath(String theme) {
    final themeLower = theme.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/themes/${themeLower}_preview.jpg';
  }

  /// Check if asset exists (for Flutter web/mobile)
  /// Note: This is a simplified check. In production, you might want to
  /// use a different approach or maintain a list of available assets
  static Future<bool> assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get list of moodboard images for a theme
  /// Returns local paths if available, otherwise returns placeholder URLs
  static Future<List<String>> getMoodboardImages(String theme, {int count = 6}) async {
    final images = <String>[];
    for (int i = 1; i <= count; i++) {
      final localPath = getMoodboardImagePath(theme, i);
      if (localPath != null) {
        // Check if asset exists
        final exists = await assetExists(localPath);
        if (exists) {
          images.add(localPath);
          continue;
        }
      }
      // Fall back to placeholder
      images.add('https://picsum.photos/400/600?random=${DateTime.now().millisecondsSinceEpoch + i}');
    }
    return images;
  }
}

