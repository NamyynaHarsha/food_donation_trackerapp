import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/database_helper.dart';

class PostDonationScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const PostDonationScreen({
    super.key,
    required this.user,
  });

  @override
  State<PostDonationScreen> createState() =>
      _PostDonationScreenState();
}

class _PostDonationScreenState
    extends State<PostDonationScreen> {

  final titleController =
      TextEditingController();

  final quantityController =
      TextEditingController();

  final locationController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  DateTime? selectedDate;

  File? selectedImage;

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

        selectedImage = File(
          pickedFile.path,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .colorScheme
              .background,

      appBar: AppBar(

        leading: IconButton(

          icon: const Icon(
            Icons.arrow_back,
          ),

          onPressed: () =>
              Navigator.pop(context),
        ),

        title: const Text(
          "Post a Donation",
        ),

        centerTitle: false,

        elevation: 0,

        backgroundColor:
            Theme.of(context)
                .colorScheme
                .background,

        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              "Share food with those in need",

              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // IMAGE UPLOAD
            // =========================

            GestureDetector(

              onTap: pickImage,

              child: Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 35,
                ),

                decoration: BoxDecoration(

                  borderRadius:
                      BorderRadius.circular(20),

                  border: Border.all(
                    color: primary,
                    width: 2,
                  ),
                ),

                child: selectedImage != null

                    ? ClipRRect(

                        borderRadius:
                            BorderRadius.circular(15),

                        child: Image.file(

                          selectedImage!,

                          height: 200,

                          width: double.infinity,

                          fit: BoxFit.cover,
                        ),
                      )

                    : Column(
                        children: [

                          CircleAvatar(

                            radius: 30,

                            backgroundColor:
                                primary.withValues(
                              alpha: 0.1,
                            ),

                            child: Icon(
                              Icons.camera_alt,
                              color: primary,
                              size: 28,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Upload Photo",

                            style: TextStyle(
                              color: primary,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "Add a clear photo of the food",

                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),

                          Text(
                            "JPG, PNG up to 5MB",

                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 25),

            // FOOD TITLE

            buildField(

              label: "Food Title",

              hint:
                  "e.g., Cooked Biryani, Veg Curry",

              icon: Icons.fastfood_outlined,

              controller: titleController,

              primary: primary,
            ),

            const SizedBox(height: 20),

            // QUANTITY

            buildField(

              label: "Quantity",

              hint:
                  "e.g., 5 kg, 10 servings, 3 packs",

              icon:
                  Icons.inventory_2_outlined,

              controller:
                  quantityController,

              primary: primary,
            ),

            const SizedBox(height: 20),

            // DESCRIPTION

            buildField(

              label: "Description",

              hint:
                  "Enter food description",

              icon:
                  Icons.description_outlined,

              controller:
                  descriptionController,

              primary: primary,
            ),

            const SizedBox(height: 20),

            // DATE

            buildDateField(primary),

            const SizedBox(height: 20),

            // LOCATION

            buildField(

              label: "Pickup Location",

              hint:
                  "Enter full pickup address",

              icon:
                  Icons.location_on_outlined,

              controller:
                  locationController,

              primary: primary,

              showTargetIcon: true,
            ),

            const SizedBox(height: 20),

            // SAFETY BOX

            Container(

              padding:
                  const EdgeInsets.all(15),

              decoration: BoxDecoration(

                color: primary.withValues(
                  alpha: 0.08,
                ),

                borderRadius:
                    BorderRadius.circular(15),
              ),

              child: Row(
                children: [

                  CircleAvatar(

                    radius: 18,

                    backgroundColor: primary,

                    child: const Icon(
                      Icons.shield,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Ensure the food is fresh, properly packed, and safe to eat.",

                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // POST BUTTON

            SizedBox(

              width: double.infinity,

              child: ElevatedButton.icon(

                icon: const Icon(
                  Icons.send,
                ),

                label:
                    const Text("Post Donation"),

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor: primary,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                onPressed: () async {

                  if (titleController
                          .text
                          .isEmpty ||
                      quantityController
                          .text
                          .isEmpty ||
                      locationController
                          .text
                          .isEmpty ||
                      descriptionController
                          .text
                          .isEmpty ||
                      selectedDate == null ||
                      selectedImage == null) {

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

                  // =========================
                  // INSERT DONATION
                  // =========================

                  await DatabaseHelper
                      .instance
                      .insertDonation({

                    'title':
                        titleController.text,

                    'quantity':
                        quantityController.text,

                    'description':
                        descriptionController.text,

                    'location':
                        locationController.text,

                    'expiryDate':
                        selectedDate.toString(),

                    'imageUrl':
                        selectedImage!.path,

                    // DONOR INFO
                    'donorId':
                        widget.user['id'],

                    'donorName':
                        widget.user['name'],

                    'donorEmail':
                        widget.user['email'],

                    'donorPhone':
                        widget.user['phone'],
                    
                    'donorAddress':
                        widget.user['address'],
                        
                  });

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Donation Posted Successfully",
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },
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

  Widget buildField({

    required String label,

    required String hint,

    required IconData icon,

    required TextEditingController controller,

    required Color primary,

    bool showTargetIcon = false,
  }) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(15),
          ),

          child: Row(
            children: [

              Icon(
                icon,
                color: primary,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: TextField(

                  controller: controller,

                  decoration: InputDecoration(

                    hintText: hint,

                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),

                    border: InputBorder.none,
                  ),
                ),
              ),

              if (showTargetIcon)

                Icon(
                  Icons.my_location,
                  color: primary,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // DATE FIELD
  // =========================

  Widget buildDateField(
    Color primary,
  ) {

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          "Expiry Date",

          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        GestureDetector(

          onTap: () async {

            DateTime? picked =
                await showDatePicker(

              context: context,

              initialDate:
                  DateTime.now(),

              firstDate:
                  DateTime.now(),

              lastDate:
                  DateTime(2100),
            );

            if (picked != null) {

              setState(() {
                selectedDate = picked;
              });
            }
          },

          child: Container(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Row(
              children: [

                Icon(
                  Icons.calendar_today,
                  color: primary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(

                    selectedDate == null

                        ? "Select expiry date"

                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),

                Icon(
                  Icons.calendar_month,
                  color: primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}