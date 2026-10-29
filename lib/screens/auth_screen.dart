import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/wedding_provider.dart';
import 'home_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_subscription_screen.dart';

enum UserType { user, vendor }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  UserType _userType = UserType.user;
  String? _selectedVendorCategory;
  String? _selectedCity;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WeddingProvider>(context, listen: false);
      if (provider.vendorBusinessName.isNotEmpty) {
        _businessNameController.text = provider.vendorBusinessName;
      }
      if (provider.vendorCategory.isNotEmpty) {
        _selectedVendorCategory = provider.vendorCategory;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _businessNameController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // For vendor signup, check all required fields and subscription
    if (_userType == UserType.vendor && !_isLogin) {
      if (_businessNameController.text.isEmpty ||
          _selectedVendorCategory == null ||
          _ownerNameController.text.isEmpty ||
          _selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Please fill all required fields (Business Name, Vendor Type, Owner Name, Business Location)',
            ),
            backgroundColor: _maroon,
          ),
        );
        return;
      }

      // Check if vendor has active subscription (only for signup)
      final provider = Provider.of<WeddingProvider>(context, listen: false);
      if (!provider.isVendorSubscribed) {
        // Show subscription required dialog
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Subscription Required',
                style: GoogleFonts.poppins(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                'You need to subscribe to register your business on our platform. Please choose a subscription plan to continue.',
                style: GoogleFonts.poppins(color: _maroon),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VendorSubscriptionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _maroon,
                    foregroundColor: _pistachio,
                  ),
                  child: Text(
                    'Subscribe Now',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }
        return;
      }
    }

    // For vendor login, only check owner name, email, password
    // Subscription will be loaded from storage and shown on menu page
    if (_userType == UserType.vendor && _isLogin) {
      if (_ownerNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter owner name'),
            backgroundColor: _maroon,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) {
      final provider = Provider.of<WeddingProvider>(context, listen: false);
      if (_userType == UserType.user) {
        final userName = _isLogin
            ? _emailController.text.split('@').first
            : _nameController.text;
        provider.setUserInfo(userName, _emailController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Vendor login or signup
        if (_isLogin) {
          // For login, set owner name and email
          // Subscription will be loaded from storage automatically
          provider.setUserInfo(
            _ownerNameController.text.trim(),
            _emailController.text,
          );
          // Load existing vendor info if available
          await provider.setVendorOwnerAndLocation(
            _ownerNameController.text.trim(),
            '', // Keep existing location if any
          );
          // Reload subscription from storage to ensure it's displayed on menu
          await provider.loadVendorSubscription();
          // Ensure vendor has an active subscription when logging in
          await provider.ensureVendorHasActiveSubscription();
        } else {
          // For signup, set all vendor info (subscription already checked)
          await provider.setVendorInfo(
            _businessNameController.text.trim(),
            _selectedVendorCategory ?? '',
          );
          await provider.setVendorOwnerAndLocation(
            _ownerNameController.text.trim(),
            _selectedCity ?? '',
          );
          provider.setUserInfo(
            _businessNameController.text.trim(),
            _emailController.text,
          );
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDashboardScreen(
                vendorCategory: _selectedVendorCategory ?? 'Other',
              ),
            ),
          );
        }
      }
    }
  }

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
                color: Colors.white, // Fallback if image fails so text is visible
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Added blur
              child: Container(
                color: Colors.white.withValues(alpha: 0.3), // Light tint to make Maroon text pop
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'SHAADIFY',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _maroon, // Maroon Text outside
                          ),
                        ),
                        Text(
                          'PAKISTAN EDITION',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: _maroon.withOpacity(
                              0.7,
                            ), // Maroon Text outside
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Form Content with Hero Image
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Hero Image Section
                        Container(
                          height: 250,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/login.jpeg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: _maroon,
                                      child: const Icon(
                                        Icons.image,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.6),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      'Your Dream Wedding Awaits',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Keep white for visibility on image
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Form Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isLogin ? 'Log In' : 'Sign Up',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _maroon, // Maroon Text outside
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // User Type Selection
                                Text(
                                  'I am a:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _maroon, // Maroon Text outside
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildUserTypeOption(
                                        'User',
                                        UserType.user,
                                        Icons.person,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildUserTypeOption(
                                        'Vendor',
                                        UserType.vendor,
                                        Icons.store,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Dynamic Input Fields
                                if (_userType == UserType.vendor) ...[
                                  // For vendor login: only owner name, email, password
                                  // For vendor signup: all fields including business name, category, city
                                  if (_isLogin) ...[
                                    // Login: Only owner name
                                    _buildTextField(
                                      _ownerNameController,
                                      'Owner Name *',
                                      Icons.person,
                                    ),
                                    const SizedBox(height: 16),
                                  ] else ...[
                                    // Signup: All fields
                                    _buildTextField(
                                      _businessNameController,
                                      'Business Name *',
                                      Icons.business,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDropdownField(),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      _ownerNameController,
                                      'Owner Name *',
                                      Icons.person,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCityDropdownField(),
                                    const SizedBox(height: 16),
                                  ],
                                ] else if (!_isLogin) ...[
                                  _buildTextField(
                                    _nameController,
                                    'Full Name',
                                    Icons.person_outline,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                _buildTextField(
                                  _emailController,
                                  'Email',
                                  Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  _passwordController,
                                  'Password',
                                  Icons.lock,
                                  isPassword: true,
                                ),
                                const SizedBox(height: 12),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.poppins(
                                        color: _maroon, // Maroon Text outside
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Main Action Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleAuth,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      backgroundColor:
                                          _maroon, // Maroon Card (Button)
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: _pistachio,
                                          )
                                        : Text(
                                            _isLogin ? 'Log In' : 'Sign Up',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  _pistachio, // Pistachio Text inside
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Center(
                                  child: TextButton(
                                    onPressed: () =>
                                        setState(() => _isLogin = !_isLogin),
                                    child: Text(
                                      _isLogin
                                          ? "Don't have an account? Sign Up →"
                                          : 'Already have an account? Log In →',
                                      style: GoogleFonts.poppins(
                                        color: _maroon, // Maroon Text outside
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
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
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && _obscurePassword,
      keyboardType: keyboardType,
      style: TextStyle(color: _pistachio), // Pistachio Text inside
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: _pistachio.withValues(alpha: 0.7),
        ), // Pistachio Label
        filled: true,
        fillColor: _maroon, // Maroon Card Background
        prefixIcon: Icon(icon, color: _pistachio), // Pistachio Icon
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: _pistachio,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedVendorCategory,
      dropdownColor: _maroon, // Maroon Dropdown Menu
      style: TextStyle(color: _pistachio), // Pistachio Text
      decoration: InputDecoration(
        labelText: 'Vendor Type *',
        labelStyle: TextStyle(color: _pistachio), // Pistachio Label
        filled: true,
        fillColor: _maroon, // Maroon Card Background
        prefixIcon: Icon(Icons.category, color: _pistachio), // Pistachio Icon
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: AppConstants.itemCategories
          .map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedVendorCategory = value),
      validator: (value) => (value == null) ? 'Required' : null,
    );
  }

  Widget _buildCityDropdownField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCity,
      dropdownColor: _maroon, // Maroon Dropdown Menu
      style: TextStyle(color: _pistachio), // Pistachio Text
      decoration: InputDecoration(
        labelText: 'Business Location *',
        labelStyle: TextStyle(color: _pistachio), // Pistachio Label
        filled: true,
        fillColor: _maroon, // Maroon Card Background
        prefixIcon: Icon(Icons.location_on, color: _pistachio), // Pistachio Icon
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: AppConstants.pakistaniCities
          .map(
            (city) =>
                DropdownMenuItem(value: city, child: Text(city)),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedCity = value),
      validator: (value) => (value == null) ? 'Required' : null,
    );
  }

  Widget _buildUserTypeOption(String label, UserType type, IconData icon) {
    final isSelected = _userType == type;
    return InkWell(
      onTap: () => setState(() {
        _userType = type;
        if (type == UserType.user) {
          _selectedVendorCategory = null;
          _selectedCity = null;
          _businessNameController.clear();
          _ownerNameController.clear();
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _maroon
              : Colors.transparent, // Highlight with Maroon
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _maroon, width: 2), // Maroon Border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? _pistachio : _maroon, // Icon Color logic
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? _pistachio : _maroon, // Text Color logic
              ),
            ),
          ],
        ),
      ),
    );
  }
}
