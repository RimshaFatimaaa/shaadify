import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/price_formatter.dart';
import '../l10n/app_localizations.dart';
import 'notifications_screen.dart';

class VendorPackagesScreen extends StatefulWidget {
  final String? vendorCategory;

  const VendorPackagesScreen({super.key, this.vendorCategory});

  @override
  State<VendorPackagesScreen> createState() => _VendorPackagesScreenState();
}

class _VendorPackagesScreenState extends State<VendorPackagesScreen> {
  final List<Map<String, dynamic>> _packages = [];

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        title: Text(
                      l10n.packages,
                      style: GoogleFonts.poppins(
            fontSize: 18,
                        fontWeight: FontWeight.bold,
            color: _maroon, // Maroon Text (Outside)
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: _maroon, // Maroon Icon
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => _showAddPackageDialog(context),
              icon: Icon(Icons.add_box, color: _maroon, size: 28),
              tooltip: l10n.addPackage,
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle / Description
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    widget.vendorCategory != null
                        ? l10n.manageYourPackages(widget.vendorCategory!)
                        : l10n.managePackagesGeneric,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _maroon.withOpacity(0.8), // Maroon Text
                      fontWeight: FontWeight.w500,
                    ),
            ),
          ),

          // Packages List
          Expanded(
            child: _packages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                                color: _maroon.withOpacity(0.5), // Maroon Icon
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No packages yet',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                                  color: _maroon, // Maroon Text
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                                l10n.tapIconToAddFirstPackage,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                                  color: _maroon.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80), // Extra bottom padding for bottom nav bar
                    itemCount: _packages.length,
                    itemBuilder: (context, index) {
                      final package = _packages[index];
                      return Card(
                              color: _maroon, // Maroon Card
                        margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            package['name'] ?? 'Package ${index + 1}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                                    color: _pistachio, // Pistachio Text
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                package['description'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: _pistachio.withOpacity(0.8),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                      PriceFormatter.format(
                                        package['price'] ?? 0.0,
                                      ),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                        color: _pistachio, // Pistachio Price
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                            onPressed: () {
                              setState(() {
                                _packages.removeAt(index);
                              });
                            },
                          ),
                        ),
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

  void _showAddPackageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final featuresController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
        backgroundColor: _maroon, // Maroon Dialog
        title: Text(
          dialogL10n.addPackage,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _pistachio, // Pistachio Text
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                controller: nameController,
                label: 'Package Name *',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: descriptionController,
                label: 'Description *',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: priceController,
                label: 'Price (PKR) *',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: featuresController,
                label: 'Features (comma separated)',
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              dialogL10n.cancel,
              style: GoogleFonts.poppins(color: _pistachio.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                setState(() {
                  _packages.add({
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'features': featuresController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                  });
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.packageAddedSuccessfully,
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
            child: Text(
              dialogL10n.add,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
      },
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: _pistachio), // Pistachio Input Text
      cursorColor: _pistachio,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _pistachio.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _pistachio),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
