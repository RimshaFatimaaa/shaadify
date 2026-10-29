import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import 'notifications_screen.dart';

class VendorHelpSupportScreen extends StatelessWidget {
  const VendorHelpSupportScreen({super.key});

  // THEME COLORS
  static const Color _maroon = Color(0xFF600000);
  static const Color _pistachio = Color(0xFFD7E8CD);

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@shaadify.com',
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+923001234567');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _maroon,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.helpSupport,
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Section
                  Text(
                    l10n.contactUs,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _maroon,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    icon: Icons.email,
                    title: l10n.emailSupport,
                    subtitle: 'support@shaadify.com',
                    onTap: _launchEmail,
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    icon: Icons.phone,
                    title: l10n.phoneSupport,
                    subtitle: '+92 300 1234567',
                    onTap: _launchPhone,
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    icon: Icons.access_time,
                    title: l10n.businessHours,
                    subtitle: 'Mon-Fri, 9 AM - 6 PM',
                    onTap: null,
                  ),
                  const SizedBox(height: 24),

                  // FAQ Section
                  Text(
                    l10n.frequentlyAskedQuestions,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _maroon,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFAQCard(
                    question: l10n.howToUpdateBusinessProfile,
                    answer: l10n.howToUpdateBusinessProfileAnswer,
                  ),
                  const SizedBox(height: 12),
                  _buildFAQCard(
                    question: l10n.howToManagePackages,
                    answer: l10n.howToManagePackagesAnswer,
                  ),
                  const SizedBox(height: 12),
                  _buildFAQCard(
                    question: l10n.howToAcceptBookingRequests,
                    answer: l10n.howToAcceptBookingRequestsAnswer,
                  ),
                  const SizedBox(height: 12),
                  _buildFAQCard(
                    question: l10n.howToViewAnalytics,
                    answer: l10n.howToViewAnalyticsAnswer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _maroon,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: _pistachio, size: 28),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: _pistachio,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            color: _pistachio.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: onTap != null
            ? Icon(Icons.chevron_right, color: _pistachio.withOpacity(0.5))
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQCard({
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _maroon,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.poppins(
            color: _pistachio,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: _pistachio,
        collapsedIconColor: _pistachio.withOpacity(0.7),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: GoogleFonts.poppins(
                color: _pistachio.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
