import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/vendor_report.dart';
import '../providers/wedding_provider.dart';

class VendorReportsScreen extends StatelessWidget {
  const VendorReportsScreen({super.key});

  // THEME COLORS
  static const Color _maroon = Color(0xFF600000);
  static const Color _pistachio = Color(0xFFD7E8CD);

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'resolved':
        return 'green';
      case 'reviewed':
        return 'blue';
      default:
        return 'orange';
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
          'Previous Reports',
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
            child: Consumer<WeddingProvider>(
              builder: (context, provider, child) {
                final reports = provider.vendorReports;

                if (reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 64,
                          color: _maroon.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Reports Yet',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _maroon,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Reports you submit will appear here',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _maroon.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Sort reports by date (newest first)
                final sortedReports = List<VendorReport>.from(reports)
                  ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedReports.length,
                  itemBuilder: (context, index) {
                    final report = sortedReports[index];
                    final statusColor = _getStatusColor(report.status);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report.vendorName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: _maroon,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${report.vendorCategory} • ${_formatDate(report.reportedAt)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: _maroon.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor == 'orange'
                                        ? Colors.orange.withOpacity(0.2)
                                        : statusColor == 'green'
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: statusColor == 'orange'
                                          ? Colors.orange
                                          : statusColor == 'green'
                                              ? Colors.green
                                              : Colors.blue,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    report.status.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor == 'orange'
                                          ? Colors.orange
                                          : statusColor == 'green'
                                              ? Colors.green
                                              : Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              height: 1,
                              color: _maroon.withOpacity(0.2),
                            ),
                            const SizedBox(height: 12),
                            // Reason
                            Row(
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  size: 16,
                                  color: _maroon.withOpacity(0.7),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Reason: ${report.reportReason}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _maroon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Description
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _maroon.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                report.reportDescription,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: _maroon.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Reported by and date
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14,
                                  color: _maroon.withOpacity(0.6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Reported by: ${report.reportedBy}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _maroon.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

