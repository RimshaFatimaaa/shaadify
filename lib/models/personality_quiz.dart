class PersonalityQuestion {
  final String id;
  final String question;
  final List<PersonalityOption> options;
  final String category;

  PersonalityQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((o) => o.toJson()).toList(),
      'category': category,
    };
  }

  factory PersonalityQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalityQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((o) => PersonalityOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String,
    );
  }
}

class PersonalityOption {
  final String id;
  final String text;
  final String? imageUrl;
  final Map<String, int> scores; // theme -> score mapping

  PersonalityOption({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.scores,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'scores': scores,
    };
  }

  factory PersonalityOption.fromJson(Map<String, dynamic> json) {
    return PersonalityOption(
      id: json['id'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      scores: Map<String, int>.from(json['scores'] ?? {}),
    );
  }
}

class PersonalityResult {
  final String recommendedTheme;
  final String recommendedVenueCategory;
  final String recommendedMakeupStyle;
  final List<String> recommendedDecorIdeas;
  final double recommendedBudgetMin;
  final double recommendedBudgetMax;
  final List<String> recommendedVendorCategories;
  final Map<String, int> themeScores;

  PersonalityResult({
    required this.recommendedTheme,
    required this.recommendedVenueCategory,
    required this.recommendedMakeupStyle,
    required this.recommendedDecorIdeas,
    required this.recommendedBudgetMin,
    required this.recommendedBudgetMax,
    required this.recommendedVendorCategories,
    required this.themeScores,
  });

  Map<String, dynamic> toJson() {
    return {
      'recommendedTheme': recommendedTheme,
      'recommendedVenueCategory': recommendedVenueCategory,
      'recommendedMakeupStyle': recommendedMakeupStyle,
      'recommendedDecorIdeas': recommendedDecorIdeas,
      'recommendedBudgetMin': recommendedBudgetMin,
      'recommendedBudgetMax': recommendedBudgetMax,
      'recommendedVendorCategories': recommendedVendorCategories,
      'themeScores': themeScores,
    };
  }

  factory PersonalityResult.fromJson(Map<String, dynamic> json) {
    return PersonalityResult(
      recommendedTheme: json['recommendedTheme'] as String,
      recommendedVenueCategory: json['recommendedVenueCategory'] as String,
      recommendedMakeupStyle: json['recommendedMakeupStyle'] as String,
      recommendedDecorIdeas:
          List<String>.from(json['recommendedDecorIdeas'] ?? []),
      recommendedBudgetMin: (json['recommendedBudgetMin'] as num).toDouble(),
      recommendedBudgetMax: (json['recommendedBudgetMax'] as num).toDouble(),
      recommendedVendorCategories:
          List<String>.from(json['recommendedVendorCategories'] ?? []),
      themeScores: Map<String, int>.from(json['themeScores'] ?? {}),
    );
  }
}

