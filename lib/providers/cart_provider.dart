import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/models/item.dart';
import 'package:workshop_shopping_app/services/order_service.dart';

class CartProvider extends ChangeNotifier {
	final List<Item> cartItems = [];
	final OrderService _orderService = OrderService();

	int get itemCount => cartItems.length;
	double get totalAmount => _orderService.calculateTotal(cartItems);

	void addItem(Item item) {
		final existingItemIndex = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);

		if (existingItemIndex != -1) {
			updateQuantity(existingItemIndex, cartItems[existingItemIndex].quantity + item.quantity);
		} else {
			cartItems.add(item);
		}

		notifyListeners();
	}

	void deleteItem(int index) {
		cartItems.removeAt(index);
		notifyListeners();
	}

	void updateQuantity(int index, int newQuantity) {
		cartItems[index] = Item.fromMap({
			...cartItems[index].toMap(),
      'quantity': newQuantity,
		});
		notifyListeners();
	}

	void clearCart() {
		cartItems.clear();
		notifyListeners();
	}

	Future<String> checkout() async {
		final orderId = await _orderService.createOrderFromCart(cartItems);
		clearCart();
		return orderId;
	}
}