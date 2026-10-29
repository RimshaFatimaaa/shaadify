class AppConstants {
  // App Info
  static const String appName = 'Shaadify';
  static const String appTagline = 'Plan Your Perfect Pakistani Wedding';

  // Budget Thresholds (in PKR)
  static const double budgetLow = 500000; // 5 Lakh
  static const double budgetMedium = 2000000; // 20 Lakh
  static const double budgetHigh = 5000000; // 50 Lakh

  // Categories
  static const List<String> itemCategories = [
    'Venue',
    'Décor',
    'Catering',
    'Makeup',
    'Photography',
    'Music',
    'Nikah Setup',
    'Gifts',
    'Car Entry',
    'Other',
  ];

  // Pakistani Cities
  static const List<String> pakistaniCities = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Hyderabad',
    'Sargodha',
  ];

  // Wedding Themes
  static const List<String> weddingThemes = [
    'Royal',
    'Pastel',
    'Neon',
    'Rustic',
    'Garden',
    'Classic Red',
    'Modern Minimalist',
    'Vintage',
    'Boho',
    'Luxury',
  ];

  // Color Palettes
  static const Map<String, List<String>> themeColorPalettes = {
    'Royal': ['#8B4513', '#FFD700', '#FF6347', '#000000'],
    'Pastel': ['#FFB6C1', '#E6E6FA', '#F0E68C', '#98FB98'],
    'Neon': ['#FF1493', '#00FFFF', '#FFFF00', '#FF00FF'],
    'Rustic': ['#8B4513', '#A0522D', '#CD853F', '#DEB887'],
    'Garden': ['#228B22', '#32CD32', '#90EE90', '#FFD700'],
    'Classic Red': ['#DC143C', '#FF6347', '#FFD700', '#000000'],
    'Modern Minimalist': ['#FFFFFF', '#000000', '#808080', '#C0C0C0'],
    'Vintage': ['#8B4513', '#A0522D', '#CD853F', '#F5DEB3'],
    'Boho': ['#FF6B6B', '#4ECDC4', '#FFE66D', '#95E1D3'],
    'Luxury': ['#000000', '#FFD700', '#C0C0C0', '#8B0000'],
  };
}

