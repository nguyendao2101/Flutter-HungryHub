class CartItem {
  final String productId;
  final String productName;
  final String productImageUrl;
  final double productPrice;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    this.quantity = 1,
  });

  // Tính toán tổng tiền của món hàng
  double get totalPrice => productPrice * quantity;
}
