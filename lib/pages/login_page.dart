import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/pages/sign_up_page.dart';
import 'package:workshop_shopping_app/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final _formKey = GlobalKey<FormState>();
	TextEditingController emailController = TextEditingController();
	TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

	@override
	void dispose() {
		emailController.dispose();
		passwordController.dispose();
		super.dispose();
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: Center(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(16.0),
					child: Column(
						children: [
							Text(
								"Jiji",
								style: TextStyle(
									fontSize: 32,
									fontWeight: FontWeight.bold,
									color: Theme.of(context).colorScheme.primary,
								),
							),

							SizedBox(height: 24),

							_buildLoginForm(context),

							SizedBox(height: 20),
						
							ElevatedButton(
								onPressed: () async {
									// Validate user input
									if (_formKey.currentState!.validate()) {
										try {
											// Call createUser function from UserService
											await UserService().loginUser(
												emailController.text.trim(),
												passwordController.text.trim()
											);
											// Show login successful message
											ScaffoldMessenger.of(context).showSnackBar(
												SnackBar(content: Text('Login successful')),
											);
										} catch (e) {
											// Show error message
											ScaffoldMessenger.of(context).showSnackBar(
												SnackBar(content: Text('Login Exception: $e')),
											);
										}
									}
								},
								style: ElevatedButton.styleFrom(
									minimumSize: Size(double.infinity, 48),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8),
									),
								),
								child: Text("Login")
							),

							SizedBox(height: 20),
						
							RichText(
								text: TextSpan(
									text: "Don't have an account? ",
									style: TextStyle(color: Colors.black),
									children: [
										TextSpan(
											text: "Sign Up",
											style: TextStyle(color: Colors.blue),
											recognizer: TapGestureRecognizer()
												..onTap = () {
													Navigator.pushReplacement(
														context,
														MaterialPageRoute(
															builder: (context) => SignUpPage(),
														),	
													);
												},
										)
									]
								)
							)
						],
					)
				),
			)
		);
  }

	Widget _buildLoginForm(BuildContext context) {
		return Form(
			key: _formKey,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					TextFormField(
						controller: emailController,
						decoration: InputDecoration(
							labelText: "Email",
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							),
						),
						keyboardType: TextInputType.emailAddress,
						validator: (value) {
							if (value == null || value.isEmpty) {
								return "Please enter your email";
							}
							return null;
						}
					),

					SizedBox(height: 16),
					
					TextFormField(
						controller: passwordController,
						decoration: InputDecoration(
							labelText: "Password",
							suffixIcon: IconButton(
								onPressed: () {
									setState(() => _obscurePassword = !_obscurePassword);
								},
								icon: Icon(
									_obscurePassword ? Icons.visibility_off : Icons.visibility
								)
							),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							)
						),
						obscureText: _obscurePassword,
						validator: (value) {
							if (value == null || value.isEmpty) {
								return "Please enter your password";
							}
							return null;
						}
					)
				],
			)
		);
	}
}