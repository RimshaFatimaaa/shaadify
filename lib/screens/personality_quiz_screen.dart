import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for consistent typography
import '../services/quiz_service.dart';
import '../services/ai_service.dart';
import '../models/personality_quiz.dart';

class PersonalityQuizScreen extends StatefulWidget {
  const PersonalityQuizScreen({super.key});

  @override
  State<PersonalityQuizScreen> createState() => _PersonalityQuizScreenState();
}

class _PersonalityQuizScreenState extends State<PersonalityQuizScreen> {
  final QuizService _quizService = QuizService();
  final AIService _aiService = AIService();
  List<PersonalityQuestion> _questions = [];
  final Map<String, String> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  PersonalityResult? _result;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    _questions = _quizService.getQuestions();
  }

  void _selectAnswer(String questionId, String optionId) {
    setState(() {
      _answers[questionId] = optionId;
    });
  }

  Future<void> _submitQuiz() async {
    if (_answers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _aiService.calculatePersonalityResult(_answers);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error calculating result: $e')));
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return _buildResultScreen();
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: _maroon,
        body: Center(child: CircularProgressIndicator(color: _pistachio)),
      );
    }

    final question = _questions[_currentQuestionIndex];
    final selectedAnswer = _answers[question.id];

    return Scaffold(
      backgroundColor: _maroon, // Deep Maroon Background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          'Personality Quiz',
          style: GoogleFonts.poppins(
            color: _pistachio,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        iconTheme: IconThemeData(color: _pistachio),
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _maroon, // Fallback color
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Added blur
              child: Container(
                color: Colors.black.withOpacity(0.2), // Optional dark tint
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(
            child: Column(
              children: [
                // Progress Bar Section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                            style: GoogleFonts.poppins(
                              color: _pistachio,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${((_currentQuestionIndex + 1) / _questions.length * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              color: _pistachio,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value:
                              (_currentQuestionIndex + 1) / _questions.length,
                          backgroundColor: _pistachio.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(_pistachio),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                // Question Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _pistachio,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ...question.options.map((option) {
                          final isSelected = selectedAnswer == option.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () =>
                                  _selectAnswer(question.id, option.id),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _pistachio
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _pistachio,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? _maroon
                                              : _pistachio,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? _maroon
                                            : Colors.transparent,
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              size: 16,
                                              color: _pistachio,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        option.text,
                                        style: GoogleFonts.poppins(
                                          color: isSelected
                                              ? _maroon
                                              : _pistachio,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _maroon,
                    border: Border(
                      top: BorderSide(color: _pistachio.withOpacity(0.1)),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (_currentQuestionIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousQuestion,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _pistachio),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Previous',
                              style: TextStyle(color: _pistachio),
                            ),
                          ),
                        ),
                      if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: selectedAnswer != null
                              ? (_currentQuestionIndex < _questions.length - 1
                                    ? _nextQuestion
                                    : _submitQuiz)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pistachio,
                            foregroundColor: _maroon,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: _pistachio.withOpacity(
                              0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _maroon,
                                  ),
                                )
                              : Text(
                                  _currentQuestionIndex < _questions.length - 1
                                      ? 'Next'
                                      : 'Submit',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Scaffold(
      backgroundColor: _maroon,
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          'Your Results',
          style: GoogleFonts.poppins(color: _pistachio),
        ),
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        iconTheme: IconThemeData(color: _pistachio),
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _maroon, // Fallback color
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Added blur
              child: Container(
                color: Colors.black.withOpacity(0.2), // Optional dark tint
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _pistachio,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Perfect Theme',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: _maroon,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!.recommendedTheme,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _maroon,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildResultSection(
                  'Recommended Venue',
                  _result!.recommendedVenueCategory,
                  Icons.location_city,
                ),
                const SizedBox(height: 16),
                _buildResultSection(
                  'Makeup Style',
                  _result!.recommendedMakeupStyle,
                  Icons.face,
                ),
                const SizedBox(height: 16),
                _buildResultSection(
                  'Budget Range',
                  'Rs. ${(_result!.recommendedBudgetMin / 100000).toStringAsFixed(1)}L - Rs. ${(_result!.recommendedBudgetMax / 100000).toStringAsFixed(1)}L',
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 24),
                Text(
                  'Décor Ideas',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _pistachio,
                  ),
                ),
                const SizedBox(height: 12),
                ..._result!.recommendedDecorIdeas.map(
                  (idea) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: _pistachio,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: _maroon),
                      title: Text(
                        idea,
                        style: TextStyle(
                          color: _maroon,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: _pistachio,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: _maroon),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: _maroon),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: _maroon.withOpacity(0.8)),
        ),
      ),
    );
  }
}
