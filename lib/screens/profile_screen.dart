import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'incoming_requests_screen.dart';
import 'my_requests_screen.dart';

class ProfileScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const ProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  List<Map<String, dynamic>> donations = [];

  @override
  void initState() {
    super.initState();

    loadDonations();
  }

  Future<void> loadDonations() async {

    final data =
        await DatabaseHelper.instance
            .getUserDonations(
      widget.user['email'],
    );

    setState(() {
      donations = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // =========================
            // HEADER
            // =========================

            Container(
              color: primary,

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                24,
              ),

              child: SafeArea(
                bottom: false,

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    const Text(
                      'Profile',

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    Container(
                      width: 42,
                      height: 42,

                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withValues(
                          alpha: 0.2,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(21),
                      ),

                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================
            // PROFILE CARD
            // =========================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.04,
                      ),

                      blurRadius: 10,

                      offset:
                          const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                padding:
                    const EdgeInsets.all(20),

                child: Row(
                  children: [

                    // PROFILE IMAGE

                    Stack(
                      children: [

                        CircleAvatar(
                          radius: 50,

                          backgroundColor:
                              primary
                                  .withValues(
                            alpha: 0.15,
                          ),

                          child: Text(
                            widget.user['name']
                                .toString()[0]
                                .toUpperCase(),

                            style: TextStyle(
                              fontSize: 40,
                              fontWeight:
                                  FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,

                          child: Container(
                            width: 30,
                            height: 30,

                            decoration:
                                BoxDecoration(
                              color: primary,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                15,
                              ),

                              border:
                                  Border.all(
                                color:
                                    Colors.white,
                                width: 2,
                              ),
                            ),

                            child: const Icon(
                              Icons.edit,
                              color:
                                  Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // USER INFO

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(
                            widget.user['name'],

                            style:
                                const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          // DONOR BADGE

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),

                            decoration:
                                BoxDecoration(
                              color: primary
                                  .withValues(
                                alpha: 0.08,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),

                              border:
                                  Border.all(
                                color: primary,
                                width: 1.2,
                              ),
                            ),

                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                Icon(
                                  Icons.eco,
                                  color: primary,
                                  size: 16,
                                ),

                                const SizedBox(
                                  width: 6,
                                ),

                                Text(
                                  'Food Donor',

                                  style:
                                      TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    color:
                                        primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              height: 12),

                          Text(
                            widget.user['email'],

                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  Colors.grey[
                                      600],
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(
                              height: 4),

                          Text(
                            widget.user['phone'] ??
                                '',

                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  Colors.grey[
                                      600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================
            // IMPACT CARD
            // =========================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Container(
                decoration: BoxDecoration(
                  color: primary,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),

                padding:
                    const EdgeInsets.all(18),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: const [

                        Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 22,
                        ),

                        SizedBox(width: 8),

                        Text(
                          'Total Impact',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .w600,

                            color:
                                Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,

                      children: [

                        // DONATIONS

                        buildImpactStat(
                          icon: Icons
                              .fastfood_outlined,

                          title: 'Donations',

                          value: donations
                              .length
                              .toString(),

                          primary: primary,
                        ),

                        Container(
                          width: 1,
                          height: 75,

                          color: Colors.white
                              .withValues(
                            alpha: 0.2,
                          ),
                        ),

                        // PEOPLE HELPED

                        buildImpactStat(
                          icon: Icons.people,

                          title:
                              'People Helped',

                          value:
                              '${donations.length * 3}',

                          primary: primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            // =========================
            // REQUEST MANAGEMENT
            // =========================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(
                children: [

                  // INCOMING REQUESTS

                  Expanded(
                    child: GestureDetector(

                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                IncomingRequestsScreen(
                              user:
                                  widget.user,
                            ),
                          ),
                        );
                      },

                      child: Container(

                        padding:
                            const EdgeInsets
                                .all(18),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),

                          boxShadow: [

                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha: 0.04,
                              ),

                              blurRadius: 10,

                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            CircleAvatar(

                              radius: 26,

                              backgroundColor:
                                  Colors.orange
                                      .withValues(
                                alpha: 0.12,
                              ),

                              child:
                                  const Icon(
                                Icons
                                    .notifications_active,

                                color: Colors
                                    .orange,

                                size: 28,
                              ),
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                            const Text(
                              "Incoming Requests",

                              textAlign:
                                  TextAlign
                                      .center,

                              style:
                                  TextStyle(
                                fontSize: 15,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              "View food requests from users",

                              textAlign:
                                  TextAlign
                                      .center,

                              style:
                                  TextStyle(
                                fontSize: 12,

                                color: Colors
                                        .grey[
                                    600],

                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // MY REQUESTS

                  Expanded(
                    child: GestureDetector(

                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                MyRequestsScreen(
                              user:
                                  widget.user,
                            ),
                          ),
                        );
                      },

                      child: Container(

                        padding:
                            const EdgeInsets
                                .all(18),

                        decoration:
                            BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),

                          boxShadow: [

                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha: 0.04,
                              ),

                              blurRadius: 10,

                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [

                            CircleAvatar(

                              radius: 26,

                              backgroundColor:
                                  primary
                                      .withValues(
                                alpha: 0.12,
                              ),

                              child: Icon(
                                Icons
                                    .receipt_long,

                                color: primary,
                                size: 28,
                              ),
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                            const Text(
                              "My Requests",

                              textAlign:
                                  TextAlign
                                      .center,

                              style:
                                  TextStyle(
                                fontSize: 15,

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              "Track your requested food status",

                              textAlign:
                                  TextAlign
                                      .center,

                              style:
                                  TextStyle(
                                fontSize: 12,

                                color: Colors
                                        .grey[
                                    600],

                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // =========================
            // HISTORY TITLE
            // =========================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                children: [

                  const Text(
                    'Donation History',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    '${donations.length} items',

                    style: TextStyle(
                      color: primary,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // =========================
            // HISTORY LIST
            // =========================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Column(
                children:
                    donations.map((item) {

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),

                    child: Container(
                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),

                        boxShadow: [

                          BoxShadow(
                            color: Colors.black
                                .withValues(
                              alpha: 0.03,
                            ),

                            blurRadius: 8,

                            offset:
                                const Offset(
                              0,
                              3,
                            ),
                          ),
                        ],
                      ),

                      padding:
                          const EdgeInsets
                              .all(12),

                      child: Row(
                        children: [

                          // IMAGE

                          ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),

                            child: item[
                                        'imageUrl'] !=
                                    null

                                ? Image.file(
                                    File(
                                      item[
                                          'imageUrl'],
                                    ),

                                    width: 65,
                                    height: 65,

                                    fit: BoxFit
                                        .cover,
                                  )

                                : Container(
                                    width: 65,
                                    height: 65,

                                    color: Colors
                                            .grey[
                                        300],

                                    child:
                                        const Icon(
                                      Icons
                                          .fastfood,

                                      color: Colors
                                          .grey,
                                    ),
                                  ),
                          ),

                          const SizedBox(
                              width: 14),

                          // INFO

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  item['title'],

                                  style:
                                      const TextStyle(
                                    fontSize: 16,

                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  item[
                                      'location'],

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

                          // STATUS

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .green[50],

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),
                            ),

                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: const [

                                Icon(
                                  Icons
                                      .check_circle,

                                  color: Color(
                                      0xFF2E7D32),

                                  size: 14,
                                ),

                                SizedBox(width: 4),

                                Text(
                                  'Completed',

                                  style:
                                      TextStyle(
                                    fontSize: 12,

                                    fontWeight:
                                        FontWeight
                                            .w600,

                                    color: Color(
                                      0xFF2E7D32,
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
                }).toList(),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget buildImpactStat({
    required IconData icon,
    required String title,
    required String value,
    required Color primary,
  }) {

    return Column(
      children: [

        Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: Colors.white
                .withValues(
              alpha: 0.2,
            ),

            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),

          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,

          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight:
                FontWeight.w500,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          value,

          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}