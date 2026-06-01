enum UserRole {
  driver,
  owner,
  admin,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final UserRole currentRole;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    this.currentRole = UserRole.driver,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? currentRole,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentRole: currentRole ?? this.currentRole,
    );
  }
}
