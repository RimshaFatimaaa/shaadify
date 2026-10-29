import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/vendor.dart';
import '../models/vendor_feedback.dart';
import '../providers/feedback_provider.dart';
import '../providers/wedding_provider.dart';
import '../services/wedding_service.dart';
import '../constants/app_constants.dart';
import 'all_feedbacks_screen.dart';

class GiveFeedbackScreen extends StatefulWidget {
  final Vendor? initialVendor;

  const GiveFeedbackScreen({super.key, this.initialVendor});

  @override
  State<GiveFeedbackScreen> createState() => _GiveFeedbackScreenState();
}

class _GiveFeedbackScreenState extends State<GiveFeedbackScreen> {
  final WeddingService _weddingService = WeddingService();
  Vendor? _selectedVendor;
  FeedbackType? _selectedType;
  final TextEditingController _commentController = TextEditingController();

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  void initState() {
    super.initState();
    _selectedVendor = widget.initialVendor;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to go behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        foregroundColor: _pistachio, // Pistachio Icons/Text
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _buildAppBarButton(context, l10n.submitFeedback, true, () {
                // Already on this page, do nothing
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildAppBarButton(context, l10n.allFeedback, false, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllFeedbacksScreen(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE LAYER (Fixed to cover full screen)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _maroon, // Fallback color
              image: const DecorationImage(
                image: AssetImage('assets/images/backgroundimg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. BLUR LAYER
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Container(
                color: Colors.white.withOpacity(
                  0.3,
                ), // Light tint to make Maroon text pop
              ),
            ),
          ),

          // 3. CONTENT LAYER
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor Selection
                  DropdownButtonFormField<Vendor>(
                    value: _selectedVendor,
                    dropdownColor: _maroon, // Maroon Menu
                    style: TextStyle(color: _pistachio), // Pistachio Text
                    decoration: InputDecoration(
                      labelText: l10n.selectVendor,
                      labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
                      filled: true,
                      fillColor: _maroon, // Maroon Background
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
                      prefixIcon: Icon(Icons.store, color: _pistachio),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _getAllVendors().map((vendor) {
                      return DropdownMenuItem<Vendor>(
                        value: vendor,
                        child: Text(vendor.name),
                      );
                    }).toList(),
                    onChanged: (vendor) {
                      setState(() {
                        _selectedVendor = vendor;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Feedback Type Selection
                  Text(
                    l10n.yourFeedback,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _maroon, // Maroon Text Outside
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeedbackTypeButton(
                          FeedbackType.good,
                          l10n.goodFeedback,
                          Icons.thumb_up,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFeedbackTypeButton(
                          FeedbackType.average,
                          l10n.averageFeedback,
                          Icons.thumbs_up_down,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildFeedbackTypeButton(
                          FeedbackType.bad,
                          l10n.badFeedback,
                          Icons.thumb_down,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Comment Field
                  TextField(
                    controller: _commentController,
                    maxLines: 5,
                    style: TextStyle(color: _pistachio), // Pistachio Text
                    decoration: InputDecoration(
                      labelText: l10n.comment,
                      labelStyle: TextStyle(color: _pistachio.withOpacity(0.7)),
                      hintText: 'Write your feedback here...',
                      hintStyle: TextStyle(color: _pistachio.withOpacity(0.5)),
                      filled: true,
                      fillColor: _maroon, // Maroon Background
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _maroon, // Maroon Button
                        foregroundColor: _pistachio, // Pistachio Text
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _pistachio,
                          ), // Optional Border
                        ),
                      ),
                      child: Text(
                        l10n.submitFeedback,
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
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeButton(
    FeedbackType type,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _maroon, // Maroon Card Background
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _pistachio : _pistachio.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? _pistachio : _pistachio.withOpacity(0.6),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? _pistachio : _pistachio.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Vendor> _getAllVendors() {
    final allVendors = <Vendor>[];
    for (final category in AppConstants.itemCategories) {
      allVendors.addAll(_weddingService.getVendorsByCategory(category));
    }
    return allVendors;
  }

  Future<void> _submitFeedback() async {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedVendor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectVendor)));
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectFeedbackType)));
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterComment)));
      return;
    }

    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    final weddingProvider = Provider.of<WeddingProvider>(
      context,
      listen: false,
    );

    final userName = weddingProvider.userName.isNotEmpty
        ? weddingProvider.userName
        : 'Anonymous';
    final userEmail = weddingProvider.userEmail.isNotEmpty
        ? weddingProvider.userEmail
        : 'user_${DateTime.now().millisecondsSinceEpoch}';

    await provider.addFeedback(
      vendorId: _selectedVendor!.id,
      vendorName: _selectedVendor!.name,
      userId: userEmail,
      userName: userName,
      type: _selectedType!,
      comment: _commentController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.feedbackSubmitted),
        backgroundColor: _pistachio, // Themed Snackbar
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: _maroon,
          onPressed: () {},
        ),
      ),
    );

    // Reset form
    setState(() {
      _selectedType = null;
      _commentController.clear();
    });
  }

  Widget _buildAppBarButton(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? _pistachio // Active: Pistachio BG
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: _pistachio, width: 2)
              : Border.all(color: _pistachio.withOpacity(0.5), width: 1),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? _maroon
                : _pistachio, // Maroon text on Active, else Pistachio
          ),
        ),
      ),
    );
  }
}
