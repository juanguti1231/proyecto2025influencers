enum ReportType { user, campaign }

class Report {
  final String id;
  final ReportType targetType;
  final String targetId;
  final String reason;
  final String? details;
  final String reporterId;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.reason,
    this.details,
    required this.reporterId,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      targetType: ReportType.values.firstWhere(
        (e) => e.toString() == 'ReportType.${json['targetType']}',
      ),
      targetId: json['targetId'],
      reason: json['reason'],
      details: json['details'],
      reporterId: json['reporterId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetType': targetType.toString().split('.').last,
      'targetId': targetId,
      'reason': reason,
      'details': details,
      'reporterId': reporterId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
