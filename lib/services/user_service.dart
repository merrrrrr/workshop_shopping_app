// Import Firebase Auth package
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_shopping_app/models/user.dart';

class UserService {
	// Create Firebase Auth instance
	final _auth = FirebaseAuth.instance;
	// Create Firestore instance
	final _firestore = FirebaseFirestore.instance;

	// Get current user ID
	String get currentUserId {
		final user = _auth.currentUser;
		if (user == null) {
			throw Exception('No authenticated user found.');
		}
		return user.uid;
	}

	// Get user collection
	CollectionReference get _usersCollection => _firestore.collection('users');

	// Update parameters in this function
	Future<void> createUser(String name, String email, String phoneNumber, String address, String password) async {
		try {
			// Create user with email and password
			await _auth.createUserWithEmailAndPassword(
				email: email,
				password: password
			);

			// Create user object
			final user = User(
				name: name,
				email: email,
				phoneNumber: phoneNumber,
				photoUrl: '',
				address: address,
				createdAt: DateTime.now(),
			);

			// Convert to map format
			final userMap = user.toMap();
			// Add user into collection
			await _usersCollection.doc(currentUserId).set(userMap);

		} on FirebaseAuthException catch(e) {
			// Print and throw Firebase Auth error message
      print("Firebase Auth Exception: ${e.message}");
      throw Exception("Firebase Auth Exception: ${e.message}");
      
		} catch(e) {
			// Print and throw other error
			print("Exception: $e");
			throw Exception(e);
		}
	}

	Future<void> loginUser(String email, String password) async {
		try {
			// User login with email and password
			await _auth.signInWithEmailAndPassword(
				email: email,
				password: password
			);
	
		} on FirebaseAuthException catch (e) {
			// Print and throw Firebase Auth error message
			print("Firebase Auth Exception: ${e.message}");
			throw Exception("Firebase Auth Exception: ${e.message}");
			
		} catch(e) {
			// Print and throw other error
			print("Exception: $e");
			throw Exception(e);
		}
	}

	Future<User> getUser() async {
		try {
			// Get user data
			DocumentSnapshot snapshot = await _usersCollection.doc(currentUserId).get();
			if (!snapshot.exists) {
				throw Exception('User data not found.');
			}
			// Convert from map format to User object and return
			return User.fromMap(snapshot.data() as Map<String, dynamic>);
		} catch(e) {
			print('Error fetching user data: $e');
			throw Exception('Failed to fetch user data.');
		}
	}
}