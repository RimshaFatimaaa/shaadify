import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/vendor.dart';
import '../services/wedding_service.dart';
import '../constants/app_constants.dart';
import '../utils/event_translations.dart';
import 'vendor_detail_screen.dart';

class VendorMarketplaceScreen extends StatefulWidget {
  final String? initialCategory;

  const VendorMarketplaceScreen({super.key, this.initialCategory});

  @override
  State<VendorMarketplaceScreen> createState() =>
      _VendorMarketplaceScreenState();
}

class _VendorMarketplaceScreenState extends State<VendorMarketplaceScreen> {
  final WeddingService _weddingService = WeddingService();
  String? _selectedCategory;
  String? _selectedCity;
  List<Vendor> _vendors = [];

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadVendors();
  }

  void _loadVendors() {
    final allVendors = <Vendor>[];
    for (final category in AppConstants.itemCategories) {
      allVendors.addAll(_weddingService.getVendorsByCategory(category));
    }
    setState(() {
      _vendors = allVendors;
    });
  }

  List<Vendor> get _filteredVendors {
    return _vendors.where((vendor) {
      if (_selectedCategory != null && vendor.category != _selectedCategory) {
        return false;
      }
      if (_selectedCity != null && vendor.city != _selectedCity) {
        return false;
      }
      return true;
    }).toList();
  }

  String _getCategoryTranslation(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return category;

    switch (category) {
      case 'Venue':
        return l10n.categoryVenue;
      case 'Décor':
        return l10n.categoryDecor;
      case 'Catering':
        return l10n.categoryCatering;
      case 'Makeup':
        return l10n.categoryMakeup;
      case 'Photography':
        return l10n.categoryPhotography;
      case 'Music':
        return l10n.categoryMusic;
      case 'Nikah Setup':
        return l10n.categoryNikahSetup;
      case 'Gifts':
        return l10n.categoryGifts;
      case 'Car Entry':
        return l10n.categoryCarEntry;
      case 'Other':
        return l10n.categoryOther;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true, // Allow body behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false, // Remove back button since it's in IndexedStack
        iconTheme: IconThemeData(
          color: _maroon,
        ), // Maroon Back Button (Outside Card)
      ),

      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white, // Fallback to white so maroon text pops
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
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
                // Filters Section
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _maroon, // Maroon Background for Filter Bar
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Category Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          dropdownColor: _maroon, // Popup Maroon
                          style: GoogleFonts.poppins(
                            color: _pistachio,
                          ), // Pistachio Text
                          icon: Icon(Icons.arrow_drop_down, color: _pistachio),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.categories,
                            labelStyle: GoogleFonts.poppins(
                              color: _pistachio.withOpacity(0.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _pistachio.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _pistachio,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: _pistachio),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                AppLocalizations.of(context)!.allCategories,
                                style: GoogleFonts.poppins(color: _pistachio),
                              ),
                            ),
                            ...AppConstants.itemCategories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  _getCategoryTranslation(context, category),
                                  style: GoogleFonts.poppins(color: _pistachio),
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // City Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCity,
                          dropdownColor: _maroon, // Popup Maroon
                          style: GoogleFonts.poppins(
                            color: _pistachio,
                          ), // Pistachio Text
                          icon: Icon(Icons.arrow_drop_down, color: _pistachio),
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.city,
                            labelStyle: GoogleFonts.poppins(
                              color: _pistachio.withOpacity(0.7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _pistachio.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _pistachio,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: _pistachio),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                AppLocalizations.of(context)!.allCities,
                                style: GoogleFonts.poppins(color: _pistachio),
                              ),
                            ),
                            ...AppConstants.pakistaniCities.map((city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(
                                  city,
                                  style: GoogleFonts.poppins(color: _pistachio),
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Vendor List
                Expanded(
                  child: _filteredVendors.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noVendorsFound,
                            style: GoogleFonts.poppins(color: _maroon),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredVendors.length,
                          itemBuilder: (context, index) {
                            return _buildVendorCard(_filteredVendors[index]);
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

  Widget _buildVendorCard(Vendor vendor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _maroon, // Card Background: Maroon
      child: InkWell(
        onTap: () => _showVendorDetails(vendor),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    backgroundImage: AssetImage(
                      'assets/images/${vendor.name.toLowerCase().replaceAll(' ', '_').replaceAll("'", "").replaceAll('é', 'e')}.png',
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      debugPrint('Image missing for: ${vendor.name}');
                    },
                    child: vendor.name.isNotEmpty
                        ? Text(
                            vendor.name[0].toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _pistachio,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                vendor.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _pistachio, // Pistachio Text
                                ),
                              ),
                            ),
                            if (vendor.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _pistachio.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: _pistachio,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppLocalizations.of(context)!.verified,
                                      style: GoogleFonts.poppins(
                                        color: _pistachio,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryTranslation(context, vendor.category),
                          style: GoogleFonts.poppins(
                            color: _pistachio.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: _pistachio.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vendor.city,
                              style: GoogleFonts.poppins(
                                color: _pistachio.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        vendor.rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: _pistachio, // Pistachio Text
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${vendor.reviewCount} ${AppLocalizations.of(context)!.reviews})',
                        style: GoogleFonts.poppins(
                          color: _pistachio.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (vendor.packages.isNotEmpty)
                    Text(
                      '${AppLocalizations.of(context)!.fromRs} ${_formatPrice((vendor.packages.first.price as num).toDouble())}',
                      style: GoogleFonts.poppins(
                        color: _pistachio, // Pistachio Text
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVendorDetails(Vendor vendor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorDetailScreen(vendor: vendor),
      ),
    );
  }

  String _formatPrice(num price) {
    double value = price.toDouble();
    if (value >= 100000) {
      return 'Rs. ${(value / 100000).toStringAsFixed(1)} Lakh';
    } else if (value >= 1000) {
      return 'Rs. ${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return 'Rs. ${value.toStringAsFixed(0)}';
    }
  }
}
