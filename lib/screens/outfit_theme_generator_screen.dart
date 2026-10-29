import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/wedding_event.dart';
import '../utils/image_helper.dart';
import '../utils/event_translations.dart';

class OutfitThemeGeneratorScreen extends StatefulWidget {
  const OutfitThemeGeneratorScreen({super.key});

  @override
  State<OutfitThemeGeneratorScreen> createState() =>
      _OutfitThemeGeneratorScreenState();
}

class _OutfitThemeGeneratorScreenState
    extends State<OutfitThemeGeneratorScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isGenerating = false;
  String? _generatedTheme;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
          _generatedTheme = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _generateTheme() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedTheme = null;
    });

    // Simulate AI theme generation
    await Future.delayed(const Duration(seconds: 2));

    // Mock theme generation based on image
    final themes = [
      'Royal Mughal Red',
      'Elegant Pastel',
      'Classic Gold & Maroon',
      'Modern Minimalist',
      'Luxury Emerald',
    ];

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _generatedTheme = themes[DateTime.now().millisecond % themes.length];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Theme generated: $_generatedTheme'),
          backgroundColor: _maroon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        title: Text(
          'Generate Theme from Outfit',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _maroon, // Maroon Text (Outside)
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _maroon), // Maroon Icon
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors
                    .white, // Fallback to white for maroon text visibility
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _maroon, // Maroon Card
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _pistachio,
                            ), // Pistachio Icon
                            const SizedBox(width: 8),
                            Text(
                              'How it works',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _pistachio, // Pistachio Text
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Upload a photo of your wedding outfit and our AI will analyze the colors, patterns, and style to generate a matching wedding theme.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _pistachio.withOpacity(
                              0.8,
                            ), // Pistachio Text
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sample Outfit Images
                  Text(
                    'Sample Outfits',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _maroon, // Maroon Text (Outside)
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...EventType.values.map((eventType) {
                          final outfitImage = ImageHelper.getRandomOutfitImage(
                            eventType,
                          );
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                                _generatedTheme = null;
                              });
                              // In a real app, you would load the asset image
                              // For now, we'll show a message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Tap "Upload Photo" to use ${EventTranslations.getEventName(context, eventType)} outfit',
                                    style: TextStyle(color: _pistachio),
                                  ),
                                  backgroundColor: _maroon,
                                ),
                              );
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _maroon, // Maroon Border
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  outfitImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: _maroon.withOpacity(0.2),
                                      child: Icon(
                                        Icons.image,
                                        size: 40,
                                        color: _maroon,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: _maroon, // Maroon Card
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedImage != null
                              ? _pistachio
                              : _pistachio.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 64,
                                  color: _pistachio.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tap to upload outfit photo',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: _pistachio, // Pistachio Text
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'JPG, PNG up to 5MB',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _pistachio.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Generate Button
                  ElevatedButton(
                    onPressed: _isGenerating ? null : _generateTheme,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _maroon, // Maroon Button
                      foregroundColor: _pistachio, // Pistachio Text
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: _pistachio,
                      ), // Border for visibility
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isGenerating
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _pistachio,
                              ),
                            ),
                          )
                        : Text(
                            'Generate Theme',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // Generated Theme Result
                  if (_generatedTheme != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _maroon, // Maroon Card
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.palette, color: _pistachio),
                              const SizedBox(width: 8),
                              Text(
                                'Generated Theme',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _pistachio, // Pistachio Text
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _pistachio),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _generatedTheme!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _pistachio, // Pistachio Text
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to event selection with this theme
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Use This Theme',
                                style: GoogleFonts.poppins(
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
          ),
        ],
      ),
    );
  }
}
