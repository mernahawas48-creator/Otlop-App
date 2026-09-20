class UserModel {
  const UserModel({
    required this.userId,
    required this.email,
    required this.fullName,
  });

  final String userId;
  final String email;
  final String fullName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'fullName': fullName,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? fullName,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
    );
  }
}
