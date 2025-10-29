class PlatformHandle {
  final String platform;
  final String username;
  final int followers;
  final String? url;

  PlatformHandle({
    required this.platform,
    required this.username,
    required this.followers,
    this.url,
  });

  factory PlatformHandle.fromJson(Map<String, dynamic> json) {
    return PlatformHandle(
      platform: json['platform'],
      username: json['username'],
      followers: json['followers'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'username': username,
      'followers': followers,
      'url': url,
    };
  }
}

class Pricing {
  final String type;
  final double priceFrom;
  final double? priceTo;

  Pricing({
    required this.type,
    required this.priceFrom,
    this.priceTo,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      type: json['type'],
      priceFrom: json['priceFrom'].toDouble(),
      priceTo: json['priceTo']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
    };
  }
}

class Metrics {
  final double engagementRate;
  final int avgViews;
  final List<String> topCountries;
  final List<String> topAges;
  final int postsPerWeek;

  Metrics({
    required this.engagementRate,
    required this.avgViews,
    required this.topCountries,
    required this.topAges,
    required this.postsPerWeek,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      engagementRate: json['engagementRate'].toDouble(),
      avgViews: json['avgViews'],
      topCountries: List<String>.from(json['topCountries']),
      topAges: List<String>.from(json['topAges']),
      postsPerWeek: json['postsPerWeek'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engagementRate': engagementRate,
      'avgViews': avgViews,
      'topCountries': topCountries,
      'topAges': topAges,
      'postsPerWeek': postsPerWeek,
    };
  }
}

class PortfolioItem {
  final String title;
  final String url;
  final String? thumbnail;
  final String platform;

  PortfolioItem({
    required this.title,
    required this.url,
    this.thumbnail,
    required this.platform,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      title: json['title'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      platform: json['platform'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'thumbnail': thumbnail,
      'platform': platform,
    };
  }
}

class InfluencerProfile {
  final String userId;
  final String bio;
  final List<PlatformHandle> handles;
  final List<String> niches;
  final List<String> languages;
  final List<Pricing> pricing;
  final Metrics metrics;
  final List<PortfolioItem> portfolio;

  InfluencerProfile({
    required this.userId,
    required this.bio,
    required this.handles,
    required this.niches,
    required this.languages,
    required this.pricing,
    required this.metrics,
    required this.portfolio,
  });

  factory InfluencerProfile.fromJson(Map<String, dynamic> json) {
    return InfluencerProfile(
      userId: json['userId'],
      bio: json['bio'],
      handles: (json['handles'] as List)
          .map((h) => PlatformHandle.fromJson(h))
          .toList(),
      niches: List<String>.from(json['niches']),
      languages: List<String>.from(json['languages']),
      pricing: (json['pricing'] as List)
          .map((p) => Pricing.fromJson(p))
          .toList(),
      metrics: Metrics.fromJson(json['metrics']),
      portfolio: (json['portfolio'] as List)
          .map((p) => PortfolioItem.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bio': bio,
      'handles': handles.map((h) => h.toJson()).toList(),
      'niches': niches,
      'languages': languages,
      'pricing': pricing.map((p) => p.toJson()).toList(),
      'portfolio': portfolio.map((p) => p.toJson()).toList(),
    };
  }
}
