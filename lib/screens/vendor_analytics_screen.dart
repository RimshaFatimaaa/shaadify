import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/price_formatter.dart';
import '../l10n/app_localizations.dart';
import 'notifications_screen.dart';

class VendorAnalyticsScreen extends StatefulWidget {
  final String? vendorCategory;

  const VendorAnalyticsScreen({super.key, this.vendorCategory});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.vendorAnalytics,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _maroon,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: _maroon,
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
            child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              l10n.analyticsInsights,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                      color: _maroon, // Maroon Text (Outside)
              ),
            ),
            const SizedBox(height: 8),
            Text(
                    widget.vendorCategory != null
                        ? l10n.trackBusinessPerformanceCategory(widget.vendorCategory!)
                        : l10n.trackBusinessPerformanceGeneric,
              style: GoogleFonts.poppins(
                fontSize: 14,
                      color: _maroon.withOpacity(0.7), // Maroon Text (Outside)
              ),
            ),
            const SizedBox(height: 24),

            // Overview Cards
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    l10n.totalViews,
                    '0',
                    Icons.visibility,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalyticsCard(
                    l10n.inquiries,
                    '0',
                    Icons.inbox,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsCard(
                    l10n.bookings,
                    '0',
                    Icons.book_online,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalyticsCard(
                    l10n.revenue,
                    PriceFormatter.formatCompact(0),
                    Icons.currency_rupee,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rating Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                      color: _maroon, // Maroon Card
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating Overview',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                            color: _pistachio, // Pistachio Text
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '4.5',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                                color: _pistachio, // Pistachio Text
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                      index < 4
                                          ? Icons.star
                                          : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '0 ${l10n.reviews}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                                    color: _pistachio.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Activity
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                      color: _maroon, // Maroon Card
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.recentActivity,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                            color: _pistachio, // Pistachio Text
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.timeline,
                            size: 48,
                                  color: _pistachio.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noActivityYet,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                                    color: _pistachio,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.recentActivityWillAppear,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                                    color: _pistachio.withOpacity(0.7),
                            ),
                          ),
                        ],
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

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _maroon, // Maroon Card
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24), // Keep distinctive metric colors
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _pistachio, // Pistachio Text
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _pistachio.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
