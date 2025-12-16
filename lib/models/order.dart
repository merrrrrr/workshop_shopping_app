import 'package:workshop_shopping_app/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final String userId;
  final List<Item> items;
  final double totalAmount;
  final String shippingAddress;
  final DateTime createdAt;

  Order({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.createdAt,
  });

	  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
			'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Order(
      id: docId,
      userId: map['userId'],
			items: (map['items'] as List).map((item) => Item.fromMap(item)).toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      shippingAddress: map['shippingAddress'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}