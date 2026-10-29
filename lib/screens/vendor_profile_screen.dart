import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/wedding_provider.dart';
import '../l10n/app_localizations.dart';
import 'notifications_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  final String? vendorCategory;

  const VendorProfileScreen({super.key, this.vendorCategory});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  String? _selectedCity;
  String? _selectedVendorCategory;
  final bool _isVerified = false;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    _selectedVendorCategory = widget.vendorCategory;
    // Load business name, owner name, location, and email from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WeddingProvider>(context, listen: false);
      if (provider.vendorBusinessName.isNotEmpty) {
        _businessNameController.text = provider.vendorBusinessName;
      }
      if (provider.vendorOwnerName.isNotEmpty) {
        _ownerNameController.text = provider.vendorOwnerName;
      }
      if (provider.vendorBusinessLocation.isNotEmpty) {
        setState(() {
          _selectedCity = provider.vendorBusinessLocation;
        });
      }
      if (provider.userEmail.isNotEmpty) {
        _emailController.text = provider.userEmail;
      }
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

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
          l10n.businessProfile,
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Extra bottom padding for bottom nav bar
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

                  // Business Name (read-only, set during signup)
              TextFormField(
                    initialValue: widget.vendorCategory ?? AppLocalizations.of(context)!.notSet,
                    enabled: false,
                    style: TextStyle(color: _pistachio), // Pistachio Text
                decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.vendorType,
                      labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
                  filled: true,
                      fillColor: _maroon.withOpacity(
                        0.8,
                      ), // Maroon Input (Dimmed for disabled)
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _pistachio),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _pistachio.withOpacity(0.3),
                        ),
                      ),
                      prefixIcon: Icon(Icons.category, color: _pistachio),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business Name
                  _buildThemedTextField(
                    controller: _businessNameController,
                    label: 'Business Name *',
                    icon: Icons.business,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter business name'
                        : null,
              ),
              const SizedBox(height: 16),

              // Owner Name
                  _buildThemedTextField(
                controller: _ownerNameController,
                    label: 'Owner Name *',
                    icon: Icons.person,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter owner name'
                        : null,
              ),
              const SizedBox(height: 16),

              // Phone
                  _buildThemedTextField(
                controller: _phoneController,
                    label: 'Phone Number *',
                    icon: Icons.phone,
                keyboardType: TextInputType.phone,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please enter phone number'
                        : null,
              ),
              const SizedBox(height: 16),

                  // Email (read-only, from login)
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                    enabled: false, // Email is read-only
                    style: TextStyle(color: _pistachio),
                decoration: InputDecoration(
                  labelText: '${l10n.email} *',
                      labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
                  filled: true,
                      fillColor: _maroon.withOpacity(0.8), // Dimmed Maroon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _pistachio),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _pistachio.withOpacity(0.3),
                        ),
                  ),
                      prefixIcon: Icon(Icons.email, color: _pistachio),
                    ),
              ),
              const SizedBox(height: 16),

              // City
              DropdownButtonFormField<String>(
                    initialValue: _selectedCity,
                    dropdownColor: _maroon, // Maroon Dropdown
                    style: TextStyle(color: _pistachio), // Pistachio Text
                decoration: InputDecoration(
                  labelText: 'City *',
                      labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
                  filled: true,
                      fillColor: _maroon, // Maroon Input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _pistachio),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _pistachio.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _pistachio, width: 2),
                  ),
                      prefixIcon: Icon(Icons.location_city, color: _pistachio),
                ),
                items: AppConstants.pakistaniCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseSelectCity;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
                  _buildThemedTextField(
                controller: _addressController,
                    label: '${l10n.location} *',
                    icon: Icons.location_on,
                maxLines: 2,
                    validator: (value) => (value == null || value.isEmpty)
                        ? l10n.pleaseEnterBusinessAddress
                        : null,
              ),
              const SizedBox(height: 16),

              // Website (optional)
                  _buildThemedTextField(
                controller: _websiteController,
                    label: 'Website (optional)',
                    icon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Description
                  _buildThemedTextField(
                controller: _descriptionController,
                    label: '${l10n.packageDescription} *',
                    icon: null, // No icon for description to align with top
                maxLines: 4,
                    validator: (value) => (value == null || value.isEmpty)
                        ? l10n.pleaseEnterBusinessDescription
                        : null,
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                      onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                          // Update business name in provider if it changed
                          final provider = Provider.of<WeddingProvider>(
                            context,
                            listen: false,
                          );
                          final newBusinessName = _businessNameController.text
                              .trim();
                          final newOwnerName = _ownerNameController.text.trim();
                          final newLocation = _selectedCity ?? '';
                          
                          if (newBusinessName.isNotEmpty &&
                              newBusinessName != provider.vendorBusinessName) {
                            await provider.setVendorInfo(
                              newBusinessName,
                              provider.vendorCategory,
                            );
                          }
                          
                          // Update owner name and location if changed
                          if (newOwnerName != provider.vendorOwnerName ||
                              newLocation != provider.vendorBusinessLocation) {
                            await provider.setVendorOwnerAndLocation(
                              newOwnerName.isNotEmpty ? newOwnerName : provider.vendorOwnerName,
                              newLocation.isNotEmpty ? newLocation : provider.vendorBusinessLocation,
                            );
                          }

                      ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Profile saved successfully!',
                                style: TextStyle(color: _maroon),
                              ),
                              backgroundColor: _pistachio,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _maroon, // Maroon Button
                        foregroundColor: _pistachio, // Pistachio Text
                        side: BorderSide(color: _pistachio), // Border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.saveProfile,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
            ), // Close SafeArea
          ),
        ],
      ),
    );
  }

  Widget _buildThemedTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: _pistachio), // Pistachio Text
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: _maroon, // Maroon Input Background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _pistachio),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _pistachio.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _pistachio, width: 2),
        ),
        prefixIcon: icon != null ? Icon(icon, color: _pistachio) : null,
      ),
      validator: validator,
    );
  }
}
