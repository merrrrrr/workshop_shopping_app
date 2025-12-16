class Product {
  // Class attribute
  final String? id;
  final String name;
  final int sales;
  final double price;
  final String description;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int quantity;

  // Constructor
  Product({
    this.id,
    required this.name,
    required this.price,
    required this.sales,
    required this.description,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.quantity,
  });

		// Convert Object → Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'sales': sales,
      'description': description,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'quantity': quantity,
    };
  }

	// Convert Map → Object (for reading from Firestore)
  factory Product.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Product(
      id: docId ?? '',
      name: map['name'],
			price: (map['price'] as num).toDouble(),
			sales: map['sales'],
			description: map['description'],
			images: List<String>.from(map['images'] ?? []),
			category: map['category'],
			brand: map['brand'],
			rating: (map['rating'] as num).toDouble(),
			quantity: map['quantity']
		);
	}
}