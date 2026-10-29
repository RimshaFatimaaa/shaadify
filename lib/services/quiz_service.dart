import '../models/personality_quiz.dart';

class QuizService {
  static final QuizService _instance = QuizService._internal();
  factory QuizService() => _instance;
  QuizService._internal();

  List<PersonalityQuestion> getQuestions() {
    return [
      PersonalityQuestion(
        id: '1',
        question: 'What describes your ideal wedding vibe?',
        category: 'style',
        options: [
          PersonalityOption(
            id: '1a',
            text: 'Elegant and luxurious',
            scores: {'Royal': 10, 'Luxury': 10, 'Classic Red': 5},
          ),
          PersonalityOption(
            id: '1b',
            text: 'Soft and romantic',
            scores: {'Pastel': 10, 'Garden': 8, 'Boho': 5},
          ),
          PersonalityOption(
            id: '1c',
            text: 'Bold and vibrant',
            scores: {'Neon': 10, 'Classic Red': 8, 'Royal': 5},
          ),
          PersonalityOption(
            id: '1d',
            text: 'Natural and earthy',
            scores: {'Rustic': 10, 'Garden': 8, 'Boho': 7},
          ),
        ],
      ),
      PersonalityQuestion(
        id: '2',
        question: 'What is your favorite color palette?',
        category: 'colors',
        options: [
          PersonalityOption(
            id: '2a',
            text: 'Gold and Maroon',
            scores: {'Royal': 10, 'Classic Red': 8, 'Luxury': 7},
          ),
          PersonalityOption(
            id: '2b',
            text: 'Pink and Peach',
            scores: {'Pastel': 10, 'Garden': 7, 'Boho': 5},
          ),
          PersonalityOption(
            id: '2c',
            text: 'Bright and Neon',
            scores: {'Neon': 10, 'Modern Minimalist': 3},
          ),
          PersonalityOption(
            id: '2d',
            text: 'Brown and Beige',
            scores: {'Rustic': 10, 'Vintage': 8, 'Garden': 5},
          ),
        ],
      ),
      PersonalityQuestion(
        id: '3',
        question: 'What type of venue appeals to you?',
        category: 'venue',
        options: [
          PersonalityOption(
            id: '3a',
            text: 'Grand banquet hall',
            scores: {'Royal': 10, 'Luxury': 10, 'Classic Red': 7},
          ),
          PersonalityOption(
            id: '3b',
            text: 'Outdoor garden',
            scores: {'Garden': 10, 'Pastel': 8, 'Boho': 7},
          ),
          PersonalityOption(
            id: '3c',
            text: 'Modern event space',
            scores: {'Modern Minimalist': 10, 'Neon': 7},
          ),
          PersonalityOption(
            id: '3d',
            text: 'Rustic outdoor setting',
            scores: {'Rustic': 10, 'Vintage': 8, 'Garden': 6},
          ),
        ],
      ),
      PersonalityQuestion(
        id: '4',
        question: 'How would you describe your makeup style preference?',
        category: 'makeup',
        options: [
          PersonalityOption(
            id: '4a',
            text: 'Bold and glamorous',
            scores: {'Royal': 10, 'Luxury': 9, 'Classic Red': 8},
          ),
          PersonalityOption(
            id: '4b',
            text: 'Soft and natural',
            scores: {'Pastel': 10, 'Garden': 8, 'Boho': 7},
          ),
          PersonalityOption(
            id: '4c',
            text: 'Trendy and modern',
            scores: {'Neon': 9, 'Modern Minimalist': 8},
          ),
          PersonalityOption(
            id: '4d',
            text: 'Classic and timeless',
            scores: {'Vintage': 10, 'Classic Red': 8, 'Royal': 6},
          ),
        ],
      ),
      PersonalityQuestion(
        id: '5',
        question: 'What is your budget range?',
        category: 'budget',
        options: [
          PersonalityOption(
            id: '5a',
            text: '5-15 Lakh',
            scores: {'Pastel': 8, 'Garden': 7, 'Rustic': 7},
          ),
          PersonalityOption(
            id: '5b',
            text: '15-30 Lakh',
            scores: {'Classic Red': 8, 'Garden': 7, 'Boho': 6},
          ),
          PersonalityOption(
            id: '5c',
            text: '30-50 Lakh',
            scores: {'Royal': 9, 'Luxury': 9, 'Classic Red': 7},
          ),
          PersonalityOption(
            id: '5d',
            text: '50+ Lakh',
            scores: {'Royal': 10, 'Luxury': 10, 'Modern Minimalist': 7},
          ),
        ],
      ),
      PersonalityQuestion(
        id: '6',
        question: 'What type of music do you prefer?',
        category: 'entertainment',
        options: [
          PersonalityOption(
            id: '6a',
            text: 'Traditional dhol and qawwali',
            scores: {'Royal': 8, 'Classic Red': 9, 'Vintage': 7},
          ),
          PersonalityOption(
            id: '6b',
            text: 'Soft instrumental',
            scores: {'Pastel': 9, 'Garden': 8, 'Boho': 7},
          ),
          PersonalityOption(
            id: '6c',
            text: 'Modern DJ and beats',
            scores: {'Neon': 10, 'Modern Minimalist': 8},
          ),
          PersonalityOption(
            id: '6d',
            text: 'Mix of traditional and modern',
            scores: {'Garden': 8, 'Boho': 8, 'Classic Red': 7},
          ),
        ],
      ),
    ];
  }
}

