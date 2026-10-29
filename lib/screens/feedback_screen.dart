import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'give_feedback_screen.dart';
import 'all_feedbacks_screen.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // THEME COLORS
    const Color maroon = Color(0xFF600000);
    const Color pistachio = Color(0xFFD7E8CD);

    return Scaffold(
      backgroundColor: maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          l10n.feedback,
          style: GoogleFonts.poppins(
            color: pistachio,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        iconTheme: const IconThemeData(color: pistachio),
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: maroon, // Fallback color
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Section 1: Give Feedback
                  Card(
                    elevation: 4,
                    color: maroon, // Maroon Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: pistachio.withOpacity(0.2)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GiveFeedbackScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_note,
                                color: pistachio, // Pistachio Icon
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.giveFeedback,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: pistachio, // Pistachio Text
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Share your experience with vendors',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: pistachio.withOpacity(
                                        0.7,
                                      ), // Pistachio Text
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: pistachio, // Pistachio Icon
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Section 2: All Feedbacks
                  Card(
                    elevation: 4,
                    color: maroon, // Maroon Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: pistachio.withOpacity(0.2)),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllFeedbacksScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.feedback,
                                color: pistachio, // Pistachio Icon
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.allFeedback,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: pistachio, // Pistachio Text
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'View all feedbacks from users',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: pistachio.withOpacity(
                                        0.7,
                                      ), // Pistachio Text
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: pistachio, // Pistachio Icon
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
