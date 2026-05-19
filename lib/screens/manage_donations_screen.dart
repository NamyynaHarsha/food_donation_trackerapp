import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'edit_donation_screen.dart';

class ManageDonationsScreen
    extends StatefulWidget {

  final Map<String, dynamic> user;

  const ManageDonationsScreen({
    super.key,
    required this.user,
  });

  @override
  State<ManageDonationsScreen>
  createState() =>
      _ManageDonationsScreenState();
}

class _ManageDonationsScreenState
    extends State<ManageDonationsScreen> {

  List<Map<String, dynamic>>
  donations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadDonations();
  }

  // =========================
  // LOAD DONATIONS
  // =========================

  Future<void> loadDonations()
  async {

    setState(() {

      isLoading = true;
    });

    final data =
    await DatabaseHelper.instance
        .getUserDonations(
      widget.user['id'],
    );

    final activeDonations =
    data.where((donation) {

      return donation['status'] !=
          'Completed';

    }).toList();

    setState(() {

      donations =
          activeDonations;

      isLoading = false;
    });
  }

  // =========================
  // DELETE DONATION
  // =========================

  Future<void> deleteDonation(
      int donationId,
      ) async {

    final confirm =
    await showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(
              18,
            ),
          ),

          title: const Text(
            'Delete Donation',
          ),

          content: const Text(
            'Are you sure you want to delete this donation?',
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  false,
                );
              },

              child: Text(

                'Cancel',

                style: TextStyle(
                  color:
                  Colors.grey.shade700,
                ),
              ),
            ),

            ElevatedButton(

              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.red,

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              onPressed: () {

                Navigator.pop(
                  context,
                  true,
                );
              },

              child: const Text(

                'Delete',

                style: TextStyle(
                  color:
                  Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {

      await DatabaseHelper.instance
          .deleteDonation(
        donationId,
      );

      loadDonations();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Donation deleted successfully',
          ),
        ),
      );
    }
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

          'Manage Donations',

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

      body: isLoading

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : donations.isEmpty

          ? Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment
              .center,

          children: [

            Icon(

              Icons
                  .inventory_2_outlined,

              size: 80,

              color:
              Colors.grey[
              400],
            ),

            const SizedBox(
              height: 14,
            ),

            Text(

              'No active donations',

              style: TextStyle(

                color:
                Colors.grey[
                600],

                fontSize: 18,
              ),
            ),
          ],
        ),
      )

          : RefreshIndicator(

        onRefresh:
        loadDonations,

        child: ListView.builder(

          padding:
          const EdgeInsets.all(
            20,
          ),

          itemCount:
          donations.length,

          itemBuilder:
              (context, index) {

            final donation =
            donations[index];

            return Container(

              margin:
              const EdgeInsets.only(
                bottom: 18,
              ),

              padding:
              const EdgeInsets.all(
                16,
              ),

              decoration:
              BoxDecoration(

                color:
                Colors.white,

                borderRadius:
                BorderRadius.circular(
                  24,
                ),
              ),

              child: Column(

                children: [

                  // =========================
                  // TOP SECTION
                  // =========================

                  Row(

                    children: [

                      // IMAGE

                      ClipRRect(

                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),

                        child:
                        donation['imageUrl'] !=
                            null &&
                            donation[
                            'imageUrl']
                                .toString()
                                .isNotEmpty

                            ? Image.file(

                          File(
                            donation[
                            'imageUrl'],
                          ),

                          width:
                          90,

                          height:
                          90,

                          fit:
                          BoxFit.cover,
                        )

                            : Container(

                          width:
                          90,

                          height:
                          90,

                          color:
                          Colors.grey[
                          300],

                          child:
                          const Icon(
                            Icons.image,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      // INFO

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(

                              donation[
                              'title'],

                              style:
                              const TextStyle(

                                fontSize:
                                22,

                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(

                              donation[
                              'quantity'],

                              style:
                              TextStyle(

                                color:
                                Colors.grey[
                                700],

                                fontSize:
                                15,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(

                              donation[
                              'location'],

                              style:
                              TextStyle(

                                color:
                                Colors.grey[
                                700],

                                fontSize:
                                14,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal:
                                12,

                                vertical:
                                6,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.orange
                                    .shade50,

                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Text(

                                'Active',

                                style:
                                TextStyle(

                                  color:
                                  Colors.orange
                                      .shade800,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // =========================
                  // BUTTONS
                  // =========================

                  Row(

                    children: [

                      // EDIT BUTTON

                      Expanded(

                        child:
                        ElevatedButton.icon(

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            primary,

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          onPressed:
                              () async {

                            await Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                    EditDonationScreen(
                                      donation:
                                      donation,
                                    ),
                              ),
                            );

                            loadDonations();
                          },

                          icon:
                          const Icon(

                            Icons.edit,

                            color:
                            Colors.white,
                          ),

                          label:
                          const Text(

                            'Edit',

                            style:
                            TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      // DELETE BUTTON

                      Expanded(

                        child:
                        ElevatedButton.icon(

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.white,

                            elevation:
                            0,

                            side:
                            BorderSide(
                              color:
                              primary,
                              width:
                              1.5,
                            ),

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                          ),

                          onPressed:
                              () {

                            deleteDonation(
                              donation[
                              'id'],
                            );
                          },

                          icon:
                          Icon(

                            Icons.delete,

                            color:
                            primary,
                          ),

                          label:
                          Text(

                            'Delete',

                            style:
                            TextStyle(

                              color:
                              primary,

                              fontWeight:
                              FontWeight
                                  .w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}