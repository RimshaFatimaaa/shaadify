import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/vendor.dart';
import '../models/vendor_review.dart';
import '../providers/wedding_provider.dart';

class VendorDetailScreen extends StatelessWidget {
  final Vendor vendor;

  const VendorDetailScreen({super.key, required this.vendor});

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

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
    // Add null safety check
    if (vendor.name.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Vendor information not available')),
      );
    }

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
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220, // Increased height for logo
                pinned: true,
                backgroundColor:
                    Colors.transparent, // TRANSPARENT to show background image
                elevation: 0, // Remove shadow for cleaner transparent look
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: _maroon,
                  ), // Pistachio Arrow
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  Builder(
                    builder: (context) {
                      return Consumer<WeddingProvider>(
                        builder: (context, provider, child) {
                          try {
                            final isSaved = provider.isVendorSaved(vendor.id);
                            return IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isSaved ? Colors.red : _maroon,
                                size: 28,
                              ),
                              tooltip: isSaved
                                  ? 'Remove from saved'
                                  : 'Save vendor',
                              onPressed: () {
                                try {
                                  final wasSaved = provider.isVendorSaved(
                                    vendor.id,
                                  );
                                  provider.toggleVendorSave(vendor);
                                  final nowSaved = !wasSaved;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        nowSaved
                                            ? '${vendor.name} saved successfully!'
                                            : '${vendor.name} removed from saved',
                                        style: TextStyle(
                                          color: _maroon,
                                        ), // Maroon Text
                                      ),
                                      backgroundColor:
                                          _pistachio, // Pistachio SnackBar
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } catch (e, stackTrace) {
                                  debugPrint('Error: $e');
                                }
                              },
                            );
                          } catch (e) {
                            return IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: _pistachio,
                                size: 28,
                              ),
                              onPressed: () {},
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    vendor.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: _maroon, // Pistachio Title
                      shadows: [
                        const Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                  background: Container(
                    color: Colors.transparent, // TRANSPARENT BACKGROUND
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _pistachio, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            // Logic to fetch image based on vendor name
                            'assets/images/${vendor.name.toLowerCase().replaceAll(' ', '_').replaceAll("'", "").replaceAll('é', 'e')}.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image fails
                              return Container(
                                color: _pistachio,
                                child: Center(
                                  child: Text(
                                    vendor.name.isNotEmpty
                                        ? vendor.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: _maroon,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            vendor.rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _maroon, // Maroon Text
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${vendor.reviewCount} ${AppLocalizations.of(context)!.reviews})',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _maroon.withOpacity(0.7), // Maroon Dim
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _maroon, // Maroon Pill
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _pistachio.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          _getCategoryTranslation(context, vendor.category),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _pistachio, // Pistachio Text
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      if (vendor.description.isNotEmpty) ...[
                        Text(
                          AppLocalizations.of(context)!.about,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _maroon, // Maroon Text
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          vendor.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _maroon.withOpacity(0.8), // Maroon Text
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Location Section (Card)
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
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: _pistachio, // Pistachio Icon
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.location,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _pistachio, // Pistachio Text
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    vendor.city,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: _pistachio.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Estimated Price Section (Card)
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
                            Text(
                              AppLocalizations.of(context)!.estimatedPrice,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _pistachio, // Pistachio Text
                              ),
                            ),
                            const SizedBox(height: 12),
                            Builder(
                              builder: (context) {
                                final plans = _getBookingPlansForCategory(
                                  vendor.category,
                                );
                                return Column(
                                  children: [
                                    if (plans.containsKey('Premium'))
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Premium Plan:',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: _pistachio,
                                              ),
                                            ),
                                            Text(
                                              _formatPrice(
                                                (plans['Premium']!['price']
                                                        as num)
                                                    .toDouble(),
                                              ),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _pistachio, // Pistachio Price
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (plans.containsKey('Medium'))
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context)!.mediumPlan}:',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: _pistachio,
                                            ),
                                          ),
                                          Text(
                                            _formatPrice(
                                              (plans['Medium']!['price'] as num)
                                                  .toDouble(),
                                            ),
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  _pistachio, // Pistachio Price
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Contact Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Calling ${vendor.phone}...',
                                      style: TextStyle(color: _maroon),
                                    ),
                                    backgroundColor: _pistachio,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.phone),
                              label: const Text('Call'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showPlanSelectionDialog(context);
                              },
                              icon: const Icon(Icons.book),
                              label: Text(
                                AppLocalizations.of(context)!.bookNow,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _maroon, // Maroon Button
                                foregroundColor: _pistachio, // Pistachio Text
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: BorderSide(color: _pistachio),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Reviews Section
                      if (vendor.reviews.isNotEmpty) ...[
                        Text(
                          'Reviews (${vendor.reviews.length})',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _maroon, // Maroon Text
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...vendor.reviews.map((review) => _buildReviewCard(review)),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(VendorReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              // User Avatar
              CircleAvatar(
                backgroundColor: _pistachio,
                radius: 20,
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                  style: GoogleFonts.poppins(
                    color: _maroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _pistachio, // Pistachio Text
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(review.date),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _pistachio.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Rating Stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    size: 18,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(width: 4),
              Text(
                review.rating.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _pistachio,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: _pistachio.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      return DateFormat('MMM yyyy').format(date);
    }
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

  Map<String, dynamic> _getBookingPlansForCategory(String category) {
    final plans = <String, Map<String, dynamic>>{};

    switch (category) {
      case 'Venue':
        plans['Premium'] = {
          'price': 500000,
          'features': [
            'Full day venue access',
            'Premium decoration included',
            'Sound system & lighting',
            'Parking facility',
            'Event coordinator',
            'Setup & cleanup service',
          ],
        };
        plans['Medium'] = {
          'price': 300000,
          'features': [
            'Half day venue access',
            'Basic decoration',
            'Sound system',
            'Parking facility',
            'Basic setup service',
          ],
        };
        break;
      case 'Décor':
        plans['Premium'] = {
          'price': 200000,
          'features': [
            'Premium floral arrangements',
            'Custom theme design',
            'LED lighting setup',
            'Stage decoration',
            'Entrance decoration',
            'Photo booth setup',
          ],
        };
        plans['Medium'] = {
          'price': 120000,
          'features': [
            'Standard floral arrangements',
            'Basic theme design',
            'Basic lighting',
            'Stage decoration',
            'Entrance decoration',
          ],
        };
        break;
      case 'Catering':
        plans['Premium'] = {
          'price': 400000,
          'features': [
            'Multi-course menu',
            'Live cooking stations',
            'Premium beverages',
            'Dessert bar',
            'Serving staff',
            'Table setup & cleanup',
          ],
        };
        plans['Medium'] = {
          'price': 250000,
          'features': [
            'Standard menu',
            'Basic beverages',
            'Dessert options',
            'Serving staff',
            'Table setup',
          ],
        };
        break;
      case 'Makeup':
        plans['Premium'] = {
          'price': 50000,
          'features': [
            'Bridal makeup & hairstyling',
            'Trial session included',
            'Premium products',
            'Hair accessories',
            'Touch-up service',
            'Makeup artist for 6 hours',
          ],
        };
        plans['Medium'] = {
          'price': 30000,
          'features': [
            'Bridal makeup & hairstyling',
            'Trial session',
            'Standard products',
            'Hair accessories',
            'Makeup artist for 4 hours',
          ],
        };
        break;
      case 'Photography':
        plans['Premium'] = {
          'price': 150000,
          'features': [
            'Full day coverage',
            '2 photographers',
            'Drone footage',
            'Cinematic video',
            'Photo album (50 pages)',
            'All edited photos',
            'Highlight reel',
          ],
        };
        plans['Medium'] = {
          'price': 90000,
          'features': [
            'Full day coverage',
            '1 photographer',
            'Standard video',
            'Photo album (30 pages)',
            'Edited photos',
          ],
        };
        break;
      case 'Music':
        plans['Premium'] = {
          'price': 100000,
          'features': [
            'Live band performance',
            'DJ services',
            'Sound system & lighting',
            '6 hours performance',
            'MC services',
            'Music playlist customization',
          ],
        };
        plans['Medium'] = {
          'price': 60000,
          'features': [
            'DJ services',
            'Sound system',
            '4 hours performance',
            'Basic MC services',
            'Standard playlist',
          ],
        };
        break;
      case 'Nikah Setup':
        plans['Premium'] = {
          'price': 150000,
          'features': [
            'Premium stage setup',
            'Floral arrangements',
            'Seating arrangement',
            'Sound system',
            'Lighting setup',
            'Decoration accessories',
          ],
        };
        plans['Medium'] = {
          'price': 90000,
          'features': [
            'Standard stage setup',
            'Basic floral arrangements',
            'Seating arrangement',
            'Sound system',
            'Basic lighting',
          ],
        };
        break;
      case 'Gifts':
        plans['Premium'] = {
          'price': 80000,
          'features': [
            'Premium gift boxes',
            'Customized items',
            'Gift wrapping service',
            'Delivery service',
            'Gift cards included',
            '50+ gift items',
          ],
        };
        plans['Medium'] = {
          'price': 50000,
          'features': [
            'Standard gift boxes',
            'Gift wrapping service',
            'Delivery service',
            '30+ gift items',
          ],
        };
        break;
      case 'Car Entry':
        plans['Premium'] = {
          'price': 70000,
          'features': [
            'Premium decorated car',
            'Flower arrangements',
            'Ribbon decoration',
            'Driver service',
            'Full day rental',
            'Multiple car options',
          ],
        };
        plans['Medium'] = {
          'price': 40000,
          'features': [
            'Decorated car',
            'Basic flower arrangements',
            'Ribbon decoration',
            'Driver service',
            'Half day rental',
          ],
        };
        break;
      default:
        plans['Premium'] = {
          'price': 200000,
          'features': [
            'Premium service package',
            'Full day service',
            'Professional team',
            'Quality materials',
            'Setup & cleanup',
          ],
        };
        plans['Medium'] = {
          'price': 120000,
          'features': [
            'Standard service package',
            'Half day service',
            'Professional team',
            'Basic materials',
            'Setup service',
          ],
        };
    }

    return plans;
  }

  void _showPlanSelectionDialog(BuildContext context) {
    final plans = _getBookingPlansForCategory(vendor.category);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: _maroon, // Maroon Sheet
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _pistachio.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Booking Plan',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _pistachio, // Pistachio
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vendor.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: _pistachio.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: _pistachio),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...plans.entries.map((entry) {
                        final planName = entry.key;
                        final planData = entry.value;
                        final isPremium = planName == 'Premium';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: _pistachio, // Pistachio Card
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isPremium
                                  ? Colors.amber.withOpacity(0.5)
                                  : Colors.transparent,
                              width: isPremium ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _showConfirmationDialog(
                                context,
                                planName,
                                planData,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            if (isPremium)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'POPULAR',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            if (isPremium)
                                              const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                '$planName Plan',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: _maroon, // Maroon Text
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Consumer<WeddingProvider>(
                                        builder: (context, provider, child) {
                                          final originalPrice =
                                              (planData['price'] as num)
                                                  .toDouble();
                                          final isPro = provider.isProUser;
                                          final discountedPrice = isPro
                                              ? provider.getDiscountedPrice(
                                                  originalPrice, vendor.id)
                                              : originalPrice;
                                          final discount = isPro
                                              ? provider.getProDiscount(
                                                  vendor.id)
                                              : 0.0;

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (isPro && discount > 0) ...[
                                                Row(
                                                  children: [
                                                    Text(
                                                      _formatPrice(
                                                          originalPrice),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: _maroon
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Text(
                                                        '${discount.toStringAsFixed(0)}% OFF',
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                              Text(
                                                _formatPrice(discountedPrice),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: _maroon,
                                                ),
                                              ),
                                              if (isPro && discount > 0)
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 4),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        size: 14,
                                                        color: Colors.amber,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Pro Price',
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontSize: 12,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...(planData['features'] as List<String>).map(
                                    (feature) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Icon(
                                              Icons.check_circle,
                                              size: 18,
                                              color: _maroon, // Maroon Icon
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              feature,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: _maroon.withOpacity(0.8),
                                              ),
                                            ),
                                          ),
                                        ],
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
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String planName,
    Map<String, dynamic> planData,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _pistachio, // Pistachio Dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm Booking',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _maroon, // Maroon Text
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vendor: ${vendor.name}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _maroon,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Plan: $planName',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _maroon,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${_formatPrice((planData['price'] as num).toDouble())}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _maroon,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to proceed with this booking?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _maroon.withOpacity(0.8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: _maroon.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Save booking to provider
              final provider = Provider.of<WeddingProvider>(
                context,
                listen: false,
              );
              provider.bookVendor(
                vendor,
                planName,
                (planData['price'] as num).toDouble(),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${vendor.name} ($planName Plan) booking request sent!',
                    style: TextStyle(color: _maroon),
                  ),
                  backgroundColor: _pistachio,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _maroon, // Maroon Button
              foregroundColor: _pistachio, // Pistachio Text
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
