class User {
  final String id;
  final String username;
  final String email;
  final String phone;
  String name;
  String role; // 'MediaReporter' or 'Viewer'
  String? profileImageUrl;
  DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.name,
    required this.role,
    this.profileImageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'Viewer',
      profileImageUrl: json['profileImageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
