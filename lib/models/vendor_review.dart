class VendorReview {
  final String id;
  final String vendorId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  VendorReview({
    required this.id,
    required this.vendorId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory VendorReview.fromJson(Map<String, dynamic> json) {
    return VendorReview(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      userName: json['userName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}

