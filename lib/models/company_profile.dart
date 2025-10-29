class CompanyProfile {
  final String userId;
  final String companyName;
  final String website;
  final String industry;
  final bool verified;

  CompanyProfile({
    required this.userId,
    required this.companyName,
    required this.website,
    required this.industry,
    this.verified = false,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      userId: json['userId'],
      companyName: json['companyName'],
      website: json['website'],
      industry: json['industry'],
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'companyName': companyName,
      'website': website,
      'industry': industry,
      'verified': verified,
    };
  }
}
