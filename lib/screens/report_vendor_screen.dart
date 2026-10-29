import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/vendor.dart';
import '../models/vendor_report.dart';
import '../providers/wedding_provider.dart';

class ReportVendorScreen extends StatefulWidget {
  final Vendor vendor;

  const ReportVendorScreen({
    super.key,
    required this.vendor,
  });

  @override
  State<ReportVendorScreen> createState() => _ReportVendorScreenState();
}

class _ReportVendorScreenState extends State<ReportVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _selectedReason;
  bool _isSubmitting = false;

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  final List<String> _reportReasons = [
    'Poor Service Quality',
    'Unprofessional Behavior',
    'Payment Issues',
    'False Information',
    'Safety Concerns',
    'Cancellation Issues',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    // Prevent multiple submissions
    if (_isSubmitting) {
      return;
    }

    // Check if reason is selected first (before form validation)
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a reason for reporting'),
          backgroundColor: _maroon,
        ),
      );
      return;
    }

    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all required fields correctly'),
          backgroundColor: _maroon,
        ),
      );
      return;
    }

    // Check if description is valid
    final description = _descriptionController.text.trim();
    if (description.isEmpty || description.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please provide at least 10 characters in the description'),
          backgroundColor: _maroon,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final provider = Provider.of<WeddingProvider>(context, listen: false);
      debugPrint('Submitting report for vendor: ${widget.vendor.name}');
      debugPrint('Reason: $_selectedReason');
      debugPrint('Description length: ${description.length}');
      
      final success = await provider.reportVendor(
        vendor: widget.vendor,
        reason: _selectedReason!,
        description: description,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Report submitted successfully. We will review it shortly.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to submit report. Please try again.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _submitReport: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _maroon,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _pistachio),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report Vendor',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _pistachio,
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
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vendor Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _pistachio,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _maroon.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            child: Text(
                              widget.vendor.name.isNotEmpty
                                  ? widget.vendor.name[0].toUpperCase()
                                  : '?',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _maroon,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vendor.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _maroon,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.vendor.category} • ${widget.vendor.city}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: _maroon.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Report Reason
                    Text(
                      'Reason for Reporting',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _maroon,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._reportReasons.map((reason) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: _pistachio,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedReason == reason
                                ? _maroon
                                : _maroon.withOpacity(0.3),
                            width: _selectedReason == reason ? 2 : 1,
                          ),
                        ),
                        child: RadioListTile<String>(
                          value: reason,
                          groupValue: _selectedReason,
                          onChanged: (value) {
                            setState(() {
                              _selectedReason = value;
                            });
                          },
                          title: Text(
                            reason,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _maroon,
                              fontWeight: _selectedReason == reason
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          activeColor: _maroon,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    // Description
                    Text(
                      'Additional Details',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _maroon,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: _pistachio,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _maroon.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Please provide more details about your concern...',
                          hintStyle: GoogleFonts.poppins(
                            color: _maroon.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: GoogleFonts.poppins(
                          color: _maroon,
                          fontSize: 14,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please provide additional details';
                          }
                          if (value.trim().length < 10) {
                            return 'Please provide at least 10 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _maroon,
                          foregroundColor: _pistachio,
                          disabledBackgroundColor: _maroon.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(_pistachio),
                                ),
                              )
                            : Text(
                                'Submit Report',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Info Text
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _pistachio.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: _maroon,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your report will be reviewed by our support team. We take all reports seriously and will investigate accordingly.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: _maroon.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
