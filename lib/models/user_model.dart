class User {
  String id; // ID của người dùng
  String name; // Tên người dùng
  String email; // Email của người dùng
  String password; // Mật khẩu
  String address; // Địa chỉ của người dùng
  String role; // Vai trò của người dùng (user hoặc admin)

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.role,
  });

  // Chuyển đổi đối tượng User thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'role': role,
    };
  }

  // Khởi tạo đối tượng User từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      role: json['role'],
    );
  }
}
