class User {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.role,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert User to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password,
    };
  }

  // Create User from JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      role: json['role'] ?? 'buyer',
      password: json['password'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? state,
    String? city,
    String? locality,
    String? role,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      state: state ?? this.state,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      role: role ?? this.role,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $fullName, email: $email, role: $role)';
  }
}
