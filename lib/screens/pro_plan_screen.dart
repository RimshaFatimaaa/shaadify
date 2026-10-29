import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/wedding_provider.dart';
import '../models/subscription_plan.dart';
import 'payment_screen.dart';

class ProPlanScreen extends StatefulWidget {
  const ProPlanScreen({super.key});

  @override
  State<ProPlanScreen> createState() => _ProPlanScreenState();
}

class _ProPlanScreenState extends State<ProPlanScreen> {
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
          id: 'pro_monthly',
          type: SubscriptionType.pro,
          period: SubscriptionPeriod.monthly,
          price: 999.0,
          name: 'Pro Monthly',
          description: 'Full access to all Pro features',
          features: [
            'Wedding Visualization',
            '10% Discount on Pro Vendors',
            'Priority Support',
            'Advanced Planning Tools',
            'Unlimited Events',
          ],
        ),
        SubscriptionPlan(
          id: 'pro_yearly',
          type: SubscriptionType.pro,
          period: SubscriptionPeriod.yearly,
          price: 9999.0,
          name: 'Pro Yearly',
          description: 'Best value - Save 17%',
          features: [
            'Wedding Visualization',
            '10% Discount on Pro Vendors',
            'Priority Support',
            'Advanced Planning Tools',
            'Unlimited Events',
            'Early Access to New Features',
          ],
        ),
      ];

  void _handleSubscribe() {
    if (_selectedPeriod == null) return;

    final selectedPlan = _availablePlans.firstWhere(
      (plan) => plan.period == _selectedPeriod,
    );

    // Navigate to payment screen instead of directly subscribing
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          period: _selectedPeriod!,
          plan: selectedPlan,
        ),
      ),
    );
  }

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
          'Upgrade to Pro',
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
                final isPro = provider.isProUser;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPro) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _pistachio,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: _maroon),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You are already a Pro member!',
                                  style: GoogleFonts.poppins(
                                    color: _maroon,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
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
                        'Unlock premium features and save on vendor bookings',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      )
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8),
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
                      // Subscribe Button
                      if (!isPro)
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
                              'Subscribe Now',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (isPro)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              final provider = Provider.of<WeddingProvider>(
                                context,
                                listen: false,
                              );
                              await provider.cancelSubscription();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Subscription cancelled'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel Subscription',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
}
