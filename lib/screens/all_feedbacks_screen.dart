import 'dart:ui'; // Required for ImageFilter (Blur)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/vendor.dart';
import '../models/vendor_feedback.dart';
import '../providers/feedback_provider.dart';
import 'give_feedback_screen.dart';

class AllFeedbacksScreen extends StatefulWidget {
  final Vendor? selectedVendor;

  const AllFeedbacksScreen({super.key, this.selectedVendor});

  @override
  State<AllFeedbacksScreen> createState() => _AllFeedbacksScreenState();
}

class _AllFeedbacksScreenState extends State<AllFeedbacksScreen> {
  String _filterType = 'all'; // all, good, average, bad

  // THEME COLORS
  final Color _maroon = const Color(0xFF600000);
  final Color _pistachio = const Color(0xFFD7E8CD);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _maroon, // Maroon Background
      extendBodyBehindAppBar:
          true, // Allow background image to go behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for background image
        elevation: 0,
        foregroundColor: _pistachio, // Pistachio Icons/Text
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _buildAppBarButton(
                context,
                l10n.submitFeedback,
                false,
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GiveFeedbackScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildAppBarButton(context, l10n.allFeedback, true, () {
                // Already on this page, do nothing
              }),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. BLURRED BACKGROUND IMAGE LAYER
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: _maroon, // Fallback color
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Container(
                color: Colors.black.withOpacity(0.2), // Optional dark tint
              ),
            ),
          ),

          // 2. CONTENT LAYER
          SafeArea(
            child: Column(
              children: [
                // Filter Tabs
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  // Removed solid white/maroon background to let blur show through
                  // or use semi-transparent if needed
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(child: _buildFilterTab('all', l10n.allFeedback)),
                      Expanded(
                        child: _buildFilterTab('good', l10n.goodFeedbacks),
                      ),
                      Expanded(
                        child: _buildFilterTab(
                          'average',
                          l10n.averageFeedbacks,
                        ),
                      ),
                      Expanded(
                        child: _buildFilterTab('bad', l10n.badFeedbacks),
                      ),
                    ],
                  ),
                ),
                // Feedback List
                Expanded(
                  child: Consumer<FeedbackProvider>(
                    builder: (context, feedbackProvider, child) {
                      // Get a mutable copy of all feedbacks
                      List<VendorFeedback> feedbacks =
                          List<VendorFeedback>.from(feedbackProvider.feedbacks);

                      // Apply filter by type
                      if (_filterType == 'good') {
                        feedbacks = feedbacks
                            .where((f) => f.type == FeedbackType.good)
                            .toList();
                      } else if (_filterType == 'average') {
                        feedbacks = feedbacks
                            .where((f) => f.type == FeedbackType.average)
                            .toList();
                      } else if (_filterType == 'bad') {
                        feedbacks = feedbacks
                            .where((f) => f.type == FeedbackType.bad)
                            .toList();
                      }
                      // 'all' means no type filtering

                      // Apply vendor filter if selected
                      if (widget.selectedVendor != null) {
                        feedbacks = feedbacks
                            .where(
                              (f) => f.vendorId == widget.selectedVendor!.id,
                            )
                            .toList();
                      }

                      // Sort by date (newest first)
                      feedbacks.sort(
                        (a, b) => b.createdAt.compareTo(a.createdAt),
                      );

                      if (feedbacks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.feedback_outlined,
                                size: 64,
                                color: _pistachio.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noFeedbackYet,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: _pistachio,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: feedbacks.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildFeedbackCard(feedbacks[index], l10n),
                          );
                        },
                      );
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

  Widget _buildFilterTab(String type, String label) {
    final isSelected = _filterType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _filterType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _pistachio.withOpacity(0.2) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _pistachio : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? _pistachio : _pistachio.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(VendorFeedback feedback, AppLocalizations l10n) {
    Color typeColor;
    IconData typeIcon;
    String typeLabel;

    switch (feedback.type) {
      case FeedbackType.good:
        typeColor = Colors.green;
        typeIcon = Icons.thumb_up;
        typeLabel = l10n.goodFeedback;
        break;
      case FeedbackType.average:
        typeColor = Colors.orange;
        typeIcon = Icons.thumbs_up_down;
        typeLabel = l10n.averageFeedback;
        break;
      case FeedbackType.bad:
        typeColor = Colors.red;
        typeIcon = Icons.thumb_down;
        typeLabel = l10n.badFeedback;
        break;
    }

    return Card(
      margin: EdgeInsets.zero,
      color: _maroon, // Maroon Card Background
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _pistachio.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: typeColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 16, color: typeColor),
                      const SizedBox(width: 4),
                      Text(
                        typeLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(feedback.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _pistachio.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              feedback.vendorName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _pistachio, // Pistachio Text inside card
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.feedbackFrom} ${feedback.userName}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _pistachio.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feedback.comment,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _pistachio, // Pistachio Text inside card
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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
          color: isActive ? _pistachio.withOpacity(0.2) : Colors.transparent,
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
            color: isActive ? _pistachio : _pistachio.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
