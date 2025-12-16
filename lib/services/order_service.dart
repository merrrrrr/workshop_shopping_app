import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workshop_shopping_app/models/item.dart';
import 'package:workshop_shopping_app/models/order.dart';
import 'package:workshop_shopping_app/services/user_service.dart';

class OrderService {
	// Create FirebaseAuth and Firestore instance
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

	// Get current user ID
	String get currentUserId {
		final user = _auth.currentUser;
		if (user == null) {
			throw Exception('No authenticated user found.');
		}
		return user.uid;
	}

	CollectionReference get _ordersCollection => _firestore.collection('orders');

	// Get total amount of cart items
	double calculateTotal(List<Item> cartItems) {
		double subtotal = 0.0;
		for (var item in cartItems) {
			subtotal += item.price * item.quantity;
		}

		return double.parse(subtotal.toStringAsFixed(2));
	}

	Future<String> createOrderFromCart(List<Item> cartItems) async {
		try {
			// Get user address
			final user = await UserService().getUser();
			final address = user.address;

			// Call calculateTotal() function
			final totalAmount = calculateTotal(cartItems);
			// Generate new Order object
			final order = Order(
        userId: currentUserId,
				items: cartItems,
        totalAmount: totalAmount,
        shippingAddress: address,
        createdAt: DateTime.now(),
      );
			
			// Update inventory
			await _updateProductInventory(cartItems);

			// Add order into firestore
			DocumentReference doc = await _ordersCollection.add(order.toMap());

			print('Order created successfully');
			return doc.id;
		} catch(e) {
			print('Error creating order from cart: $e');
			throw Exception('Failed to create order from cart');
		}
	}

		Future<void> _updateProductInventory(List<Item> cartItems) async {
		try {
			// Create empty batch to collect multiple database updates
			WriteBatch batch = _firestore.batch();

			for (var item in cartItems) {
				// Get reference of each item in cart
        DocumentReference productRef = _firestore.collection('products').doc(item.productId);

				// Add update into batch
        batch.update(productRef, {
	        // Add sales count and minus sotck count
          'salesCount': FieldValue.increment(item.quantity),
          'stockCount': FieldValue.increment(-item.quantity),
        });
      }
			
			// Send all collected updates to Firestore at once
			await batch.commit();
			print('Product inventory updated successfully.');
		} catch(e) {
			print('Error updating product inventory: $e');
			throw Exception('Failed to update product inventory.');
		}
	}

	Future<List<Order>> getAllOrders() async {
		try {
			QuerySnapshot snapshot = await _ordersCollection
          .where('userId', isEqualTo: currentUserId)
          .get();
			List<Order> orders = snapshot.docs.map((doc) {
				return Order.fromMap(
					doc.data() as Map<String, dynamic>,
					docId: doc.id
				);
			}).toList();

			print('Retrieved ${orders.length} orders for user $currentUserId');
			return orders;
		} catch(e) {
			print('Error retrieving orders: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: ${StackTrace.current}');
			throw Exception('Failed to get orders');
		}
	}

}