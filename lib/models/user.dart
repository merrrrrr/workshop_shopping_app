import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final String address;
  final DateTime createdAt;

  User({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.address,
    required this.createdAt,
  });

	// Convert Object → Map (for saving to Firestore)
	Map<String, dynamic> toMap() {
		return {
			'name': name,
			'email': email,
			'phoneNumber': phoneNumber,
			'photoUrl': photoUrl,
			'address': address,
			'createdAt': Timestamp.fromDate(createdAt),
		};
	}

	// Convert Map → Object (for reading from Firestore)
	factory User.fromMap(Map<String, dynamic> map) {
		return User(
			name: map['name'],
			email: map['email'],
			phoneNumber: map['phoneNumber'],
			photoUrl: map['photoUrl'],
			address: map['address'],
			createdAt: (map['createdAt'] as Timestamp).toDate(),
		);
	}

}