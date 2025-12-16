import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workshop_shopping_app/providers/cart_provider.dart';
import 'package:workshop_shopping_app/services/order_service.dart';
import 'package:workshop_shopping_app/widgets/quantity_selector.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cart")
      ),

      body: Consumer<CartProvider>(
				builder: (context, cartProvider, child) {
				  return Column(
						children: [
							Expanded(
								child: ListView.builder(
									itemCount: cartProvider.cartItems.length,
									itemBuilder: (context, index) {
										return _buildCartItemCard(context, index, cartProvider);
									},
								),
							),
							_buildCheckoutBar(context, cartProvider),
						],
					);
				},
				
			),
    );
  }

  Widget _buildCartItemCard(BuildContext context, int index, CartProvider cartProvider) {
    final cartItem = cartProvider.cartItems[index];
    final quantity = cartItem.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      // This widget creates a sliable widget to delete the item.
      child: Slidable(
        endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.35,
            children: [
              SlidableAction(
                onPressed: (context) => cartProvider.deleteItem(index),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                flex: 2,
              ),
            ]
        ),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  cartItem.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      cartItem.productName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          "RM ${cartItem.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        // Quantity Selector
                        QuantitySelector(
                          quantity: quantity,
                          onIncrement: () => cartProvider.updateQuantity(index, quantity + 1),
                          onDecrement: () => cartProvider.updateQuantity(index, quantity - 1),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Total Amount
          Text(
            "Total: RM ${OrderService().calculateTotal(cartProvider.cartItems).toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

                    // Checkout Button
          ElevatedButton(
            onPressed: cartProvider.cartItems.isEmpty ? null : () async {
							final orderId = await cartProvider.checkout();
							cartProvider.clearCart();

							if (!context.mounted) return;
							
              showDialog(
								context: context,
								builder: (context) {
									return AlertDialog(
										title: Text('Checkout Successful'),
										content: Text('Order placed successfully! Order ID: ${orderId.substring(0, 8)}'),
										actions: [
											TextButton(
												onPressed: () => Navigator.of(context).pop(),
												child: Text("OK"),
											),
										],
									);
								}
							);
            },
            child: const Text("Checkout"),
          )
        ],
      ),
    );
  }
}
