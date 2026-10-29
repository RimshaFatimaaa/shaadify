import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../models/subscription_plan.dart';
import '../l10n/app_localizations.dart';
import 'payment_screen.dart';
import 'auth_screen.dart';

class VendorSubscriptionScreen extends StatefulWidget {
  const VendorSubscriptionScreen({super.key});

  @override
  State<VendorSubscriptionScreen> createState() =>
      _VendorSubscriptionScreenState();
}

class _VendorSubscriptionScreenState extends State<VendorSubscriptionScreen> {
  SubscriptionPeriod? _selectedPeriod;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    _selectedPeriod = SubscriptionPeriod.monthly;
  }

  List<SubscriptionPlan> get _availablePlans => [
        SubscriptionPlan(
          id: 'vendor_monthly',
          type: SubscriptionType.vendor,
          period: SubscriptionPeriod.monthly,
          price: 1999.0,
          name: 'Vendor Monthly',
          description: 'List your business on our platform',
          features: [
            'Business listing on platform',
            'Receive booking requests',
            'Manage your portfolio',
            'View analytics & insights',
            'Customer reviews & ratings',
            'QR code for bookings',
          ],
        ),
        SubscriptionPlan(
          id: 'vendor_yearly',
          type: SubscriptionType.vendor,
          period: SubscriptionPeriod.yearly,
          price: 19999.0,
          name: 'Vendor Yearly',
          description: 'Best value - Save 17%',
          features: [
            'Business listing on platform',
            'Receive booking requests',
            'Manage your portfolio',
            'View analytics & insights',
            'Customer reviews & ratings',
            'QR code for bookings',
            'Priority listing placement',
            'Featured vendor badge',
          ],
        ),
      ];

  void _handleSubscribe() {
    if (_selectedPeriod == null) return;

    final selectedPlan = _availablePlans.firstWhere(
      (plan) => plan.period == _selectedPeriod,
    );

    // Navigate to payment screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          period: _selectedPeriod!,
          plan: selectedPlan,
          isVendor: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          l10n.vendorSubscription,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Consumer<WeddingProvider>(
                builder: (context, provider, child) {
                  final currentSubscription = provider.vendorSubscription;
                  final hasActiveSubscription = currentSubscription?.isActive ?? false;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Plan Status Card
                      if (hasActiveSubscription) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.currentPlan,
                                    style: GoogleFonts.poppins(
                                      color: _maroon,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentSubscription!.period == SubscriptionPeriod.monthly
                                            ? l10n.monthlyPlan
                                            : l10n.yearlyPlan,
                                        style: GoogleFonts.poppins(
                                          color: _maroon,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (currentSubscription.endDate != null)
                                        Text(
                                          l10n.renewsOn(_formatDate(currentSubscription.endDate!)),
                                          style: GoogleFonts.poppins(
                                            color: _maroon.withOpacity(0.7),
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    'Rs. ${currentSubscription.pricePaid.toStringAsFixed(0)}/${currentSubscription.period == SubscriptionPeriod.monthly ? 'mo' : 'yr'}',
                                    style: GoogleFonts.poppins(
                                      color: _maroon,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.upgradeOrChangePlan,
                          style: GoogleFonts.poppins(
                            color: _maroon,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ] else ...[
                        // Info Card for new subscribers
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _pistachio,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.business, color: _maroon, size: 32),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Subscribe to list your business and start receiving bookings',
                                  style: GoogleFonts.poppins(
                                    color: _maroon,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                  Text(
                    'Choose Your Plan',
                    style: GoogleFonts.poppins(
                      color: _maroon,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a subscription plan to register your business',
                    style: GoogleFonts.poppins(
                      color: _maroon.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Plan Options
                  ..._availablePlans.map((plan) {
                    final isSelected = _selectedPeriod == plan.period;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = plan.period;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? _pistachio : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _maroon : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plan.name,
                                      style: GoogleFonts.poppins(
                                        color: _maroon,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      plan.description,
                                      style: GoogleFonts.poppins(
                                        color: _maroon.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: _maroon,
                                    size: 28,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${plan.formattedPrice} ${plan.periodLabel}',
                              style: GoogleFonts.poppins(
                                color: _maroon,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (plan.period == SubscriptionPeriod.yearly) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _maroon,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Save 17%',
                                  style: GoogleFonts.poppins(
                                    color: _pistachio,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 12),
                            ...plan.features.map((feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: _maroon,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: GoogleFonts.poppins(
                                            color: _maroon,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
                      const SizedBox(height: 24),
                      // Subscribe/Upgrade Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleSubscribe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _maroon,
                            foregroundColor: _pistachio,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            hasActiveSubscription
                                ? 'Change Plan'
                                : 'Continue to Payment',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (hasActiveSubscription) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => _showCancelSubscriptionDialog(context),
                            child: Text(
                              l10n.cancelSubscription,
                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCancelSubscriptionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          l10n.cancelSubscription,
          style: GoogleFonts.poppins(
            color: _maroon,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.cancelSubscriptionConfirmation,
              style: GoogleFonts.poppins(
                color: _maroon,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.businessListingRemoved,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Subscription',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close confirmation dialog first
              Navigator.pop(context);
              
              // Show final alert before logout and redirect
              if (mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Subscription Cancelled',
                            style: GoogleFonts.poppins(
                              color: _maroon,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your subscription has been cancelled successfully.',
                          style: GoogleFonts.poppins(
                            color: _maroon,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'You will now be logged out and redirected to the login page.',
                                  style: GoogleFonts.poppins(
                                    color: Colors.orange.shade900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // Close alert dialog
                          
                          final provider = Provider.of<WeddingProvider>(
                            context,
                            listen: false,
                          );
                          
                          // Cancel subscription
                          await provider.cancelVendorSubscription();
                          
                          if (mounted) {
                            // Immediately redirect to login page and clear navigation stack
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _maroon,
                          foregroundColor: _pistachio,
                        ),
                        child: Text(
                          'OK',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Cancel Subscription',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
