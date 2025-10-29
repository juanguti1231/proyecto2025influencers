enum PaymentStatus { pending, paid, failed }

class Payment {
  final String id;
  final String campaignId;
  final String companyId;
  final String influencerId;
  final double amount;
  final PaymentStatus status;
  final String currency;
  final DateTime createdAt;
  final DateTime? completedAt;

  Payment({
    required this.id,
    required this.campaignId,
    required this.companyId,
    required this.influencerId,
    required this.amount,
    required this.status,
    this.currency = 'USD',
    required this.createdAt,
    this.completedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      campaignId: json['campaignId'],
      companyId: json['companyId'],
      influencerId: json['influencerId'],
      amount: json['amount'].toDouble(),
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['status']}',
      ),
      currency: json['currency'] ?? 'USD',
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'companyId': companyId,
      'influencerId': influencerId,
      'amount': amount,
      'status': status.toString().split('.').last,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
