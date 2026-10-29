class VendorFeedback {
  final String id;
  final String vendorId;
  final String vendorName;
  final String userId;
  final String userName;
  final FeedbackType type; // good, average, bad
  final String comment;
  final DateTime createdAt;

  VendorFeedback({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.userId,
    required this.userName,
    required this.type,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'userId': userId,
      'userName': userName,
      'type': type.toString().split('.').last,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VendorFeedback.fromJson(Map<String, dynamic> json) {
    return VendorFeedback(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendorName: json['vendorName'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      type: FeedbackType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => FeedbackType.average,
      ),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

enum FeedbackType {
  good,
  average,
  bad,
}
