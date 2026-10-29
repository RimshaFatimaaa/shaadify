import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/vendor_lead.dart';
import '../providers/wedding_provider.dart';
import '../l10n/app_localizations.dart';
import 'qr_code_screen.dart';

class VendorLeadsScreen extends StatefulWidget {
  final String? vendorCategory;

  const VendorLeadsScreen({super.key, this.vendorCategory});

  @override
  State<VendorLeadsScreen> createState() => _VendorLeadsScreenState();
}

class _VendorLeadsScreenState extends State<VendorLeadsScreen> {
  String _selectedTab = 'pending'; // pending, confirmed, completed

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  // Initialize leads list
  late List<VendorLead> _leads;

  @override
  void initState() {
    super.initState();
    _initializeLeads();
  }

  // Helper function to get category-specific package names
  String _getPackageNameForCategory(String? category, int index) {
    if (category == null) return 'Standard Package';
    
    final categoryLower = category.toLowerCase();
    final packages = {
      'venue': ['Premium Hall Package', 'Grand Ballroom Deal', 'Outdoor Venue Package', 'Luxury Banquet Hall', 'Garden Venue Package', 'Rooftop Event Space', 'Traditional Hall Deal', 'Modern Venue Package'],
      'décor': ['Royal Décor Package', 'Floral Arrangement Deal', 'LED Lighting Package', 'Theme Decoration Set', 'Stage Decoration', 'Entrance Setup', 'Table Centerpieces', 'Backdrop Design'],
      'catering': ['Premium Buffet Package', 'Multi-Course Meal Deal', 'Live Cooking Station', 'Dessert Bar Package', 'BBQ Package', 'Traditional Food Set', 'International Cuisine', 'Snacks & Beverages'],
      'makeup': ['Bridal Makeup Package', 'Party Makeup Deal', 'Complete Beauty Package', 'Hair & Makeup Combo', 'Trial Session', 'Full Day Makeup', 'Glamour Package', 'Natural Look Deal'],
      'photography': ['Full Day Photography', 'Premium Videography Package', 'Drone Photography Deal', 'Complete Media Package', 'Pre-Wedding Shoot', 'Candid Photography', 'Cinematic Video', 'Photo Album Package'],
      'music': ['DJ Package', 'Live Band Deal', 'Sound System Package', 'Entertainment Combo', 'Qawali Night', 'Singer Performance', 'Sound & Lighting', 'Complete Music Setup'],
      'nikah setup': ['Traditional Nikah Setup', 'Modern Nikah Arrangement', 'Complete Nikah Package', 'Luxury Nikah Deal', 'Simple Nikah Setup', 'Elaborate Arrangement', 'Indoor Nikah', 'Outdoor Nikah'],
      'gifts': ['Custom Gift Package', 'Favor Box Deal', 'Premium Gift Set', 'Personalized Gift Package', 'Traditional Gifts', 'Modern Gift Set', 'Luxury Favors', 'Budget Gift Package'],
      'car entry': ['Decorated Car Entry', 'Premium Car Setup', 'Flower Car Arrangement', 'Luxury Car Entry Package', 'Simple Decoration', 'Elaborate Setup', 'Traditional Style', 'Modern Design'],
      'other': ['Standard Package', 'Custom Deal', 'Premium Package', 'Special Package', 'Basic Package', 'Deluxe Deal', 'Luxury Package', 'Economy Package'],
    };
    
    final categoryPackages = packages[categoryLower] ?? packages['other']!;
    return categoryPackages[index % categoryPackages.length];
  }

  // Initialize leads with category-specific packages
  void _initializeLeads() {
    final eventTypes = ['Barat Event', 'Mehndi', 'Walima', 'Engagement', 'Mayun', 'Nikah', 'Qawali Night'];
    final cities = ['Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar', 'Quetta'];
    final clientNames = [
      'Ayesha K.', 'Fatima A.', 'Sara M.', 'Hira R.', 'Zainab S.',
      'Maryam K.', 'Amina H.', 'Sana A.', 'Rabia M.', 'Nida F.'
    ];
    final dates = [
      'Dec 24, 2025', 'Dec 20, 2025', 'Dec 28, 2025', 'Dec 15, 2025', 'Jan 5, 2026',
      'Jan 10, 2026', 'Jan 15, 2026', 'Jan 20, 2026', 'Jan 25, 2026', 'Feb 1, 2026'
    ];
    final statuses = [
      LeadStatus.pending, LeadStatus.pending, LeadStatus.pending, LeadStatus.pending, LeadStatus.confirmed,
      LeadStatus.pending, LeadStatus.pending, LeadStatus.confirmed, LeadStatus.pending, LeadStatus.confirmed
    ];

    _leads = List.generate(10, (index) {
      return VendorLead(
        id: '${index + 1}',
        clientName: clientNames[index],
        location: cities[index % cities.length],
        eventType: eventTypes[index % eventTypes.length],
        eventDate: dates[index],
        packageName: _getPackageNameForCategory(widget.vendorCategory, index),
        status: statuses[index],
      );
    });
  }

  List<VendorLead> get _pendingLeads =>
      _leads.where((lead) => lead.status == LeadStatus.pending).toList();
  List<VendorLead> get _confirmedLeads =>
      _leads.where((lead) => lead.status == LeadStatus.confirmed).toList();
  List<VendorLead> get _completedLeads =>
      _leads.where((lead) => lead.status == LeadStatus.completed).toList();

  void _acceptLead(String leadId) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      final lead = _leads.firstWhere((l) => l.id == leadId);
      lead.status = LeadStatus.confirmed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.requestAccepted),
        backgroundColor: _pistachio,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _completeLead(String leadId) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      final lead = _leads.firstWhere((l) => l.id == leadId);
      lead.status = LeadStatus.completed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.leadCompleted),
        backgroundColor: _pistachio,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                color:
                    Colors.white, // Fallback to white so maroon text is visible
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
            child: Column(
              children: [
                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _maroon, // Maroon Container
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _pistachio.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: _buildTab('pending', l10n.pending, _pendingLeads.length)),
                      Expanded(
                          child: _buildTab('confirmed', l10n.confirmed, _confirmedLeads.length)),
                      Expanded(
                          child: _buildTab('completed', l10n.completed, _completedLeads.length)),
                    ],
                  ),
                ),
                // Leads List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _selectedTab == 'pending'
                        ? _pendingLeads.length
                        : _selectedTab == 'confirmed'
                            ? _confirmedLeads.length
                            : _completedLeads.length,
                    itemBuilder: (context, index) {
                      final lead = _selectedTab == 'pending'
                          ? _pendingLeads[index]
                          : _selectedTab == 'confirmed'
                              ? _confirmedLeads[index]
                              : _completedLeads[index];
                      return _buildLeadCard(lead);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tabId, String label, int count) {
    final isSelected = _selectedTab == tabId;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tabId;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _pistachio
              : Colors.transparent, // Pistachio Highlight
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$label${count > 0 ? ' ($count)' : ''}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? _maroon : _pistachio, // Inverted Text Color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadCard(VendorLead lead) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: _pistachio.withOpacity(0.2),
            child: Text(
              lead.clientName[0],
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _pistachio, // Pistachio Text
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Client Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead.clientName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _pistachio, // Pistachio Text
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${lead.eventType} | ${lead.eventDate}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: _pistachio, // Pistachio Text
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Interested in: ${lead.packageName}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _pistachio.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Action Buttons based on status
                if (lead.status == LeadStatus.pending)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _pistachio.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            l10n.message,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _pistachio, // Pistachio Text
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _acceptLead(lead.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pistachio, // Pistachio Button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: FittedBox(
                            child: Text(
                              l10n.acceptRequest,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _maroon, // Maroon Text
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (lead.status == LeadStatus.confirmed)
                  Column(
                    children: [
                      // QR Code button (only for Venue vendors)
                      if (widget.vendorCategory?.toLowerCase() == 'venue')
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QRCodeScreen(
                                    lead: lead,
                                    isVendorView: true,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code),
                            label: Text(
                              l10n.viewQRCode,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _pistachio,
                              foregroundColor: _maroon,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: _pistachio.withOpacity(0.5)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                l10n.message,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: _pistachio, // Pistachio Text
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _completeLead(lead.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _pistachio, // Pistachio Button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: FittedBox(
                                child: Text(
                                  l10n.markAsCompleted,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: _maroon, // Maroon Text
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  // Completed status - show status badge
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _pistachio.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _pistachio.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: _pistachio, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Completed',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _pistachio,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
