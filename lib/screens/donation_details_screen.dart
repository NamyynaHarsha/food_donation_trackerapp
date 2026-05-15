import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'request_confirmation_screen.dart';

class DonationDetailsScreen
    extends StatefulWidget {

  final Map<String, dynamic> donation;

  final Map<String, dynamic> currentUser;

  const DonationDetailsScreen({
    super.key,
    required this.donation,
    required this.currentUser,
  });

  @override
  State<DonationDetailsScreen> createState() =>
      _DonationDetailsScreenState();
}

class _DonationDetailsScreenState
    extends State<DonationDetailsScreen> {

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    final donorName =
        widget.donation['donorName'] ??
            'Unknown Donor';

    final expiryDate =
        widget.donation['expiryDate'] ?? '';

    // =========================
    // CHECK OWN DONATION
    // =========================

    final isOwnDonation =

        widget.currentUser['email'] ==

            widget.donation['donorEmail'];

    return Scaffold(

      appBar: AppBar(
        backgroundColor: primary,

        centerTitle: true,

        elevation: 0,

        title: const Text(
          'Donation Details',

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),

        actions: [

          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),

            onPressed: () {

              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // IMAGE

            widget.donation['imageUrl'] != null

                ? Image.file(
                    File(
                      widget.donation[
                          'imageUrl'],
                    ),

                    width: double.infinity,
                    height: 260,

                    fit: BoxFit.cover,
                  )

                : Container(
                    height: 260,
                    width: double.infinity,

                    color: Colors.grey[300],

                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 80,
                      ),
                    ),
                  ),

            Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // TITLE

                  Text(
                    widget.donation['title'],

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QUICK INFO

                  Row(
                    children: [

                      Expanded(
                        child: _infoCard(

                          icon:
                              Icons.shopping_bag,

                          label: 'Quantity',

                          value:
                              widget.donation[
                                  'quantity'],
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _infoCard(

                          icon:
                              Icons.location_on,

                          label: 'Location',

                          value:
                              widget.donation[
                                  'location'],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // DONOR CARD

                  Container(
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.grey[100],

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Column(
                      children: [

                        Row(
                          children: [

                            CircleAvatar(
                              radius: 28,

                              backgroundColor:
                                  primary
                                      .withValues(
                                alpha: 0.15,
                              ),

                              child: Text(
                                donorName[0]
                                    .toUpperCase(),

                                style:
                                    TextStyle(
                                  fontSize: 24,

                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  color:
                                      primary,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 16,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(
                                    donorName,

                                    style:
                                        const TextStyle(
                                      fontSize:
                                          18,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    "Food Donor",

                                    style:
                                        TextStyle(
                                      color: Colors
                                              .grey[
                                          600],

                                      fontSize:
                                          13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: primary
                                    .withValues(
                                  alpha: 0.1,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),

                              child: Text(
                                "Verified",

                                style:
                                    TextStyle(
                                  color:
                                      primary,

                                  fontWeight:
                                      FontWeight
                                          .w600,

                                  fontSize:
                                      12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // DONOR CONTACT INFO

                        Row(
                          children: [

                            Icon(
                              Icons.phone,

                              size: 18,

                              color: primary,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Text(
                              widget.donation[
                                      'donorPhone'] ??
                                  '',

                              style:
                                  TextStyle(
                                color: Colors
                                        .grey[
                                    800],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Icon(
                              Icons.location_on,

                              size: 18,

                              color: primary,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child: Text(
                                widget.donation[
                                        'donorAddress'] ??
                                    '',

                                style:
                                    TextStyle(
                                  color: Colors
                                          .grey[
                                      800],

                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // EXPIRY DATE

                  _bigInfoCard(

                    icon:
                        Icons.calendar_today,

                    title: "Expiry Date",

                    value: expiryDate
                        .split(' ')
                        .first,
                  ),

                  const SizedBox(height: 28),

                  // DESCRIPTION TITLE

                  const Text(
                    'Description',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DESCRIPTION

                  Text(
                    widget.donation[
                        'description'],

                    style: TextStyle(
                      height: 1.7,
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // BUTTON

                  SizedBox(
                    width: double.infinity,
                    height: 56,

                    child: ElevatedButton(

                      onPressed:

                          isOwnDonation

                              ? null

                              : () async {

                                  await DatabaseHelper
                                      .instance
                                      .insertRequest({

                                    'donationId':
                                        widget
                                                .donation[
                                            'id'],

                                    'foodTitle':
                                        widget
                                                .donation[
                                            'title'],

                                    'donorId':
                                        widget
                                                .donation[
                                            'donorId'],

                                    'donorName':
                                        donorName,

                                    'donorPhone':
                                        widget
                                                .donation[
                                            'donorPhone'],

                                    'donorAddress':
                                        widget
                                                .donation[
                                            'donorAddress'],

                                    'requesterName':
                                        widget
                                                .currentUser[
                                            'name'],

                                    'requesterPhone':
                                        widget
                                                .currentUser[
                                            'phone'],

                                    'requesterAddress':
                                        widget
                                                .currentUser[
                                            'address'],

                                    'status':
                                        'Pending',

                                    'requestDate':
                                        DateTime.now()
                                            .toString(),
                                  });

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RequestConfirmationScreen(
                                        donorName:
                                            donorName,
                                      ),
                                    ),
                                  );
                                },

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            isOwnDonation
                                ? Colors.grey
                                : primary,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),

                      child: Text(

                        isOwnDonation
                            ? 'Your Donation'
                            : 'Request Food',

                        style: const TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,

                color: const Color(
                    0xFF2E7D32),

                size: 20,
              ),

              const SizedBox(width: 8),

              Text(
                label,

                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.grey[100],

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          CircleAvatar(
            backgroundColor:
                Colors.green.withValues(
              alpha: 0.12,
            ),

            child: Icon(
              icon,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}