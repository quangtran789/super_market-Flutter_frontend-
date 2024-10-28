class DiscountCode {
  final String id; // ID của mã giảm giá
  final String code; // Mã giảm giá
  final double discountValue; // Giá trị giảm giá
  final bool isValid; // Tình trạng hiệu lực của mã
  final DateTime expiryDate; // Ngày hết hạn của mã

  DiscountCode({
    required this.id,
    required this.code,
    required this.discountValue,
    required this.isValid,
    required this.expiryDate,
  });

  // Phương thức tạo DiscountCode từ JSON
  factory DiscountCode.fromJson(Map<String, dynamic> json) {
  return DiscountCode(
    id: json['_id'],
    code: json['code'],
    discountValue: (json['discountValue'] is int)
        ? (json['discountValue'] as int).toDouble()
        : json['discountValue'],
    isValid: json['isValid'],
    expiryDate: DateTime.parse(json['expiryDate']),
  );
}


  // Phương thức chuyển DiscountCode thành JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'discountValue': discountValue,
      'isValid': isValid,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
}
