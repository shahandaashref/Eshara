class ProfileEntity {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final DateTime createdAt;

  ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.createdAt,
  });
}
