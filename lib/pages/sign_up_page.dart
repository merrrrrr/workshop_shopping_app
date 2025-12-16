import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:workshop_shopping_app/pages/login_page.dart';
import 'package:workshop_shopping_app/services/user_service.dart';
import 'package:workshop_shopping_app/widgets/bottom_nav_bar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
	final _formKey = GlobalKey<FormState>();
	TextEditingController nameController = TextEditingController();
	TextEditingController emailController = TextEditingController();
	TextEditingController phoneNumberController = TextEditingController();
	TextEditingController passwordController = TextEditingController();
	TextEditingController confirmPasswordController = TextEditingController();
	TextEditingController addressController = TextEditingController();

	bool _obscurePassword = true;
	bool _obscureConfirmPassword = true;

	@override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
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

							_buildSignUpForm(context),
						
							ElevatedButton(
								onPressed: () async {
									// Validate user input
									if (_formKey.currentState!.validate()) {
										try {
											// Call createUser function from UserService
											await UserService().createUser(
												nameController.text.trim(),
												emailController.text.trim(),
												phoneNumberController.text.trim(),
												addressController.text.trim(),
												passwordController.text.trim()
											);

											// Wait for Firebase to process auth state
											await Future.delayed(Duration(seconds: 1));
											
											// Show sign up successful message
											ScaffoldMessenger.of(context).showSnackBar(
												SnackBar(content: Text('Sign up successful')),
											);

											// Navigate user to BottomNavBar()
											if (mounted) {
												Navigator.of(context).pushAndRemoveUntil(
													MaterialPageRoute(builder: (context) => const BottomNavBar()),
													(route) => false,
												);
											}
										} catch(e) {
											// Show error message
											if (mounted) {
												ScaffoldMessenger.of(context).showSnackBar(
													SnackBar(content: Text('Sign Up Exception: $e')),
												);
											}
										}
									}
								},
								style: ElevatedButton.styleFrom(
									minimumSize: Size(double.infinity, 48),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8),
									),
								),
								child: Text(
									"Sign Up",
									style: TextStyle(
										fontSize: 16,
										fontWeight: FontWeight.bold,
									),
								),
							),
							
							SizedBox(height: 24),							
							
							RichText(
								text: TextSpan(
									text: "Already have an account? ",
									style: TextStyle(color: Colors.black),
									children: [
										TextSpan(
											text: "Login",
											style: TextStyle(color: Colors.blue),
											recognizer: TapGestureRecognizer()
												..onTap = () {
													Navigator.pushReplacement(
														context,
														MaterialPageRoute(
															builder: (context) => LoginPage(),
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

	Widget _buildSignUpForm(BuildContext context) {
		return Form(
			key: _formKey,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [																		
					TextFormField(
						controller: nameController,
						decoration: InputDecoration(
							labelText: "Name",
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							),
						),
						keyboardType: TextInputType.name,
						validator: (value) {
              if (value == null || value.trim().isEmpty) {
              	return 'Please enter your name';
              }
              return null;
            },
					),
																											
					SizedBox(height: 16),
																											
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
						  if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
							return null;
						},
					),
					
					SizedBox(height: 16),
					
					TextFormField(
						controller: phoneNumberController,
						decoration: InputDecoration(
							labelText: "Phone Number",
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							),
						),
						keyboardType: TextInputType.number,
						validator: (value) {
						  if (value == null || value.trim().isEmpty) {
								return 'Please enter your phone number';
							}
							return null;
						},
					),
			
					SizedBox(height: 16),
					
					TextFormField(
						controller: addressController,
						maxLines: 2,
						decoration: InputDecoration(
							labelText: "Address",
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							),
						),
						keyboardType: TextInputType.streetAddress,
						validator: (value) {
						  if (value == null || value.trim().isEmpty) {
								return 'Please enter your address';
							}
							return null;
						},
					),
					
					SizedBox(height: 16),
																		
					TextFormField(
						controller: passwordController,
						decoration: InputDecoration(
							labelText: "Password",
							suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							),
						),
						obscureText: _obscurePassword,
						validator: (value) {
						  if (value == null || value.trim().isEmpty) {
								return 'Please enter your password';
							}
							if (value.trim().length < 6) {
								return 'Password must be at least 6 characters long';
							}
							return null;
						},
					),
																		
					SizedBox(height: 16),
					
					TextFormField(
						controller: confirmPasswordController,
						decoration: InputDecoration(
							labelText: "Confirm Password",
							suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(8),
							)
						),
						obscureText: _obscureConfirmPassword,
						validator: (value) {
						  if (value == null || value.trim().isEmpty) {
								return 'Please enter your confirm password';
							}
							if (value != passwordController.text) {
								return 'Passwords do not match';
							}
							return null;
						},
					),
																		
					SizedBox(height: 16),
				],
			),
		);

	}
	
}



