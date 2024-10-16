class UserModel {
  final String id;
  final String userName;
  final String password;
  final String name;
  final String? lname; // Make last name nullable
  final String role;
  final String email;

  UserModel({
    required this.id,
    required this.userName,
    required this.password,
    required this.name,
    this.lname, // Nullable last name
    required this.role,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      userName: json['user_name'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      lname: json['lname'], // Parse last name from JSON
      role: json['role'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'password': password,
      'name': name,
      'lname': lname ?? '', // Include last name in JSON if not null
      'role': role,
      'email': email,
    };
  }
}
