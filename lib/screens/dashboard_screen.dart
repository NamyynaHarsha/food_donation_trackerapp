import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'browse_donations_screen.dart';
import 'donation_details_screen.dart';

class DashboardScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const DashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  List<Map<String, dynamic>> donations = [];

  bool isLoading = true;

  int totalAvailableDonations = 0;

  int totalUsers = 0;

  @override
  void initState() {
    super.initState();

    loadDonations();
  }

  // =========================
  // LOAD DONATIONS
  // =========================

  Future<void> loadDonations() async {

    setState(() {
      isLoading = true;
    });

    final data =
    await DatabaseHelper.instance
        .getAvailableDonations(
      widget.user['id'],
    );

    final users =
    await DatabaseHelper.instance
        .getTotalUsers();

    // TOTAL DONATIONS

    final totalAvailable =
        data.length;

    // SHOW ONLY 5

    final limitedDonations =
    data.take(5).toList();

    setState(() {

      donations =
          limitedDonations;

      totalAvailableDonations =
          totalAvailable;

      totalUsers =
          users;

      isLoading = false;
    });
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

      body: SafeArea(

        child: Column(

          children: [

            // =========================
            // HEADER
            // =========================

            Container(

              width: double.infinity,

              padding:
              const EdgeInsets.fromLTRB(
                20,
                25,
                20,
                30,
              ),

              decoration: BoxDecoration(

                color: primary,

                borderRadius:
                const BorderRadius.vertical(
                  bottom:
                  Radius.circular(35),
                ),
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(

                    "Hello, ${widget.user['name']} 👋",

                    style:
                    const TextStyle(

                      fontSize: 30,

                      fontWeight:
                      FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(

                    "Together we can reduce food waste 🌱",

                    style: TextStyle(

                      fontSize: 15,

                      color: Colors.white
                          .withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // SEARCH BAR

                  Container(

                    decoration:
                    BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        30,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.black
                              .withOpacity(0.06),

                          blurRadius: 10,

                          offset:
                          const Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),

                    child: TextField(

                      decoration:
                      InputDecoration(

                        hintText:
                        "Search donations...",

                        hintStyle:
                        TextStyle(
                          color:
                          Colors.grey[500],
                        ),

                        prefixIcon:
                        const Icon(
                          Icons.search,
                        ),

                        suffixIcon: Icon(
                          Icons.tune,
                          color:
                          Colors.grey[600],
                        ),

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(
                            30,
                          ),

                          borderSide:
                          BorderSide.none,
                        ),

                        filled: true,

                        fillColor:
                        Colors.white,

                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // STATS CARD
            // =========================

            Container(

              margin:
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              padding:
              const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  25,
                ),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black
                        .withOpacity(0.05),

                    blurRadius: 12,

                    offset:
                    const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(

                children: [

                  Text(

                    "$totalAvailableDonations",

                    style: TextStyle(

                      fontSize: 48,

                      fontWeight:
                      FontWeight.bold,

                      color: primary,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(

                    "Donations Available",

                    style: TextStyle(

                      fontSize: 16,

                      color:
                      Colors.grey[700],

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,

                    children: [

                      buildStat(
                        "$totalAvailableDonations",
                        "Food",
                      ),

                      buildStat(
                        "$totalUsers",
                        "People",
                      ),

                      buildStat(
                        "$totalAvailableDonations",
                        "Donations",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // TITLE ROW
            // =========================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 22,
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [

                  Text(

                    "Available Donations",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                      FontWeight.bold,

                      color:
                      Colors.grey[850],
                    ),
                  ),

                  GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              BrowseDonationsScreen(
                                user:
                                widget.user,
                              ),
                        ),
                      );
                    },

                    child: Text(

                      "See All",

                      style: TextStyle(

                        color: primary,

                        fontWeight:
                        FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // DONATION LIST
            // =========================

            Expanded(

              child: isLoading

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
                          .fastfood_outlined,

                      size: 80,

                      color:
                      Colors.grey[
                      400],
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Text(

                      "No donations available",

                      style:
                      TextStyle(

                        fontSize: 18,

                        color:
                        Colors.grey[
                        600],

                        fontWeight:
                        FontWeight
                            .w500,
                      ),
                    ),
                  ],
                ),
              )

                  : RefreshIndicator(

                onRefresh:
                loadDonations,

                child:
                ListView.builder(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  itemCount:
                  donations.length,

                  itemBuilder:
                      (_, index) {

                    final donation =
                    donations[index];

                    return GestureDetector(

                      onTap: () async {

                        await Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                DonationDetailsScreen(

                                  donation:
                                  donation,

                                  currentUser:
                                  widget.user,
                                ),
                          ),
                        );

                        loadDonations();
                      },

                      child: Container(

                        margin:
                        const EdgeInsets.only(
                          bottom: 16,
                        ),

                        padding:
                        const EdgeInsets.all(
                          12,
                        ),

                        decoration:
                        BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                            22,
                          ),

                          boxShadow: [

                            BoxShadow(

                              color: Colors.black
                                  .withOpacity(0.04),

                              blurRadius: 10,

                              offset:
                              const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Row(

                          children: [

                            // IMAGE

                            ClipRRect(

                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),

                              child:
                              donation['imageUrl'] != null &&
                                  donation['imageUrl']
                                      .toString()
                                      .isNotEmpty

                                  ? Image.file(

                                File(
                                  donation['imageUrl'],
                                ),

                                width: 95,

                                height: 95,

                                fit: BoxFit.cover,
                              )

                                  : Container(

                                width: 95,

                                height: 95,

                                color:
                                Colors.grey[300],

                                child:
                                const Icon(
                                  Icons.image,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // TEXT

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                                children: [

                                  Text(

                                    donation['title'],

                                    maxLines: 1,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style:
                                    const TextStyle(

                                      fontSize: 20,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  Text(

                                    donation['quantity'],

                                    style: TextStyle(

                                      color:
                                      Colors.grey[600],

                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  Text(

                                    donation['location'],

                                    style: TextStyle(

                                      color:
                                      Colors.grey[600],

                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  Container(

                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
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

                                      "Available",

                                      style:
                                      TextStyle(

                                        color:
                                        primary,

                                        fontWeight:
                                        FontWeight.w600,
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // STATS WIDGET
  // =========================

  Widget buildStat(
      String value,
      String label,
      ) {

    return Column(

      children: [

        Text(

          value,

          style: const TextStyle(

            fontSize: 18,

            fontWeight:
            FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(

          label,

          style: TextStyle(

            color: Colors.grey[600],

            fontSize: 14,
          ),
        ),
      ],
    );
  }
}