class Item {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;

  Item({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

	  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      productId: map['productId'],
      productName: map['productName'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}