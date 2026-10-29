import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../models/vendor_booking.dart';
import 'pro_plan_screen.dart';

class WeddingVisualizationScreen extends StatefulWidget {
  const WeddingVisualizationScreen({super.key});

  @override
  State<WeddingVisualizationScreen> createState() =>
      _WeddingVisualizationScreenState();
}

class _WeddingVisualizationScreenState
    extends State<WeddingVisualizationScreen> {
  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon,
      appBar: AppBar(
        backgroundColor: _maroon,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _pistachio),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wedding Visualization',
          style: GoogleFonts.poppins(
            color: _pistachio,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Consumer<WeddingProvider>(
              builder: (context, provider, child) {
                if (!provider.isProUser) {
                  return _buildProRequiredView(context);
                }

                final confirmedBookings = provider.bookedVendors
                    .where((b) => b.status == 'confirmed')
                    .toList();

                if (confirmedBookings.isEmpty) {
                  return _buildEmptyState();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Wedding Visualization',
                        style: GoogleFonts.poppins(
                          color: _maroon,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'See how your selected vendors come together',
                        style: GoogleFonts.poppins(
                          color: _maroon.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Visualization Cards
                      ...confirmedBookings.map((booking) =>
                          _buildVendorCard(booking)),
                      const SizedBox(height: 24),
                      // Summary Card
                      _buildSummaryCard(confirmedBookings),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProRequiredView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: _pistachio,
            ),
            const SizedBox(height: 24),
            Text(
              'Pro Feature',
              style: GoogleFonts.poppins(
                color: _maroon,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Wedding Visualization is available for Pro members only',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: _maroon.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProPlanScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _maroon,
                  foregroundColor: _pistachio,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Upgrade to Pro',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 80,
            color: _pistachio,
          ),
          const SizedBox(height: 24),
          Text(
            'No Confirmed Vendors',
            style: GoogleFonts.poppins(
              color: _maroon,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Confirm some vendors to visualize your wedding',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: _maroon.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(VendorBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Vendor Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _maroon,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                booking.vendor.name[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  color: _pistachio,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Vendor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.vendor.name,
                  style: GoogleFonts.poppins(
                    color: _maroon,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.vendor.category,
                  style: GoogleFonts.poppins(
                    color: _maroon.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.planName,
                  style: GoogleFonts.poppins(
                    color: _pistachio,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _pistachio,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'CONFIRMED',
              style: GoogleFonts.poppins(
                color: _maroon,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<VendorBooking> bookings) {
    final totalPrice = bookings.fold<double>(
      0.0,
      (sum, booking) => sum + booking.price,
    );
    final categories = bookings.map((b) => b.vendor.category).toSet().length;

    return Container(
      decoration: BoxDecoration(
        color: _pistachio,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wedding Summary',
            style: GoogleFonts.poppins(
              color: _maroon,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Total Vendors', '${bookings.length}'),
          _buildSummaryRow('Categories', '$categories'),
          _buildSummaryRow(
            'Estimated Budget',
            'Rs. ${(totalPrice / 1000).toStringAsFixed(1)}K',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: _maroon.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: _maroon,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
