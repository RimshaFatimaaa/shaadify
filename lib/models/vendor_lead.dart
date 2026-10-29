class VendorLead {
  final String id;
  final String clientName;
  final String location;
  final String eventType;
  final String eventDate;
  final String packageName;
  LeadStatus status;

  VendorLead({
    required this.id,
    required this.clientName,
    required this.location,
    required this.eventType,
    required this.eventDate,
    required this.packageName,
    this.status = LeadStatus.pending,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'location': location,
      'eventType': eventType,
      'eventDate': eventDate,
      'packageName': packageName,
      'status': status.name,
    };
  }

  factory VendorLead.fromJson(Map<String, dynamic> json) {
    return VendorLead(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      location: json['location'] as String,
      eventType: json['eventType'] as String,
      eventDate: json['eventDate'] as String,
      packageName: json['packageName'] as String,
      status: LeadStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LeadStatus.pending,
      ),
    );
  }
}

enum LeadStatus {
  pending,
  confirmed,
  completed,
}
