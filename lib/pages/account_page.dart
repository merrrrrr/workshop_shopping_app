import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/pages/order_history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
		// Create user instance and firestore instance
		final user = FirebaseAuth.instance.currentUser;
		final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: StreamBuilder(
				stream: firestore.collection("users").doc(user?.uid).snapshots(),
				builder: (context, snapshot) {
					// Handle waiting connection state
					if (snapshot.connectionState == ConnectionState.waiting) {
						return const Center(child: CircularProgressIndicator());
					}

					// Handle no data condition
					if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

					// Get user data, name, email, photo url
					final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] ?? 'User';
          final userEmail = userData['email'] ?? user?.email ?? '';
          final photoUrl = 'https://avatar.iran.liara.run/public';



					return ListView(
						physics: NeverScrollableScrollPhysics(),
						children: [
							_buildProfileHeader(context, userName, userEmail, photoUrl),
					
							const SizedBox(height: 10),
					
							// ======== MENU LIST ========
							Column(
								children: [
									_buildMenuListItem(
											context,
											icon: Icons.person_outline,
											title: 'Profile Information',
											onTap: () {}
									),
					
									_buildMenuListItem(
										context,
										icon: Icons.history,
										title: 'Order History',
										onTap: () => Navigator.push(
												context,
												MaterialPageRoute(
														builder: (context) => OrderHistoryPage()
												)
										),
									),
					
									_buildMenuListItem(
											context,
											icon: Icons.favorite_border,
											title: 'Favourites',
											onTap: () {}
									),
					
									const Divider(),
					
									_buildMenuListItem(
										context,
										icon: Icons.settings_outlined,
										title: 'Settings',
										onTap: () {},
									),
								],
							),
					
							const SizedBox(height: 20),
					
							// ======== LOGOUT BUTTON ========
							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 20.0),
								child: ElevatedButton(
									style: ElevatedButton.styleFrom(
											backgroundColor: Colors.red
									),
									onPressed: () async {
													try {
														await FirebaseAuth.instance.signOut();
														print('User logged out successfully');
													} catch (e) {
														print('Logout error: $e');
													}
												},
									child: Text('Logout',),
								),
							)
						],
					);
				}
			),
    );
  }

  // WIDGET: Profile Header
  Widget _buildProfileHeader(BuildContext context, String userName, String userEmail, String photoUrl) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Individual Menu Item
  Widget _buildMenuListItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary
      ),

      title: Text(title),

      trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface
      ),
      onTap: onTap,
    );
  }
}