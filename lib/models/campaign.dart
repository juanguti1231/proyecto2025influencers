enum CampaignStatus { open, review, hired, closed }
enum CampaignVisibility { public, invite }

class Deliverable {
  final String type;
  final int quantity;
  final String? guidelines;
  final List<String> hashtags;
  final List<String> mentions;

  Deliverable({
    required this.type,
    required this.quantity,
    this.guidelines,
    required this.hashtags,
    required this.mentions,
  });

  factory Deliverable.fromJson(Map<String, dynamic> json) {
    return Deliverable(
      type: json['type'],
      quantity: json['quantity'],
      guidelines: json['guidelines'],
      hashtags: List<String>.from(json['hashtags']),
      mentions: List<String>.from(json['mentions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'quantity': quantity,
      'guidelines': guidelines,
      'hashtags': hashtags,
      'mentions': mentions,
    };
  }
}

class Audience {
  final List<String> countries;
  final List<String> cities;
  final List<String> ageRanges;
  final List<String> interests;

  Audience({
    required this.countries,
    required this.cities,
    required this.ageRanges,
    required this.interests,
  });

  factory Audience.fromJson(Map<String, dynamic> json) {
    return Audience(
      countries: List<String>.from(json['countries']),
      cities: List<String>.from(json['cities']),
      ageRanges: List<String>.from(json['ageRanges']),
      interests: List<String>.from(json['interests']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countries': countries,
      'cities': cities,
      'ageRanges': ageRanges,
      'interests': interests,
    };
  }
}

class Budget {
  final double? min;
  final double? max;
  final double? fixed;
  final String currency;

  Budget({
    this.min,
    this.max,
    this.fixed,
    this.currency = 'USD',
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      min: json['min']?.toDouble(),
      max: json['max']?.toDouble(),
      fixed: json['fixed']?.toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'fixed': fixed,
      'currency': currency,
    };
  }
}

class Campaign {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final String category;
  final List<Deliverable> deliverables;
  final Audience audience;
  final Budget budget;
  final DateTime deadline;
  final CampaignStatus status;
  final CampaignVisibility visibility;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Campaign({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.category,
    required this.deliverables,
    required this.audience,
    required this.budget,
    required this.deadline,
    required this.status,
    required this.visibility,
    required this.createdAt,
    this.updatedAt,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      companyId: json['companyId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      deliverables: (json['deliverables'] as List)
          .map((d) => Deliverable.fromJson(d))
          .toList(),
      audience: Audience.fromJson(json['audience']),
      budget: Budget.fromJson(json['budget']),
      deadline: DateTime.parse(json['deadline']),
      status: CampaignStatus.values.firstWhere(
        (e) => e.toString() == 'CampaignStatus.${json['status']}',
      ),
      visibility: CampaignVisibility.values.firstWhere(
        (e) => e.toString() == 'CampaignVisibility.${json['visibility']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'title': title,
      'description': description,
      'category': category,
      'deliverables': deliverables.map((d) => d.toJson()).toList(),
      'audience': audience.toJson(),
      'budget': budget.toJson(),
      'deadline': deadline.toIso8601String(),
      'status': status.toString().split('.').last,
      'visibility': visibility.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
