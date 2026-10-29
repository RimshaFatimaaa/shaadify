import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorPortfolioScreen extends StatefulWidget {
  final String? vendorCategory;

  const VendorPortfolioScreen({super.key, this.vendorCategory});

  @override
  State<VendorPortfolioScreen> createState() => _VendorPortfolioScreenState();
}

class _VendorPortfolioScreenState extends State<VendorPortfolioScreen> {
  final List<String> _portfolioImages = [];

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
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
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portfolio',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _maroon, // Maroon Text (Outside)
                            ),
                          ),
                          Text(
                            widget.vendorCategory != null
                                ? 'Showcase your ${widget.vendorCategory} work'
                                : 'Showcase your work',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _maroon.withOpacity(0.7), // Maroon Text
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddImageDialog(context),
                        icon: Icon(
                          Icons.add_photo_alternate,
                          color: _pistachio,
                        ), // Pistachio Icon
                        label: Text(
                          'Add Image',
                          style: TextStyle(color: _pistachio), // Pistachio Text
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _maroon, // Maroon Button
                          foregroundColor: _pistachio,
                        ),
                      ),
                    ],
                  ),
                ),

                // Portfolio Grid
                Expanded(
                  child: _portfolioImages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 64,
                                color: _maroon.withOpacity(0.5), // Maroon Icon
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No portfolio images yet',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: _maroon, // Maroon Text
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add images to showcase your work',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _maroon.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                          itemCount: _portfolioImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _maroon.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _maroon.withOpacity(0.3),
                                      ),
                                    ),
                                    child:
                                        _portfolioImages[index].startsWith(
                                          'http',
                                        )
                                        ? Image.network(
                                            _portfolioImages[index],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.image,
                                                    size: 48,
                                                    color: _maroon.withOpacity(
                                                      0.5,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 48,
                                            color: _maroon.withOpacity(0.5),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.red,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _portfolioImages.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddImageDialog(BuildContext context) {
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _maroon, // Maroon Dialog
        title: Text(
          'Add Portfolio Image',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _pistachio, // Pistachio Text
          ),
        ),
        content: TextField(
          controller: urlController,
          style: TextStyle(color: _pistachio), // Pistachio Input Text
          decoration: InputDecoration(
            labelText: 'Image URL',
            labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _pistachio.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _pistachio),
            ),
            border: OutlineInputBorder(),
            hintText: 'Enter image URL or path',
            hintStyle: TextStyle(color: _pistachio.withOpacity(0.3)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: _pistachio.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                setState(() {
                  _portfolioImages.add(urlController.text);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Image added successfully!',
                      style: TextStyle(color: _maroon),
                    ),
                    backgroundColor: _pistachio,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _pistachio, // Pistachio Button
              foregroundColor: _maroon, // Maroon Text
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
