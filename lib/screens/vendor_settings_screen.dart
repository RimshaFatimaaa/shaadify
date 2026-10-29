import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import 'notifications_screen.dart';

class VendorSettingsScreen extends StatefulWidget {
  const VendorSettingsScreen({super.key});

  @override
  State<VendorSettingsScreen> createState() => _VendorSettingsScreenState();
}

class _VendorSettingsScreenState extends State<VendorSettingsScreen> {
  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.settings,
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
                  // Notification Settings Section
                  _buildSectionTitle('Notifications'),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          'Enable Notifications',
                          _notificationsEnabled,
                          (value) {
                            setState(() {
                              _notificationsEnabled = value;
                              if (!value) {
                                _emailNotifications = false;
                                _pushNotifications = false;
                              }
                            });
                          },
                        ),
                        if (_notificationsEnabled) ...[
                          const Divider(height: 1),
                          _buildSwitchTile(
                            'Email Notifications',
                            _emailNotifications,
                            (value) {
                              setState(() {
                                _emailNotifications = value;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          _buildSwitchTile(
                            'Push Notifications',
                            _pushNotifications,
                            (value) {
                              setState(() {
                                _pushNotifications = value;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Settings Section
                  _buildSectionTitle('Account'),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    child: Column(
                      children: [
                        _buildListTile(
                          'Change Password',
                          Icons.lock_outline,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Password change feature coming soon!'),
                                backgroundColor: _pistachio,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildListTile(
                          'Privacy Settings',
                          Icons.privacy_tip_outlined,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Privacy settings coming soon!'),
                                backgroundColor: _pistachio,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // App Settings Section
                  _buildSectionTitle('App'),
                  const SizedBox(height: 12),
                  _buildSettingsCard(
                    child: Column(
                      children: [
                        Consumer<LanguageProvider>(
                          builder: (context, languageProvider, child) =>
                              _buildListTile(
                                AppLocalizations.of(context)!.language,
                                Icons.language,
                                () => _showLanguageDialog(context),
                                subtitle: languageProvider.getLanguageName(
                                  languageProvider.locale.languageCode,
                                ),
                              ),
                        ),
                        const Divider(height: 1),
                        _buildListTile(
                          'About',
                          Icons.info_outline,
                          () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'About Shaadify',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: _maroon,
                                  ),
                                ),
                                content: Text(
                                  'Shaadify - Pakistan Edition\n\nVersion 1.0.0\n\nYour one-stop solution for wedding planning.',
                                  style: GoogleFonts.poppins(),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _maroon,
                                      foregroundColor: _pistachio,
                                    ),
                                    child: Text('Close', style: GoogleFonts.poppins()),
                                  ),
                                ],
                              ),
                            );
                          },
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _maroon,
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
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
      child: child,
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: _pistachio,
          fontSize: 16,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: _pistachio,
        activeTrackColor: _pistachio.withOpacity(0.5),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: _pistachio),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: _pistachio,
          fontSize: 16,
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
      trailing: Icon(Icons.chevron_right, color: _pistachio.withOpacity(0.5)),
      onTap: onTap,
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
            style: GoogleFonts.poppins(
              color: _pistachio,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageProvider.supportedLanguages.map((lang) {
              return RadioListTile<String>(
                title: Text(
                  lang['name']!,
                  style: GoogleFonts.poppins(color: _pistachio),
                ),
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
                style: GoogleFonts.poppins(
                  color: _pistachio.withOpacity(0.6),
                ),
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
              child: Text(
                'Save',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
