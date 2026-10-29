import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../models/vendor_lead.dart';
import '../l10n/app_localizations.dart';

class QRCodeScreen extends StatelessWidget {
  final VendorLead lead;
  final bool isVendorView;

  const QRCodeScreen({
    super.key,
    required this.lead,
    this.isVendorView = false,
  });

  // THEME COLORS
  static const Color _maroon = Color(0xFF600000);
  static const Color _pistachio = Color(0xFFD7E8CD);

  String _generateQRData() {
    // Generate QR code data with booking information
    final buffer = StringBuffer();
    buffer.write('{');
    buffer.write('"bookingId":"${lead.id}",');
    buffer.write('"clientName":"${lead.clientName}",');
    buffer.write('"eventType":"${lead.eventType}",');
    buffer.write('"eventDate":"${lead.eventDate}",');
    buffer.write('"packageName":"${lead.packageName}",');
    buffer.write('"location":"${lead.location}",');
    buffer.write('"status":"${lead.status.name}",');
    buffer.write('"timestamp":"${DateTime.now().toIso8601String()}"');
    buffer.write('}');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weddingProvider = Provider.of<WeddingProvider>(context);
    final vendorName = weddingProvider.vendorBusinessName.isNotEmpty
        ? weddingProvider.vendorBusinessName
        : 'Venue Vendor';
    
    final qrData = _generateQRData();

    return Scaffold(
      backgroundColor: _maroon,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.qrCode,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _maroon,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: _maroon),
      ),
      body: Stack(
        children: [
          // Background Image Layer
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

          // Content Layer
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // QR Code Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // QR Code
                        QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 250.0,
                          backgroundColor: Colors.white,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                        ),
                        const SizedBox(height: 24),
                        // Booking Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _pistachio.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(l10n.vendor, vendorName),
                              const SizedBox(height: 8),
                              _buildInfoRow(l10n.client, lead.clientName),
                              const SizedBox(height: 8),
                              _buildInfoRow(l10n.event, lead.eventType),
                              const SizedBox(height: 8),
                              _buildInfoRow(l10n.date, lead.eventDate),
                              const SizedBox(height: 8),
                              _buildInfoRow(l10n.package, lead.packageName),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _maroon,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: _pistachio,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Scan this QR code for venue\'s pin location and other details',
                          style: GoogleFonts.poppins(
                            color: _pistachio,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Download/Share Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.qrCodeSaved),
                            backgroundColor: _pistachio,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.download),
                      label: Text(
                        l10n.saveQRCode,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _maroon,
                        foregroundColor: _pistachio,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: _pistachio, width: 2),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _maroon,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: _maroon.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
