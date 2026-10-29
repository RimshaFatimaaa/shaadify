import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          'Wedding Timeline',
          style: GoogleFonts.poppins(
            color: _maroon, // Maroon Text (Outside)
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _maroon), // Maroon Back Button
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _maroon, // Fallback color matching other screens
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Added blur
              child: Container(
                color: Colors.white.withOpacity(
                  0.3,
                ), // Light tint to make Maroon text pop
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(
            child: Consumer<WeddingProvider>(
              builder: (context, provider, child) {
                final event = provider.currentEvent;
                if (event == null || event.timeline == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 64,
                          color: _maroon.withOpacity(0.5), // Maroon Icon
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No timeline generated yet',
                          style: GoogleFonts.poppins(
                            color: _maroon, // Maroon Text
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            provider.generateTimeline();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _maroon, // Maroon Button
                            foregroundColor: _pistachio, // Pistachio Text
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Generate Timeline',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final timeline = event.timeline!;
                final sortedTimes = timeline.keys.toList()..sort();

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: sortedTimes.length,
                  itemBuilder: (context, index) {
                    final time = sortedTimes[index];
                    final activity = timeline[time] as String;
                    final isLast = index == sortedTimes.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline Visual Indicator
                        Column(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: _maroon, // Maroon Dot
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _pistachio, // Pistachio Border
                                  width: 2,
                                ),
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 100,
                                color: _maroon.withOpacity(0.3), // Maroon Line
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Timeline Card
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                            child: Card(
                              color: _maroon, // Maroon Card
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: _pistachio.withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      time,
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _pistachio, // Pistachio Text
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      activity,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: _pistachio.withOpacity(0.85),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
