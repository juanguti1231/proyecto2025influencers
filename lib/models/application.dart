enum ApplicationStatus { submitted, review, hired, rejected }

class Application {
  final String id;
  final String campaignId;
  final String influencerId;
  final double proposalAmount;
  final String message;
  final ApplicationStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Application({
    required this.id,
    required this.campaignId,
    required this.influencerId,
    required this.proposalAmount,
    required this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      campaignId: json['campaignId'],
      influencerId: json['influencerId'],
      proposalAmount: json['proposalAmount'].toDouble(),
      message: json['message'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString() == 'ApplicationStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'influencerId': influencerId,
      'proposalAmount': proposalAmount,
      'message': message,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
