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

  final emailController =
  TextEditingController();

  final nameController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final addressController =
  TextEditingController();

  bool isPasswordVisible = false;

  bool isConfirmPasswordVisible = false;

  // =========================
  // EMAIL VALIDATION
  // =========================

  bool isValidEmail(String email) {

    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  // =========================
  // REGISTER USER
  // =========================

  Future<void> registerUser() async {

    final email =
    emailController.text.trim();

    final name =
    nameController.text.trim();

    final password =
    passwordController.text.trim();

    final confirmPassword =
    confirmPasswordController.text
        .trim();

    final phone =
    phoneController.text.trim();

    final address =
    addressController.text.trim();

    // EMPTY CHECK

    if (email.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill in all fields",
          ),
        ),
      );

      return;
    }

    // EMAIL VALIDATION

    if (!isValidEmail(email)) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please enter a valid email",
          ),
        ),
      );

      return;
    }

    // PASSWORD LENGTH

    if (password.length < 6) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Password must be at least 6 characters",
          ),
        ),
      );

      return;
    }

    // PASSWORD MATCH

    if (password != confirmPassword) {

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

    // CHECK DUPLICATE EMAIL

    final existingUser =
    await DatabaseHelper.instance
        .getUserByEmail(email);

    if (existingUser != null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Email already registered",
          ),
        ),
      );

      return;
    }

    // INSERT USER

    await DatabaseHelper.instance
        .registerUser({

      'name': name,

      'email': email,

      'password': password,

      'phone': phone,

      'address': address,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          "Account created successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              "Create Your Account",

              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(

              "Join the community and reduce food waste",

              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            buildInputField(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 18),

            buildInputField(
              controller: emailController,
              hint: "Email Address",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 18),

            buildPasswordField(
              controller:
              passwordController,

              hint: "Password",

              isVisible:
              isPasswordVisible,

              toggle: () {

                setState(() {

                  isPasswordVisible =
                  !isPasswordVisible;
                });
              },
            ),

            const SizedBox(height: 18),

            buildPasswordField(
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

            buildInputField(
              controller: phoneController,
              hint: "Phone Number",
              icon: Icons.phone_outlined,
            ),

            const SizedBox(height: 18),

            buildInputField(
              controller: addressController,
              hint: "Address",
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 35),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: registerUser,

                style: ElevatedButton
                    .styleFrom(

                  backgroundColor:
                  primary,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                child: const Text(

                  "Create Account",

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Center(

              child: GestureDetector(

                onTap: () {
                  Navigator.pop(context);
                },

                child: Text(

                  "Already have an account? Login",

                  style: TextStyle(
                    color: primary,
                    fontWeight:
                    FontWeight.w600,
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

  Widget buildInputField({

    required TextEditingController
    controller,

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
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          prefixIcon: Icon(
            icon,
            color: Colors.grey[700],
          ),

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }

  // =========================
  // PASSWORD FIELD
  // =========================

  Widget buildPasswordField({

    required TextEditingController
    controller,

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
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: TextField(

        controller: controller,

        obscureText: !isVisible,

        decoration: InputDecoration(

          hintText: hint,

          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[700],
          ),

          suffixIcon: IconButton(

            icon: Icon(

              isVisible
                  ? Icons.visibility
                  : Icons.visibility_off,

              color: Colors.grey[700],
            ),

            onPressed: toggle,
          ),

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),

          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }
}