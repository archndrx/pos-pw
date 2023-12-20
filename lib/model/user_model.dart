class UserModel {
  late String? id;
  late String name;
  late String email;
  late String password;
  late String role;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
