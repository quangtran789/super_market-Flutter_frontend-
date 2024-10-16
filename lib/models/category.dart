class Category {
  final String id; // Đảm bảo id là kiểu String
  final String name;
  final String? description;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '', // Lấy id từ _id, gán giá trị rỗng nếu không có
      name: json['name'] ?? 'Chưa có tên', // Gán giá trị mặc định nếu không có tên
      description: json['description'], // Có thể null
      imageUrl: json['imageUrl'], // Có thể null
    );
  }

  // Hàm toMap() nếu cần chuyển đổi thành Map (nếu bạn cần gửi lên server)
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
