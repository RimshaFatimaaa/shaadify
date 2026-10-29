import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/wedding_provider.dart';
import '../providers/language_provider.dart';
import 'auth_screen.dart';
import 'saved_screen.dart';
import 'booked_vendors_screen.dart';
import 'pro_plan_screen.dart';
import 'wedding_visualization_screen.dart';
import 'report_vendor_screen.dart';
import 'vendor_reports_screen.dart';
import '../models/vendor_report.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userLocation = 'Lahore, Pakistan';
  bool _notificationsEnabled = true;

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
                    .white, // Fallback to white so maroon text/elements pop
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Container(
                color: Colors.white.withOpacity(
                  0.3,
                ), // Light tint to make Maroon elements pop
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 80, // Account for bottom nav bar
            ),
            child: Column(
              children: [
                // Profile Header (Transparent)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  // Decoration removed to make card transparent
                  child: Consumer<WeddingProvider>(
                    builder: (context, provider, child) {
                      final userName = provider.userName.isNotEmpty
                          ? provider.userName
                          : 'User Name';
                      final userEmail = provider.userEmail.isNotEmpty
                          ? provider.userEmail
                          : 'user@example.com';

                      return SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: _maroon, // Maroon Circle
                              child: Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.poppins(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _pistachio, // Pistachio Text
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              userName,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _maroon, // Maroon Text
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _maroon.withOpacity(0.7), // Maroon Text
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _showEditProfileDialog(
                                context,
                                userName,
                                userEmail,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _maroon, // Maroon Button
                                foregroundColor: _pistachio, // Pistachio Text
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.editProfile,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Statistics Section
                Consumer<WeddingProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.favorite,
                              label: AppLocalizations.of(context)!.saved,
                              value: '${provider.savedVendors.length}',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SavedScreen(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              context,
                              icon: Icons.store,
                              label: AppLocalizations.of(context)!.cart,
                              value: '${provider.bookedVendors.length}',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BookedVendorsScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Settings Section (Card Style)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _maroon, // Maroon Background
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
                    children: [
                      _buildSettingsItem(
                        context,
                        icon: Icons.location_on_outlined,
                        title: AppLocalizations.of(context)!.location,
                        subtitle: _userLocation,
                        onTap: () => _showLocationDialog(context),
                      ),
                      _buildSettingsItem(
                        context,
                        icon: Icons.notifications_outlined,
                        title: AppLocalizations.of(context)!.notifications,
                        subtitle: _notificationsEnabled
                            ? 'Enabled'
                            : 'Disabled',
                        onTap: () => setState(
                          () => _notificationsEnabled = !_notificationsEnabled,
                        ),
                      ),
                      Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) =>
                            _buildSettingsItem(
                              context,
                              icon: Icons.language,
                              title: AppLocalizations.of(context)!.language,
                              subtitle: languageProvider.getLanguageName(
                                languageProvider.locale.languageCode,
                              ),
                              onTap: () => _showLanguageDialog(context),
                            ),
                      ),
                      _buildSettingsItem(
                        context,
                        icon: Icons.help_outline,
                        title: AppLocalizations.of(context)!.helpSupport,
                        onTap: () => _showHelpDialog(context),
                      ),
                      Consumer<WeddingProvider>(
                        builder: (context, provider, child) {
                          final reportsCount = provider.vendorReports.length;
                          return _buildSettingsItem(
                            context,
                            icon: Icons.flag_outlined,
                            title: 'Previous Reports',
                            subtitle: reportsCount > 0
                                ? '$reportsCount ${reportsCount == 1 ? 'report' : 'reports'}'
                                : 'No reports yet',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VendorReportsScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      Consumer<WeddingProvider>(
                        builder: (context, provider, child) =>
                            _buildSettingsItem(
                              context,
                              icon: provider.isProUser
                                  ? Icons.star
                                  : Icons.star_outline,
                              title: provider.isProUser
                                  ? 'Pro Plan'
                                  : 'Upgrade to Pro',
                              subtitle: provider.isProUser
                                  ? 'Active'
                                  : 'Unlock premium features',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProPlanScreen(),
                                ),
                              ),
                            ),
                      ),
                      Consumer<WeddingProvider>(
                        builder: (context, provider, child) {
                          if (provider.isProUser) {
                            return _buildSettingsItem(
                              context,
                              icon: Icons.visibility,
                              title: 'Wedding Visualization',
                              subtitle: 'View your wedding',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WeddingVisualizationScreen(),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      _buildSettingsItem(
                        context,
                        icon: Icons.info_outline,
                        title: AppLocalizations.of(context)!.about,
                        onTap: () => _showAboutDialog(context),
                      ),
                      _buildSettingsItem(
                        context,
                        icon: Icons.logout,
                        title: AppLocalizations.of(context)!.logout,
                        onTap: () => _showLogoutDialog(context),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _maroon, // Maroon Background
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
          children: [
            Icon(icon, size: 32, color: _pistachio), // Pistachio Icon
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _pistachio, // Pistachio Text
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _pistachio.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: _pistachio), // Pistachio Icon
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: _pistachio, // Pistachio Text
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _pistachio.withOpacity(0.6),
                  ),
                )
              : null,
          trailing: Icon(Icons.chevron_right, color: _pistachio),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: _pistachio.withOpacity(0.2), // Pistachio Divider
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  // --- DIALOGS (Themed) ---

  void _showLocationDialog(BuildContext context) {
    String selectedCity = _userLocation.split(', ').first;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _maroon, // Maroon Background
          title: Text(
            'Select Location',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: _pistachio, // Pistachio Text
            ),
          ),
          content: DropdownButtonFormField<String>(
            dropdownColor: _maroon,
            value: AppConstants.pakistaniCities.contains(selectedCity)
                ? selectedCity
                : AppConstants.pakistaniCities.first,
            style: TextStyle(color: _pistachio),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.city,
              labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _pistachio),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _pistachio, width: 2),
              ),
            ),
            items: AppConstants.pakistaniCities
                .map(
                  (city) => DropdownMenuItem(
                    value: city,
                    child: Text(city, style: TextStyle(color: _pistachio)),
                  ),
                )
                .toList(),
            onChanged: (val) => setDialogState(() => selectedCity = val!),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: _pistachio.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _userLocation = '$selectedCity, Pakistan');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _pistachio,
                foregroundColor: _maroon,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    String currentName,
    String currentEmail,
  ) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _maroon, // Maroon Background
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: _pistachio, // Pistachio Text
          ),
        ),
        content: TextField(
          controller: nameController,
          style: TextStyle(color: _pistachio),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.name,
            labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _pistachio),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _pistachio, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: _pistachio.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<WeddingProvider>(
                context,
                listen: false,
              ).updateUserName(nameController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _pistachio,
              foregroundColor: _maroon,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    String selectedCode = languageProvider.locale.languageCode;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: _maroon, // Maroon Background
          title: Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: TextStyle(color: _pistachio, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageProvider.supportedLanguages.map((lang) {
              return RadioListTile<String>(
                title: Text(lang['name']!, style: TextStyle(color: _pistachio)),
                value: lang['code']!,
                groupValue: selectedCode,
                activeColor: _pistachio,
                onChanged: (val) => setDialogState(() => selectedCode = val!),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: _pistachio.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                languageProvider.setLocale(Locale(selectedCode));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _pistachio,
                foregroundColor: _maroon,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _maroon, // Maroon Background
        title: Text(
          'Logout',
          style: TextStyle(color: _pistachio, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: _pistachio),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: _pistachio.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
            ),
            child: Text(
              'Logout',
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _maroon, // Maroon Background
        title: Text(
          'Help & Support',
          style: TextStyle(color: _pistachio, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Contact us at support@shaadify.com for any queries.',
          style: TextStyle(color: _pistachio),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _pistachio,
              foregroundColor: _maroon,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _maroon, // Maroon Background
        title: Text(
          'About',
          style: TextStyle(color: _pistachio, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Shaadify v1.0.0 - Your personal wedding planning assistant.',
          style: TextStyle(color: _pistachio),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _pistachio,
              foregroundColor: _maroon,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

}
