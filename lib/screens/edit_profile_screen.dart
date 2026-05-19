import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/database_helper.dart';

class EditProfileScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final _formKey =
  GlobalKey<FormState>();

  late TextEditingController
  nameController;

  late TextEditingController
  phoneController;

  late TextEditingController
  addressController;

  String? imagePath;

  @override
  void initState() {

    super.initState();

    nameController =
        TextEditingController(
          text: widget.user['name'],
        );

    phoneController =
        TextEditingController(
          text: widget.user['phone'],
        );

    addressController =
        TextEditingController(
          text: widget.user['address'],
        );

    imagePath =
    widget.user['profileImage'];
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage() async {

    final pickedFile =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {

      setState(() {

        imagePath =
            pickedFile.path;
      });
    }
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<void> updateProfile() async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final updatedUser = {

      'name':
      nameController.text.trim(),

      'phone':
      phoneController.text.trim(),

      'address':
      addressController.text.trim(),

      'profileImage':
      imagePath,
    };

    await DatabaseHelper.instance
        .updateUserProfile(

      widget.user['id'],

      updatedUser,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
        Text('Profile updated'),
      ),
    );
    Navigator.pop(

      context,

      {

        ...widget.user,

        'name':
        nameController.text.trim(),

        'phone':
        phoneController.text.trim(),

        'address':
        addressController.text.trim(),

        'profileImage':
        imagePath,
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return Scaffold(

      appBar: AppBar(

        backgroundColor:
        primary,

        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        iconTheme:
        const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(
            children: [

              // =========================
              // PROFILE IMAGE
              // =========================

              Stack(
                children: [

                  CircleAvatar(

                    radius: 60,

                    backgroundColor:
                    Colors.green
                        .withValues(
                      alpha: 0.15,
                    ),

                    backgroundImage:
                    imagePath != null
                        ? FileImage(
                      File(
                        imagePath!,
                      ),
                    )
                        : null,

                    child:
                    imagePath == null

                        ? Text(

                      widget.user[
                      'name'][0]
                          .toUpperCase(),

                      style:
                      TextStyle(
                        fontSize: 42,

                        fontWeight:
                        FontWeight
                            .bold,

                        color:
                        primary,
                      ),
                    )

                        : null,
                  ),

                  Positioned(

                    bottom: 0,
                    right: 0,

                    child: GestureDetector(

                      onTap: pickImage,

                      child: Container(

                        padding:
                        const EdgeInsets
                            .all(10),

                        decoration:
                        BoxDecoration(

                          color: primary,

                          shape:
                          BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.edit,
                          color:
                          Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height: 40),

              // =========================
              // NAME
              // =========================

              TextFormField(

                controller:
                nameController,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter name';
                  }

                  return null;
                },

                decoration:
                InputDecoration(

                  labelText: 'Name',

                  prefixIcon:
                  const Icon(
                    Icons.person,
                  ),

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius
                        .circular(16),
                  ),
                ),
              ),

              const SizedBox(
                  height: 20),

              // =========================
              // PHONE
              // =========================

              TextFormField(

                controller:
                phoneController,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter phone';
                  }

                  return null;
                },

                decoration:
                InputDecoration(

                  labelText:
                  'Phone Number',

                  prefixIcon:
                  const Icon(
                    Icons.phone,
                  ),

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius
                        .circular(16),
                  ),
                ),
              ),

              const SizedBox(
                  height: 20),

              // =========================
              // ADDRESS
              // =========================

              TextFormField(

                controller:
                addressController,

                maxLines: 3,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter address';
                  }

                  return null;
                },

                decoration:
                InputDecoration(

                  labelText: 'Address',

                  prefixIcon:
                  const Icon(
                    Icons.location_on,
                  ),

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius
                        .circular(16),
                  ),
                ),
              ),

              const SizedBox(
                  height: 40),

              // =========================
              // SAVE BUTTON
              // =========================

              SizedBox(

                width: double.infinity,
                height: 55,

                child:
                ElevatedButton(

                  onPressed:
                  updateProfile,

                  style:
                  ElevatedButton
                      .styleFrom(

                    backgroundColor:
                    primary,

                    foregroundColor:
                    Colors.white,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        16,
                      ),
                    ),
                  ),

                  child: const Text(

                    'Save Changes',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}