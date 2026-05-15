import 'package:flutter/material.dart';

import '../database/database_helper.dart';

import 'main_navigation.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      backgroundColor:
          Theme.of(context).colorScheme.background,

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 28,
            ),

            child: Column(
              children: [

                Image.asset(
                  'assets/images/logo.png',
                  height: 170,
                ),

                const SizedBox(height: 40),

                buildInputField(
                  controller: emailController,
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                buildPasswordField(),

                const SizedBox(height: 12),

                Align(
                  alignment:
                      Alignment.centerRight,

                  child: Text(
                    "Forgot Password?",

                    style: TextStyle(
                      color: primary,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton(

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          primary,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                18),
                      ),

                      elevation: 3,
                    ),

                    onPressed: () async {

                      if (emailController
                              .text
                              .isEmpty ||
                          passwordController
                              .text
                              .isEmpty) {

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(

                          const SnackBar(
                            content: Text(
                              "Please fill in all fields",
                            ),
                          ),
                        );

                        return;
                      }

                      final user =
                          await DatabaseHelper
                              .instance
                              .loginUser(

                        emailController.text,

                        passwordController.text,
                      );

                      if (user != null) {

                        Navigator.pushReplacement(
                          context,

                          MaterialPageRoute(
                            builder: (_) => MainNavigation(
                              user: user,
                            ),
                          ),
                        );

                      } else {

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(

                          const SnackBar(
                            content: Text(
                              "Invalid Email or Password",
                            ),
                          ),
                        );
                      }
                    },

                    child: const Text(

                      "Login",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Text(
                      "Don’t have an account? ",

                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),

                    GestureDetector(

                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const RegistrationScreen(),
                          ),
                        );
                      },

                      child: Text(

                        "Register",

                        style: TextStyle(
                          color: primary,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // INPUT FIELD
  // =========================

  Widget buildInputField({

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
            color:
                Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 10,

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

  Widget buildPasswordField() {

    return Container(

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: TextField(

        controller: passwordController,

        obscureText: !isPasswordVisible,

        decoration: InputDecoration(

          hintText: "Password",

          hintStyle: TextStyle(
            color: Colors.grey[500],
          ),

          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[700],
          ),

          suffixIcon: IconButton(

            icon: Icon(

              isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,

              color: Colors.grey[600],
            ),

            onPressed: () {

              setState(() {

                isPasswordVisible =
                    !isPasswordVisible;
              });
            },
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