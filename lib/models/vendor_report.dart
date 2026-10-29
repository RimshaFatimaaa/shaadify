import 'vendor.dart';

class VendorReport {
  final String id;
  final String vendorId;
  final String vendorName;
  final String vendorCategory;
  final String reportReason;
  final String reportDescription;
  final DateTime reportedAt;
  final String reportedBy; // User name/email
  final String status; // 'pending', 'reviewed', 'resolved'

  VendorReport({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.vendorCategory,
    required this.reportReason,
    required this.reportDescription,
    required this.reportedAt,
    required this.reportedBy,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorCategory': vendorCategory,
      'reportReason': reportReason,
      'reportDescription': reportDescription,
      'reportedAt': reportedAt.toIso8601String(),
      'reportedBy': reportedBy,
      'status': status,
    };
  }

  factory VendorReport.fromJson(Map<String, dynamic> json) {
    return VendorReport(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      vendorCategory: json['vendorCategory'] as String,
      reportReason: json['reportReason'] as String,
      reportDescription: json['reportDescription'] as String,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      reportedBy: json['reportedBy'] as String,
      status: json['status'] as String? ?? 'pending',
    );
  }
}

