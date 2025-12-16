import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_shopping_app/models/product.dart';

class ProductService {
	// Create Firestore instance
	final _firestore = FirebaseFirestore.instance;

	// Get product collection
	CollectionReference get _productsCollection => _firestore.collection('products');

	// Get all products from Firestore
	Future<List<Product>> getAllProducts() async {
		try {
			// QuerySnapshot = a list of DocumentSnapshot
			QuerySnapshot snapshot = await _productsCollection.get();
			// For each snapshot,
			List<Product> products = snapshot.docs.map((product) {
				// Print the product data
				print('Product data: ${product.data()}');
				// Convert data from Map format into Product object
				// Add into products list
				return Product.fromMap(
					product.data() as Map<String, dynamic>,
					docId: product.id,
				);
			}).toList();
			return products;
		} catch(e) {
			print('Error retrieving products: $e');
			throw Exception('Failed to get products');
		}
	}
}