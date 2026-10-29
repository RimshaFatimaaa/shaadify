import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/wedding_provider.dart';
import '../models/subscription_plan.dart';
import 'vendor_profile_screen.dart';
import 'vendor_packages_screen.dart';
import 'vendor_leads_screen.dart';
import 'vendor_analytics_screen.dart';
import 'vendor_settings_screen.dart';
import 'vendor_help_support_screen.dart';
import 'vendor_subscription_screen.dart';
import 'auth_screen.dart';
import 'notifications_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  final String vendorCategory;

  const VendorDashboardScreen({super.key, required this.vendorCategory});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _selectedIndex = 0;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  void _onTabTapped(int index) {
    if (index >= 0 && index < 5) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _maroon, // Maroon Dialog
          title: Text(
            l10n.logout,
            style: TextStyle(color: _pistachio, fontWeight: FontWeight.bold),
            ),
          content: Text(
            l10n.logoutConfirmation,
            style: TextStyle(color: _pistachio),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: _pistachio.withOpacity(0.7)),
            ),
            ),
            TextButton(
            onPressed: () {
                Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
                );
              },
              child: Text(
                l10n.logout,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Only show AppBar for Dashboard (0) and Leads (1)
    // Other screens (Packages, Profile, Menu) have their own AppBars
    final bool showAppBar = _selectedIndex <= 1;
    
    return Scaffold(
      backgroundColor: _maroon, // Fallback background
      extendBodyBehindAppBar: showAppBar, // Allow body behind AppBar only when showing it
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.transparent, // Transparent for background image
              elevation: 0,
              title: Text(
                _selectedIndex == 0
                    ? l10n.shaadifyVendor
                    : l10n.leadsBookings,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _maroon, // Maroon Text (Outside)
                  letterSpacing: 0.5,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: _maroon, // Maroon Icon
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
            )
          : null,
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
            child: Consumer<WeddingProvider>(
              builder: (context, weddingProvider, child) {
                final businessName =
                    weddingProvider.vendorBusinessName.isNotEmpty
                    ? weddingProvider.vendorBusinessName
                    : 'Your Business';

                return IndexedStack(
        index: _selectedIndex,
        children: [
                    _buildDashboardHome(businessName),
                    VendorLeadsScreen(vendorCategory: widget.vendorCategory),
                    VendorPackagesScreen(vendorCategory: widget.vendorCategory),
          VendorProfileScreen(vendorCategory: widget.vendorCategory),
                    _buildMenuScreen(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: _maroon, // Maroon Background
        selectedItemColor: _pistachio, // Pistachio Selected
        unselectedItemColor: _pistachio.withOpacity(0.5), // Dimmed Pistachio
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: l10n.vendorDashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            label: l10n.leadsBookings.split(' & ')[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory),
            label: l10n.packages,
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.store), label: l10n.businessProfile),
          BottomNavigationBarItem(icon: const Icon(Icons.menu), label: l10n.menu),
        ],
      ),
    );
  }

  Widget _buildDashboardHome(String businessName) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card with background image
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: _maroon, // Maroon Background
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image placeholder
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_maroon, _maroon.withOpacity(0.8)],
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/login.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: _maroon);
                      },
                    ),
                  ),
                  // Dark overlay
                  Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                ],
              ),
                    ),
            ),
                  // Welcome text
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      'Welcome back, $businessName!',
                  style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _pistachio, // Pistachio Text inside Image Card
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                  ),
                ),
              ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          Text(
            l10n.quickStats,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _maroon, // Maroon Text (Outside)
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  '12',
                  l10n.newLeadsThisWeek,
                  Icons.mail_outline,
                  Colors
                      .blue, // Keep generic color for icon differentiation or change to pistachio
                ),
              ),
              // Reduced width to prevent overflow
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickStatCard(
                  '450',
                  l10n.profileViews,
                  Icons.remove_red_eye,
                  Colors.green,
                ),
              ),
              // Reduced width to prevent overflow
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickStatCard(
                  'Rs 2.5L',
                  l10n.bookedViaApp,
                  Icons.account_balance_wallet,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Latest Activity
          Text(
            l10n.latestActivity,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _maroon, // Maroon Text (Outside)
            ),
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            l10n.newBookingRequest,
            l10n.view,
                () {
                  setState(() {
                _selectedIndex = 1; // Navigate to Leads
                  });
                },
              ),
          const SizedBox(height: 12),
          _buildActivityCard(
            l10n.packageTrending,
            l10n.renewNow,
                () {
                  setState(() {
                _selectedIndex = 2; // Navigate to Packages
                  });
                },
            showWarning: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    String value,
    String title,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      // Reduced padding to prevent overflow
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _maroon, // Maroon Card
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _pistachio.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flexible helps title shrink if icon is large
              Flexible(
                child: Text(
                  'Quick Stats',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: _pistachio.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          // FittedBox ensures large numbers don't break layout
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
                color: _pistachio, // Pistachio Text
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: _pistachio.withOpacity(0.7),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String message,
    String buttonText,
    VoidCallback onTap, {
    bool showWarning = false,
  }) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: _maroon, // Maroon Card
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
          Expanded(
            child: Row(
          children: [
                if (showWarning)
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 20,
            ),
                if (showWarning) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                      color: _pistachio, // Pistachio Text
                    ),
              ),
            ),
          ],
        ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: _pistachio, // Pistachio Button
              foregroundColor: _maroon, // Maroon Text on Button
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuScreen() {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by parent
      extendBodyBehindAppBar: false, // Changed to false to ensure AppBar is visible
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button since it's in IndexedStack
        title: Text(
          'Menu',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _maroon, // Maroon Text (Outside)
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80), // Reduced top padding since AppBar is visible
        children: [
          // Subscription Plan Section
          Consumer<WeddingProvider>(
            builder: (context, provider, child) {
              final subscription = provider.vendorSubscription;
              final isLoggedIn = provider.userName.isNotEmpty || provider.userEmail.isNotEmpty;
              return _buildSubscriptionCard(context, subscription, isLoggedIn);
            },
          ),
          const SizedBox(height: 8),
          // Monthly Subscription menu item (only show if user is logged in and has no active subscription)
          Consumer<WeddingProvider>(
            builder: (context, provider, child) {
              final isLoggedIn = provider.userName.isNotEmpty || provider.userEmail.isNotEmpty;
              final hasActiveSubscription = provider.vendorSubscription?.isActive ?? false;
              
              if (isLoggedIn && !hasActiveSubscription) {
                return Column(
                  children: [
                    _buildMenuItem(Icons.subscriptions, l10n.monthlyPlan, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VendorSubscriptionScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _buildMenuItem(Icons.analytics, l10n.vendorAnalytics, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VendorAnalyticsScreen(
                  vendorCategory: widget.vendorCategory,
                ),
              ),
            );
          }),
          _buildMenuItem(Icons.settings, l10n.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VendorSettingsScreen(),
              ),
            );
          }),
          _buildMenuItem(Icons.help_outline, l10n.helpSupport, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VendorHelpSupportScreen(),
              ),
            );
          }),
          _buildMenuItem(Icons.logout, l10n.logout, () {
            _showLogoutDialog(context);
          }, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, UserSubscription? subscription, bool isLoggedIn) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _pistachio,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _maroon.withOpacity(0.3),
          width: 1,
        ),
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
              Icon(Icons.star, color: _maroon, size: 24),
              const SizedBox(width: 8),
              Text(
                l10n.subscriptionPlan,
                style: GoogleFonts.poppins(
                  color: _maroon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (subscription != null && subscription.isActive) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.period == SubscriptionPeriod.monthly
                          ? l10n.monthlyPlan
                          : l10n.yearlyPlan,
                      style: GoogleFonts.poppins(
                        color: _maroon,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${subscription.pricePaid.toStringAsFixed(0)}/${subscription.period == SubscriptionPeriod.monthly ? l10n.month : l10n.year}',
                      style: GoogleFonts.poppins(
                        color: _maroon.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.active,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (subscription.endDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: _maroon, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Renews on: ${_formatDate(subscription.endDate!)}',
                    style: GoogleFonts.poppins(
                      color: _maroon.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VendorSubscriptionScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _maroon, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.manageSubscription,
                  style: GoogleFonts.poppins(
                    color: _maroon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              l10n.noActiveSubscription,
              style: GoogleFonts.poppins(
                color: _maroon.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            // Only show "Subscribe Now" button if user is not logged in (needs signup)
            if (!isLoggedIn) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.subscribeNow,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ],
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _maroon, // Maroon Card
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
        leading: Icon(
          icon,
          color: isDestructive
              ? Colors.redAccent
              : _pistachio, // Pistachio Icon
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: isDestructive
                ? Colors.redAccent
                : _pistachio, // Pistachio Text
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: _pistachio.withOpacity(0.5)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
