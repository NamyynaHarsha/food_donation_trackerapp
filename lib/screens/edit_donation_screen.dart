import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/database_helper.dart';

class EditDonationScreen
    extends StatefulWidget {

  final Map<String, dynamic> donation;

  const EditDonationScreen({
    super.key,
    required this.donation,
  });

  @override
  State<EditDonationScreen>
  createState() =>
      _EditDonationScreenState();
}

class _EditDonationScreenState
    extends State<EditDonationScreen> {

  final _formKey =
  GlobalKey<FormState>();

  final titleController =
  TextEditingController();

  final quantityController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final locationController =
  TextEditingController();

  final expiryDateController =
  TextEditingController();

  File? selectedImage;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    loadDonationData();
  }

  // =========================
  // LOAD DATA
  // =========================

  void loadDonationData() {

    titleController.text =
        widget.donation['title'] ?? '';

    quantityController.text =
        widget.donation['quantity'] ?? '';

    descriptionController.text =
        widget.donation['description'] ?? '';

    locationController.text =
        widget.donation['location'] ?? '';

    expiryDateController.text =
        widget.donation['expiryDate']
            ?.toString()
            .split(' ')
            .first ??
            '';

    if (widget.donation['imageUrl'] !=
        null &&
        widget.donation['imageUrl']
            .toString()
            .isNotEmpty) {

      selectedImage = File(
        widget.donation['imageUrl'],
      );
    }
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage() async {

    final picker =
    ImagePicker();

    final picked =
    await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      setState(() {

        selectedImage =
            File(picked.path);
      });
    }
  }

  // =========================
  // PICK DATE
  // =========================

  Future<void> pickDate() async {

    final pickedDate =
    await showDatePicker(

      context: context,

      initialDate:
      DateTime.now(),

      firstDate:
      DateTime.now(),

      lastDate:
      DateTime(2030),
    );

    if (pickedDate != null) {

      expiryDateController.text =
          pickedDate
              .toString()
              .split(' ')
              .first;
    }
  }

  // =========================
  // UPDATE DONATION
  // =========================

  Future<void> updateDonation()
  async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {

      isSaving = true;
    });

    await DatabaseHelper.instance
        .updateDonation(

      widget.donation['id'],

      {

        'title':
        titleController.text
            .trim(),

        'quantity':
        quantityController.text
            .trim(),

        'description':
        descriptionController
            .text
            .trim(),

        'location':
        locationController.text
            .trim(),

        'expiryDate':
        expiryDateController
            .text,

        'imageUrl':
        selectedImage?.path ??
            '',
      },
    );

    if (!mounted) return;

    setState(() {

      isSaving = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content: Text(
          'Donation updated successfully',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final primary =
    const Color(0xFF2E7D32);

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F5F5),

      appBar: AppBar(

        backgroundColor: primary,

        elevation: 0,

        title: const Text(

          'Edit Donation',

          style: TextStyle(

            color: Colors.white,

            fontWeight:
            FontWeight.bold,
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

            crossAxisAlignment:
            CrossAxisAlignment
                .start,

            children: [

              // =========================
              // IMAGE
              // =========================

              GestureDetector(

                onTap: pickImage,

                child: Container(

                  height: 220,

                  width: double.infinity,

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),
                  ),

                  child:
                  selectedImage !=
                      null

                      ? ClipRRect(

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),

                    child:
                    Image.file(

                      selectedImage!,

                      fit:
                      BoxFit.cover,
                    ),
                  )

                      : Column(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [

                      Icon(

                        Icons
                            .add_photo_alternate,

                        size: 60,

                        color:
                        primary,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(

                        'Tap to change image',

                        style:
                        TextStyle(

                          color:
                          Colors.grey[
                          700],

                          fontSize:
                          16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // =========================
              // TITLE
              // =========================

              buildTextField(

                controller:
                titleController,

                label:
                'Food Title',

                icon:
                Icons.fastfood,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter food title';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 18,
              ),

              // =========================
              // QUANTITY
              // =========================

              buildTextField(

                controller:
                quantityController,

                label:
                'Quantity',

                icon:
                Icons.shopping_bag,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter quantity';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 18,
              ),

              // =========================
              // LOCATION
              // =========================

              buildTextField(

                controller:
                locationController,

                label:
                'Location',

                icon:
                Icons.location_on,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter location';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 18,
              ),

              // =========================
              // EXPIRY DATE
              // =========================

              TextFormField(

                controller:
                expiryDateController,

                readOnly: true,

                onTap: pickDate,

                decoration:
                InputDecoration(

                  labelText:
                  'Expiry Date',

                  prefixIcon:
                  const Icon(
                    Icons.calendar_today,
                  ),

                  filled: true,

                  fillColor:
                  Colors.white,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                    borderSide:
                    BorderSide.none,
                  ),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Select expiry date';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 18,
              ),

              // =========================
              // DESCRIPTION
              // =========================

              TextFormField(

                controller:
                descriptionController,

                maxLines: 5,

                decoration:
                InputDecoration(

                  labelText:
                  'Description',

                  alignLabelWithHint:
                  true,

                  prefixIcon:
                  const Padding(

                    padding:
                    EdgeInsets.only(
                      bottom: 80,
                    ),

                    child: Icon(
                      Icons.description,
                    ),
                  ),

                  filled: true,

                  fillColor:
                  Colors.white,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                    borderSide:
                    BorderSide.none,
                  ),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return 'Enter description';
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 34,
              ),

              // =========================
              // SAVE BUTTON
              // =========================

              SizedBox(

                width:
                double.infinity,

                height: 58,

                child: ElevatedButton(

                  onPressed:

                  isSaving
                      ? null
                      : updateDonation,

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    primary,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  child:
                  isSaving

                      ? const SizedBox(

                    width: 24,

                    height: 24,

                    child:
                    CircularProgressIndicator(

                      color:
                      Colors.white,

                      strokeWidth:
                      2,
                    ),
                  )

                      : const Text(

                    'Save Changes',

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.w600,

                      color:
                      Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // TEXT FIELD
  // =========================

  Widget buildTextField({

    required TextEditingController
    controller,

    required String label,

    required IconData icon,

    required String? Function(
        String?,
        )
    validator,

  }) {

    return TextFormField(

      controller: controller,

      validator: validator,

      decoration: InputDecoration(

        labelText: label,

        prefixIcon:
        Icon(icon),

        filled: true,

        fillColor:
        Colors.white,

        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(
            18,
          ),

          borderSide:
          BorderSide.none,
        ),
      ),
    );
  }
}