import 'dart:math';
import '../models/wedding_event.dart';
import '../models/theme.dart';
import '../models/personality_quiz.dart';
import '../constants/app_constants.dart';
import '../utils/image_helper.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final _random = Random();

  // Mock AI Moodboard Generation
  // In production, this would call OpenAI/Stable Diffusion API
  Future<Moodboard> generateMoodboard(
    WeddingEvent event, {
    String? outfitImageUrl,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    final theme = event.theme ?? 'Royal';
    final colors = AppConstants.themeColorPalettes[theme] ??
        AppConstants.themeColorPalettes['Royal']!;

    // Try to use local images first, fall back to placeholder URLs
    final imageUrls = await ImageHelper.getMoodboardImages(theme, count: 6);

    return Moodboard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: event.id,
      imageUrls: imageUrls,
      theme: theme,
      colorPalette: colors,
      createdAt: DateTime.now(),
      metadata: {
        'eventType': event.type.name,
        'outfitMatched': outfitImageUrl != null,
      },
    );
  }

  // Mock Personality Quiz Result
  Future<PersonalityResult> calculatePersonalityResult(
    Map<String, String> answers,
  ) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    // Calculate theme scores based on answers
    final themeScores = <String, int>{};
    for (final theme in AppConstants.weddingThemes) {
      themeScores[theme] = _random.nextInt(50) + 20; // Random score 20-70
    }

    // Find highest scoring theme
    final recommendedTheme = themeScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Generate recommendations based on theme
    String venueCategory;
    String makeupStyle;
    List<String> decorIdeas;

    switch (recommendedTheme) {
      case 'Royal':
        venueCategory = 'Banquet Hall';
        makeupStyle = 'Bold & Glamorous';
        decorIdeas = ['Gold accents', 'Crystal chandeliers', 'Rich fabrics'];
        break;
      case 'Pastel':
        venueCategory = 'Garden';
        makeupStyle = 'Soft & Natural';
        decorIdeas = ['Flower arches', 'Soft lighting', 'Pastel flowers'];
        break;
      case 'Rustic':
        venueCategory = 'Outdoor';
        makeupStyle = 'Natural & Earthy';
        decorIdeas = ['Wooden elements', 'Natural flowers', 'Warm lighting'];
        break;
      default:
        venueCategory = 'Banquet Hall';
        makeupStyle = 'Classic';
        decorIdeas = ['Elegant setup', 'Traditional elements'];
    }

    return PersonalityResult(
      recommendedTheme: recommendedTheme,
      recommendedVenueCategory: venueCategory,
      recommendedMakeupStyle: makeupStyle,
      recommendedDecorIdeas: decorIdeas,
      recommendedBudgetMin: 500000,
      recommendedBudgetMax: 3000000,
      recommendedVendorCategories: ['Venue', 'Décor', 'Makeup', 'Photography'],
      themeScores: themeScores,
    );
  }

  // Mock Outfit-to-Theme Matching
  Future<Map<String, dynamic>> matchOutfitToTheme(String imageUrl) async {
    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    // Mock color extraction and theme matching
    final extractedColors = [
      '#FF6347',
      '#FFD700',
      '#8B4513',
    ];

    final matchedTheme = 'Royal'; // Would be determined by AI

    return {
      'matchedTheme': matchedTheme,
      'extractedColors': extractedColors,
      'recommendedDecorColors': AppConstants.themeColorPalettes[matchedTheme],
      'stageStyle': 'Royal Stage with Gold Accents',
      'bouquetPalette': ['Gold', 'Red', 'Maroon'],
      'lightingColors': ['Warm Gold', 'Soft White'],
    };
  }

  // Mock Price Simulation
  Future<Map<String, dynamic>> simulatePriceChange(
    WeddingEvent event,
    Map<String, dynamic> changes,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Calculate new total based on changes
    double newTotal = event.totalCost;

    if (changes.containsKey('budgetIncrease')) {
      final increase = changes['budgetIncrease'] as double;
      // Would recalculate with better vendors
      newTotal = event.totalCost + (increase * 0.3); // 30% of increase goes to upgrades
    }

    if (changes.containsKey('decorReduction')) {
      final reduction = changes['decorReduction'] as double;
      final decorItems = event.selectedItems
          .where((item) => item.item.category == 'Décor')
          .toList();
      final decorCost = decorItems.fold(0.0, (sum, item) => sum + item.price);
      newTotal -= (decorCost * reduction / 100);
    }

    return {
      'newTotal': newTotal,
      'savings': event.totalCost - newTotal,
      'recommendedVendors': [],
      'alternatePackages': [],
    };
  }
}

