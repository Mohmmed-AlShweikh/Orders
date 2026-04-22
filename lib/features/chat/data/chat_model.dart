class Chat {
  final String id;
  final String orderId;
  final String buyerId;
  final String sellerId;

  Chat({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.sellerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory Chat.fromMap(String id, Map<String, dynamic> map) {
    return Chat(
      id: id,
      orderId: map['orderId'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
    );
  }
}