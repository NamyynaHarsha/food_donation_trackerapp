import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState
    extends State<RegistrationScreen> {

  final emailController = TextEditingController();

  final nameController = TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  final phoneController = TextEditingController();

  final addressController =
      TextEditingController();

  bool isPasswordVisible = false;

  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      backgroundColor:
          Theme.of(context).colorScheme.background,

      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Create Your Account",

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Fill in your details to continue",

              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 25),

            buildInput(
              controller: emailController,
              hint: "Email",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 18),

            buildInput(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 18),

            buildPasswordInput(
              controller: passwordController,
              hint: "Password",

              isVisible: isPasswordVisible,

              toggle: () {

                setState(() {
                  isPasswordVisible =
                      !isPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 18),

            buildPasswordInput(
              controller:
                  confirmPasswordController,

              hint: "Confirm Password",

              isVisible:
                  isConfirmPasswordVisible,

              toggle: () {

                setState(() {

                  isConfirmPasswordVisible =
                      !isConfirmPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 18),

            buildInput(
              controller: phoneController,
              hint: "Phone Number",
              icon: Icons.phone_outlined,
            ),

            const SizedBox(height: 18),

            buildInput(
              controller: addressController,
              hint: "Address",
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  elevation: 4,
                ),

                onPressed: () async {

                  if (emailController.text.isEmpty ||
                      nameController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController
                          .text
                          .isEmpty) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Please fill in all required fields",
                        ),
                      ),
                    );

                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Passwords do not match",
                        ),
                      ),
                    );

                    return;
                  }

                  await DatabaseHelper.instance
                      .registerUser({

                    'name': nameController.text,

                    'email': emailController.text,

                    'password':
                        passwordController.text,

                    'phone': phoneController.text,

                    'address':
                        addressController.text,
                  });

                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Account Created Successfully",
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text(

                  "Create Account",

                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(

                onTap: () {
                  Navigator.pop(context);
                },

                child: Text(

                  "Already have an account? Login",

                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================
  // INPUT FIELD
  // =========================

  Widget buildInput({

    required TextEditingController controller,

    required String hint,

    required IconData icon,
  }) {

    return Container(

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),

          prefixIcon: Icon(
            icon,
            color: Colors.grey[700],
          ),

          filled: true,

          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 18,
          ),

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // =========================
  // PASSWORD FIELD
  // =========================

  Widget buildPasswordInput({

    required TextEditingController controller,

    required String hint,

    required bool isVisible,

    required VoidCallback toggle,
  }) {

    return Container(

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(

        controller: controller,

        obscureText: !isVisible,

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),

          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[700],
          ),

          suffixIcon: IconButton(

            icon: Icon(

              isVisible
                  ? Icons.visibility
                  : Icons.visibility_off,

              color: Colors.grey[600],
            ),

            onPressed: toggle,
          ),

          filled: true,

          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 18,
          ),

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}