class Orders {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final double price;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;

  Orders({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'price': price,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      id: map['id'],
      productId: map['productId'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      price: map['price'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}