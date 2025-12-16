import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/services/order_service.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: FutureBuilder(
				future: OrderService().getAllOrders(),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

					if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load orders: ${snapshot.error}',
              ),
            );
          }

					if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
							child: Text('No orders found.'),
						);
          }

					final orders = snapshot.data!;

					return ListView.builder(
						padding: const EdgeInsets.all(16),
						itemCount: orders.length,
						itemBuilder: (context, index) {
							final order = orders[index];
							final items = order.items;
					
							// === ORDER HISTORY CARD ===
							return Card(
								margin: const EdgeInsets.only(bottom: 16),
								elevation: 2,
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(12),
								),
					
								child: Padding(
									padding: const EdgeInsets.all(16),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
					
											// === ORDER HEADER ===
											Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: [
													Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
					
															// --- Order ID ---
															Text(
																'Order #${order.id.toString()}',
																style: TextStyle(
																	fontWeight: FontWeight.bold,
																	fontSize: 16,
																	color: colorScheme.onSurface,
																),
															),
					
															const SizedBox(height: 4),
					
															// --- Order Created Time ---
															Text(
																order.createdAt.toLocal().toString().split('.')[0],
																style: TextStyle(
																	fontSize: 12,
																	color: colorScheme.onSurface.withAlpha(153),
																),
															),
														],
													),
												],
											),
					
											const Divider(height: 24),
					
											// === ORDER ITEM ===
											ListView.separated(
												shrinkWrap: true,
												physics: const NeverScrollableScrollPhysics(),
												itemCount: items.length,
												separatorBuilder: (context, index) => const SizedBox(height: 16),
												itemBuilder: (context, itemIndex) {
													return Row(
														crossAxisAlignment: CrossAxisAlignment.start,
														spacing: 4,
														children: [
					
															// --- Item Image ---
															ClipRRect(
																borderRadius: BorderRadius.circular(8),
																child: Image.asset(
																	items[itemIndex].imageUrl,
																	width: 60,
																	height: 60,
																	fit: BoxFit.cover,
																),
															),
					
															const SizedBox(width: 12),
					
															// --- Item Details ---
															Expanded(
																child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text(
																			items[itemIndex].productName,
																			style: TextStyle(
																				fontSize: 14,
																				fontWeight: FontWeight.w500,
																				color: colorScheme.onSurface,
																			),
																			maxLines: 2,
																			overflow: TextOverflow.ellipsis,
																		),
																		const SizedBox(height: 4),
																		Text(
																			'Qty: ${items[itemIndex].quantity}',
																			style: TextStyle(
																				fontSize: 12,
																				color: colorScheme.onSurface.withAlpha(153),
																			),
																		),
																	],
																),
															),
					
															// --- Item Price ---
															Text(
																"RM ${(items[itemIndex].price * items[itemIndex].quantity).toStringAsFixed(2)}",
																style: TextStyle(
																	color: colorScheme.primary,
																	fontWeight: FontWeight.bold,
																	fontSize: 14,
																),
															),
														],
													);
												},
											),
					
											const Divider(),
					
											// === ORDER SUMMARY ===
											Column(
												children: [
													// === TOTAL AMOUNT ===
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															Text(
																'Total Amount',
																style: TextStyle(
																	fontWeight: FontWeight.bold,
																	fontSize: 16,
																	color: colorScheme.onSurface,
																),
															),
					
															Text(
																'RM ${order.totalAmount.toStringAsFixed(2)}',
																style: TextStyle(
																	color: colorScheme.primary,
																	fontWeight: FontWeight.bold,
																	fontSize: 16,
																),
															),
														],
													),
												],
											),
					
											const SizedBox(height: 12),
					
											// === SHIPPING ADDRESS ===
											Container(
												padding: const EdgeInsets.all(12),
												decoration: BoxDecoration(
													color: colorScheme.surface,
													borderRadius: BorderRadius.circular(8),
													border: Border.all(
														color: colorScheme.onSurface.withAlpha(26),
													),
												),
												child: Row(
													children: [
														Icon(
															Icons.location_on_outlined,
															size: 20,
															color: colorScheme.onSurface.withAlpha(153),
														),
					
														const SizedBox(width: 8),
					
														Expanded(
															child: Text(
																order.shippingAddress,
																style: TextStyle(
																	fontSize: 12,
																	color: colorScheme.onSurface.withAlpha(153),
																),
																maxLines: 2,
																overflow: TextOverflow.ellipsis,
															),
														),
													],
												),
											),
										],
									),
								),
							);
						},
					);
				}
			),
    );
  }

}