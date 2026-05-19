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
  State<DonationDetailsScreen>
  createState() =>
      _DonationDetailsScreenState();
}

class _DonationDetailsScreenState
    extends State<DonationDetailsScreen> {

  bool isLoading = false;

  bool hasRequested = false;

  Map<String, dynamic>? donor;

  @override
  void initState() {
    super.initState();

    loadDonor();

    checkRequestStatus();
  }

  // =========================
  // LOAD DONOR
  // =========================

  Future<void> loadDonor() async {

    final donorData =
    await DatabaseHelper.instance
        .getUserById(
      widget.donation['donorId'],
    );

    if (mounted) {

      setState(() {

        donor = donorData;
      });
    }
  }

  // =========================
  // CHECK REQUEST
  // =========================

  Future<void> checkRequestStatus()
  async {

    final alreadyRequested =
    await DatabaseHelper.instance
        .hasUserRequested(

      widget.donation['id'],

      widget.currentUser['id'],
    );

    if (mounted) {

      setState(() {

        hasRequested =
            alreadyRequested;
      });
    }
  }

  // =========================
  // REQUEST FOOD
  // =========================

  Future<void> requestFood()
  async {

    try {

      setState(() {
        isLoading = true;
      });

      final alreadyRequested =
      await DatabaseHelper.instance
          .hasUserRequested(

        widget.donation['id'],

        widget.currentUser['id'],
      );

      if (alreadyRequested) {

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              'You already requested this donation',
            ),
          ),
        );

        setState(() {
          isLoading = false;
        });

        return;
      }

      await DatabaseHelper.instance
          .insertRequest({

        'donationId':
        widget.donation['id'],

        'foodTitle':
        widget.donation['title'],

        'donorId':
        widget.donation['donorId'],

        'donorName':
        donor?['name'] ?? '',

        'donorPhone':
        donor?['phone'] ?? '',

        'donorAddress':
        donor?['address'] ?? '',

        'requesterId':
        widget.currentUser['id'],

        'requesterName':
        widget.currentUser['name'],

        'requesterPhone':
        widget.currentUser['phone'],

        'requesterAddress':
        widget.currentUser['address'],

        'status': 'Pending',

        'requestDate':
        DateTime.now().toString(),
      });

      if (!mounted) return;

      setState(() {

        hasRequested = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Request sent successfully',
          ),
        ),
      );

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              RequestConfirmationScreen(

                donorName:
                donor?['name'] ??
                    'Donor',
              ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {

          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final primary =
    const Color(0xFF2E7D32);

    final isOwnDonation =

        widget.currentUser['id'] ==

            widget.donation['donorId'];

    return Scaffold(

      backgroundColor:
      Colors.white,

      appBar: AppBar(

        backgroundColor: primary,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          'Donation Details',

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

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =========================
            // IMAGE
            // =========================

            widget.donation['imageUrl'] !=
                null &&
                widget
                    .donation['imageUrl']
                    .toString()
                    .isNotEmpty

                ? Image.file(

              File(
                widget.donation[
                'imageUrl'],
              ),

              width:
              double.infinity,

              height: 260,

              fit: BoxFit.cover,
            )

                : Container(

              width:
              double.infinity,

              height: 260,

              color:
              Colors.grey[300],

              child:
              const Center(

                child: Icon(
                  Icons.image,
                  size: 80,
                ),
              ),
            ),

            Padding(

              padding:
              const EdgeInsets.all(
                20,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  // =========================
                  // TITLE
                  // =========================

                  Text(

                    widget.donation['title']
                        ??
                        '',

                    style:
                    const TextStyle(

                      fontSize: 32,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // =========================
                  // INFO ROW
                  // =========================

                  Row(

                    children: [

                      Expanded(

                        child: _infoCard(

                          icon:
                          Icons.shopping_bag,

                          label:
                          'Quantity',

                          value:
                          widget.donation[
                          'quantity'] ??
                              '',
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      Expanded(

                        child: _infoCard(

                          icon:
                          Icons.location_on,

                          label:
                          'Location',

                          value:
                          widget.donation[
                          'location'] ??
                              '',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 26,
                  ),

                  // =========================
                  // DONOR CARD
                  // =========================

                  Container(

                    padding:
                    const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.grey[100],

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

                              radius: 30,

                              backgroundColor:
                              primary
                                  .withOpacity(
                                0.15,
                              ),

                              backgroundImage:
                              donor?[
                              'profileImage'] !=
                                  null &&
                                  donor![
                                  'profileImage']
                                      .toString()
                                      .isNotEmpty

                                  ? FileImage(

                                File(
                                  donor![
                                  'profileImage'],
                                ),
                              )

                                  : null,

                              child:
                              donor?[
                              'profileImage'] ==
                                  null ||
                                  donor![
                                  'profileImage']
                                      .toString()
                                      .isEmpty

                                  ? Text(

                                donor?['name']
                                    ?.substring(
                                  0,
                                  1,
                                )
                                    .toUpperCase() ??
                                    '?',

                                style:
                                TextStyle(

                                  fontSize:
                                  24,

                                  fontWeight:
                                  FontWeight.bold,

                                  color:
                                  primary,
                                ),
                              )

                                  : null,
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

                                    donor?['name'] ??
                                        'Donor',

                                    style:
                                    const TextStyle(

                                      fontSize: 20,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(

                                    "Food Donor",

                                    style:
                                    TextStyle(

                                      color:
                                      Colors.grey[
                                      600],

                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal:
                                12,

                                vertical: 6,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                primary.withOpacity(
                                  0.12,
                                ),

                                borderRadius:
                                BorderRadius.circular(
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
                                  FontWeight.w600,

                                  fontSize:
                                  12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        Row(

                          children: [

                            Icon(

                              Icons.phone,

                              color:
                              primary,

                              size: 18,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Text(

                              donor?['phone'] ??
                                  '',
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

                              color:
                              primary,

                              size: 18,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(

                              child: Text(

                                donor?['address'] ??
                                    '',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  // =========================
                  // EXPIRY
                  // =========================

                  _bigInfoCard(

                    icon:
                    Icons.calendar_today,

                    title:
                    'Expiry Date',

                    value:
                    widget.donation[
                    'expiryDate']
                        .toString()
                        .split(' ')
                        .first,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // =========================
                  // DESCRIPTION
                  // =========================

                  const Text(

                    'Description',

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(

                    widget.donation[
                    'description'] ??
                        '',

                    style: TextStyle(

                      fontSize: 15,

                      height: 1.7,

                      color:
                      Colors.grey[800],
                    ),
                  ),

                  const SizedBox(
                    height: 36,
                  ),

                  // =========================
                  // BUTTON
                  // =========================

                  SizedBox(

                    width:
                    double.infinity,

                    height: 58,

                    child:
                    ElevatedButton(

                      onPressed:

                      isOwnDonation ||
                          hasRequested ||
                          isLoading

                          ? null

                          : requestFood,

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:

                        isOwnDonation ||
                            hasRequested

                            ? Colors.grey

                            : primary,

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      child: isLoading

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

                          : Text(

                        isOwnDonation

                            ? 'Your Donation'

                            : hasRequested

                            ? 'Already Requested'

                            : 'Request Food',

                        style:
                        const TextStyle(

                          fontSize: 17,

                          fontWeight:
                          FontWeight.w600,

                          color:
                          Colors.white,
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

  // =========================
  // SMALL INFO CARD
  // =========================

  Widget _infoCard({

    required IconData icon,

    required String label,

    required String value,

  }) {

    return Container(

      padding:
      const EdgeInsets.all(
        16,
      ),

      decoration:
      BoxDecoration(

        border: Border.all(

          color:
          Colors.grey[300]!,
        ),

        borderRadius:
        BorderRadius.circular(
          14,
        ),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment
            .start,

        children: [

          Row(

            children: [

              Icon(

                icon,

                color:
                const Color(
                  0xFF2E7D32,
                ),

                size: 20,
              ),

              const SizedBox(
                width: 8,
              ),

              Text(

                label,

                style:
                const TextStyle(

                  fontSize: 12,

                  color:
                  Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            value,

            style:
            const TextStyle(

              fontSize: 17,

              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // BIG INFO CARD
  // =========================

  Widget _bigInfoCard({

    required IconData icon,

    required String title,

    required String value,

  }) {

    return Container(

      padding:
      const EdgeInsets.all(
        18,
      ),

      decoration:
      BoxDecoration(

        color:
        Colors.grey[100],

        borderRadius:
        BorderRadius.circular(
          16,
        ),
      ),

      child: Row(

        children: [

          CircleAvatar(

            backgroundColor:
            Colors.green
                .withOpacity(
              0.12,
            ),

            child: Icon(

              icon,

              color:
              Colors.green,
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

                  title,

                  style:
                  TextStyle(

                    color:
                    Colors.grey[
                    600],

                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  value,

                  style:
                  const TextStyle(

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