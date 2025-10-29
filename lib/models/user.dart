enum UserRole { company, influencer, admin }

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String location;
  final UserRole role;
  final bool verified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.location,
    required this.role,
    this.verified = false,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      location: json['location'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${json['role']}'),
      verified: json['verified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'location': location,
      'role': role.toString().split('.').last,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
