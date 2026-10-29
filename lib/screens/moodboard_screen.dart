import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for consistent font
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../services/ai_service.dart';
import '../models/theme.dart';

class MoodboardScreen extends StatefulWidget {
  const MoodboardScreen({super.key});

  @override
  State<MoodboardScreen> createState() => _MoodboardScreenState();
}

class _MoodboardScreenState extends State<MoodboardScreen> {
  final AIService _aiService = AIService();
  Moodboard? _moodboard;
  bool _isLoading = false;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    _generateMoodboard();
  }

  Future<void> _generateMoodboard() async {
    final provider = Provider.of<WeddingProvider>(context, listen: false);
    final event = provider.currentEvent;

    if (event == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No event selected')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final moodboard = await _aiService.generateMoodboard(event);
      setState(() {
        _moodboard = moodboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating moodboard: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback Background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          'AI Moodboard',
          style: GoogleFonts.poppins(
            color: _pistachio,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        iconTheme: IconThemeData(color: _pistachio),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: _pistachio),
            onPressed: _generateMoodboard,
          ),
        ],
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: _pistachio))
                : _moodboard == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.palette,
                          size: 64,
                          color: _pistachio.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No moodboard generated yet',
                          style: GoogleFonts.poppins(
                            color: _pistachio.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _generateMoodboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _maroon, // Maroon Button
                            foregroundColor: _pistachio, // Pistachio Text
                            side: BorderSide(color: _pistachio),
                          ),
                          child: Text(
                            'Generate Moodboard',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Theme Info
                        Card(
                          color: _maroon, // Maroon Card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: _pistachio.withOpacity(0.3),
                            ),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _moodboard!.theme,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _pistachio, // Pistachio Text
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Theme',
                                        style: GoogleFonts.poppins(
                                          color: _pistachio.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Color Palette
                        Text(
                          'Color Palette',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _pistachio, // Pistachio Text outside
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _moodboard!.colorPalette.map((color) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: _parseColor(color),
                                shape: BoxShape.circle,
                                border: Border.all(color: _pistachio, width: 2),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Moodboard Images
                        Text(
                          'Moodboard Images',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _pistachio, // Pistachio Text outside
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: _moodboard!.imageUrls.length,
                          itemBuilder: (context, index) {
                            final imageUrl = _moodboard!.imageUrls[index];
                            final isAsset = imageUrl.startsWith('assets/');

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _pistachio.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: isAsset
                                    ? Image.asset(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: _maroon.withOpacity(0.5),
                                                child: Icon(
                                                  Icons.error,
                                                  color: _pistachio,
                                                ),
                                              );
                                            },
                                      )
                                    : Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: _maroon.withOpacity(0.5),
                                                child: Icon(
                                                  Icons.error,
                                                  color: _pistachio,
                                                ),
                                              );
                                            },
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}
