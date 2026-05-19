import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'edit_donation_screen.dart';
import 'edit_profile_screen.dart';
import 'incoming_requests_screen.dart';
import 'login_screen.dart';
import 'my_requests_screen.dart';
import 'manage_donations_screen.dart';

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

  List<Map<String, dynamic>>
  donations = [];

  List<Map<String, dynamic>>
  activeDonations = [];

  int incomingCount = 0;

  int myRequestCount = 0;

  Map<String, dynamic>? updatedUser;

  @override
  void initState() {
    super.initState();

    updatedUser = widget.user;

    loadProfileData();
  }

  // =========================
  // LOAD PROFILE DATA
  // =========================

  Future<void> loadProfileData()
  async {

    final donationData =
    await DatabaseHelper.instance
        .getCompletedDonations(
      updatedUser!['id'],
    );

    final activeDonationData =
    await DatabaseHelper.instance
        .getUserDonations(
      updatedUser!['id'],
    );

    final filteredActive =
    activeDonationData.where(
          (donation) {

        return donation['status'] !=
            'Completed';
      },
    ).toList();

    final incomingRequests =
    await DatabaseHelper.instance
        .getIncomingRequests(
      updatedUser!['id'],
    );

    final myRequests =
    await DatabaseHelper.instance
        .getUserRequests(
      updatedUser!['id'],
    );

    setState(() {

      donations = donationData;

      activeDonations =
          filteredActive;

      incomingCount =
          incomingRequests.where(
                (request) {

              return request['status']
                  == 'Pending';
            },
          ).length;

      myRequestCount =
          myRequests.where(
                (request) {

              return request['status']
                  == 'Pending';
            },
          ).length;
    });
  }

  // =========================
  // REFRESH USER
  // =========================

  Future<void> refreshUser()
  async {

    final refreshedUser =
    await DatabaseHelper.instance
        .getUserById(
      updatedUser!['id'],
    );

    setState(() {

      updatedUser =
          refreshedUser;
    });

    loadProfileData();
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

        automaticallyImplyLeading:
        false,

        title: const Text(

          'Profile',

          style: TextStyle(

            fontSize: 26,

            fontWeight:
            FontWeight.bold,

            color: Colors.white,
          ),
        ),

        actions: [

          Padding(

            padding:
            const EdgeInsets.only(
              right: 12,
            ),

            child: IconButton(

              icon: const Icon(

                Icons.logout_rounded,

                color: Colors.white,

                size: 28,
              ),

              onPressed: () {

                showDialog(

                  context: context,

                  builder: (context) {

                    return AlertDialog(

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      title:
                      const Text(
                        'Logout',
                      ),

                      content:
                      const Text(
                        'Are you sure you want to logout?',
                      ),

                      actions: [

                        TextButton(

                          onPressed:
                              () {

                            Navigator.pop(
                                context);
                          },

                          child:
                          const Text(
                            'Cancel',
                          ),
                        ),

                        ElevatedButton(

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.red,
                          ),

                          onPressed:
                              () {

                            Navigator.pushAndRemoveUntil(

                              context,

                              MaterialPageRoute(

                                builder: (_) =>
                                const LoginScreen(),
                              ),

                                  (route) => false,
                            );
                          },

                          child:
                          const Text(
                            'Logout',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      body: RefreshIndicator(

        onRefresh: refreshUser,

        child: SingleChildScrollView(

          physics:
          const AlwaysScrollableScrollPhysics(),

          child: Padding(

            padding:
            const EdgeInsets.all(
              20,
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // =========================
                // PROFILE CARD
                // =========================

                buildProfileCard(
                  primary,
                ),

                const SizedBox(
                  height: 22,
                ),

                // =========================
                // IMPACT CARD
                // =========================

                buildImpactCard(
                  primary,
                ),

                const SizedBox(
                  height: 22,
                ),

                // =========================
                // REQUEST CARDS
                // =========================

                Row(

                  children: [

                    Expanded(

                      child:
                      buildRequestCard(

                        title:
                        'Incoming Requests',

                        subtitle:
                        'View food requests from users',

                        icon:
                        Icons.notifications,

                        iconColor:
                        Colors.orange,

                        badgeCount:
                        incomingCount,

                        onTap: () async {

                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  IncomingRequestsScreen(
                                    user:
                                    updatedUser!,
                                  ),
                            ),
                          );

                          loadProfileData();
                        },
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(

                      child:
                      buildRequestCard(

                        title:
                        'My Requests',

                        subtitle:
                        'Track your requested food status',

                        icon:
                        Icons.receipt_long,

                        iconColor:
                        primary,

                        badgeCount:
                        myRequestCount,

                        onTap: () async {

                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  MyRequestsScreen(
                                    user:
                                    updatedUser!,
                                  ),
                            ),
                          );

                          loadProfileData();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // =========================
// MANAGE DONATIONS
// =========================

                GestureDetector(

                  onTap: () async {

                    await Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            ManageDonationsScreen(
                              user: updatedUser!,
                            ),
                      ),
                    );

                    loadProfileData();
                  },

                  child: Container(

                    padding:
                    const EdgeInsets.all(
                      20,
                    ),

                    decoration:
                    BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),
                    ),

                    child: Row(

                      children: [

                        CircleAvatar(

                          radius: 28,

                          backgroundColor:
                          primary.withOpacity(
                            0.12,
                          ),

                          child: Icon(

                            Icons.inventory_2,

                            color: primary,

                            size: 28,
                          ),
                        ),

                        const SizedBox(
                          width: 18,
                        ),

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              const Text(

                                'Manage Donations',

                                style: TextStyle(

                                  fontSize: 20,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Text(

                                'View and manage your active food donations',

                                style: TextStyle(

                                  color:
                                  Colors.grey[
                                  600],

                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(

                          children: [

                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal: 12,

                                vertical: 6,
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

                                '${activeDonations.length} Active',

                                style: TextStyle(

                                  color:
                                  Colors.orange
                                      .shade800,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Icon(

                              Icons.arrow_forward_ios,

                              size: 18,

                              color:
                              Colors.grey[500],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                // =========================
                // DONATION HISTORY
                // =========================

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    const Text(

                      'Donation History',

                      style: TextStyle(

                        fontSize: 28,

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

                const SizedBox(
                  height: 18,
                ),

                donations.isEmpty

                    ? Center(

                  child: Padding(

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 50,
                    ),

                    child: Column(

                      children: const [

                        Icon(
                          Icons.fastfood,

                          size: 70,

                          color:
                          Colors.grey,
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        Text(

                          'No donation history yet',

                          style:
                          TextStyle(

                            color:
                            Colors.grey,

                            fontSize:
                            16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

                    : Column(

                  children:
                  donations.map(
                        (donation) {

                      return Container(

                        margin:
                        const EdgeInsets.only(
                          bottom: 14,
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
                            22,
                          ),
                        ),

                        child: Row(

                          children: [

                            CircleAvatar(

                              radius: 36,

                              backgroundColor:
                              Colors.green
                                  .shade50,

                              backgroundImage:
                              donation['imageUrl'] !=
                                  null &&
                                  donation[
                                  'imageUrl']
                                      .toString()
                                      .isNotEmpty

                                  ? FileImage(
                                File(
                                  donation[
                                  'imageUrl'],
                                ),
                              )

                                  : null,

                              child:
                              donation['imageUrl'] ==
                                  null ||
                                  donation[
                                  'imageUrl']
                                      .toString()
                                      .isEmpty

                                  ? Icon(
                                Icons.fastfood,

                                color:
                                primary,

                                size:
                                32,
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

                                    donation['title'],

                                    style:
                                    const TextStyle(

                                      fontSize:
                                      22,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  Text(

                                    donation['location'],

                                    style:
                                    TextStyle(

                                      color:
                                      Colors.grey.shade700,

                                      fontSize:
                                      16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(

                              padding:
                              const EdgeInsets.symmetric(

                                horizontal:
                                14,

                                vertical:
                                8,
                              ),

                              decoration:
                              BoxDecoration(

                                color:
                                Colors.green.shade50,

                                borderRadius:
                                BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Row(

                                children:
                                const [

                                  Icon(

                                    Icons
                                        .check_circle,

                                    color:
                                    Colors.green,

                                    size:
                                    18,
                                  ),

                                  SizedBox(
                                    width: 6,
                                  ),

                                  Text(

                                    'Completed',

                                    style:
                                    TextStyle(

                                      color:
                                      Colors.green,

                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // PROFILE CARD
  // =========================

  Widget buildProfileCard(
      Color primary,
      ) {

    return Container(

      padding:
      const EdgeInsets.all(
        22,
      ),

      decoration:
      BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          28,
        ),
      ),

      child: Row(

        children: [

          Stack(

            children: [

              CircleAvatar(

                radius: 58,

                backgroundColor:
                Colors.green
                    .shade50,

                backgroundImage:
                updatedUser![
                'profileImage'] !=
                    null &&
                    updatedUser![
                    'profileImage']
                        .toString()
                        .isNotEmpty

                    ? FileImage(
                  File(
                    updatedUser![
                    'profileImage'],
                  ),
                )

                    : null,

                child:
                updatedUser![
                'profileImage'] ==
                    null ||
                    updatedUser![
                    'profileImage']
                        .toString()
                        .isEmpty

                    ? Text(

                  updatedUser![
                  'name'][0]
                      .toUpperCase(),

                  style:
                  TextStyle(

                    fontSize:
                    52,

                    fontWeight:
                    FontWeight.bold,

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

                  onTap: () async {

                    await Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            EditProfileScreen(
                              user:
                              updatedUser!,
                            ),
                      ),
                    );

                    refreshUser();
                  },

                  child: Container(

                    padding:
                    const EdgeInsets.all(
                      10,
                    ),

                    decoration:
                    BoxDecoration(

                      color: primary,

                      shape:
                      BoxShape.circle,

                      border: Border.all(

                        color:
                        Colors.white,

                        width: 3,
                      ),
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
            width: 20,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Text(

                  updatedUser!['name'],

                  style:
                  const TextStyle(

                    fontSize: 26,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(

                  padding:
                  const EdgeInsets.symmetric(

                    horizontal: 16,

                    vertical: 8,
                  ),

                  decoration:
                  BoxDecoration(

                    border: Border.all(
                      color: primary,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      25,
                    ),
                  ),

                  child: Row(

                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      Icon(

                        Icons.eco,

                        color: primary,

                        size: 18,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(

                        'Food Donor',

                        style:
                        TextStyle(

                          color:
                          primary,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Text(

                  updatedUser!['email'],

                  style:
                  TextStyle(

                    color:
                    Colors.grey
                        .shade700,

                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(

                  updatedUser!['phone'],

                  style:
                  TextStyle(

                    color:
                    Colors.grey
                        .shade700,

                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // IMPACT CARD
  // =========================

  Widget buildImpactCard(
      Color primary,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(

        horizontal: 18,

        vertical: 16,
      ),

      decoration:
      BoxDecoration(

        color: primary,

        borderRadius:
        BorderRadius.circular(
          28,
        ),
      ),

      child: Column(

        children: [

          Row(

            children: const [

              Icon(
                Icons.eco,
                color:
                Colors.white,
              ),

              SizedBox(
                width: 10,
              ),

              Text(

                'Total Impact',

                style:
                TextStyle(

                  color:
                  Colors.white,

                  fontSize: 22,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          Row(

            children: [

              Expanded(

                child:
                buildImpactStat(

                  icon:
                  Icons.fastfood_outlined,

                  title:
                  'Donations',

                  value:
                  donations.length
                      .toString(),
                ),
              ),

              Container(

                height: 90,

                width: 1,

                color:
                Colors.white24,
              ),

              Expanded(

                child:
                buildImpactStat(

                  icon:
                  Icons.people,

                  title:
                  'People Helped',

                  value:
                  donations.length
                      .toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImpactStat({

    required IconData icon,

    required String title,

    required String value,

  }) {

    return Column(

      children: [

        CircleAvatar(

          radius: 32,

          backgroundColor:
          Colors.white24,

          child: Icon(

            icon,

            color:
            Colors.white,

            size: 30,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        Text(

          title,

          style:
          const TextStyle(

            color:
            Colors.white,

            fontSize: 18,
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        Text(

          value,

          style:
          const TextStyle(

            color:
            Colors.white,

            fontSize: 34,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =========================
  // REQUEST CARD
  // =========================

  Widget buildRequestCard({

    required String title,

    required String subtitle,

    required IconData icon,

    required Color iconColor,

    required VoidCallback onTap,

    required int badgeCount,

  }) {

    return GestureDetector(

      onTap: onTap,

      child: Stack(

        children: [

          Container(

            padding:
            const EdgeInsets.symmetric(

              horizontal: 14,

              vertical: 18,
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

                CircleAvatar(

                  radius: 24,

                  backgroundColor:
                  iconColor.withOpacity(
                    0.15,
                  ),

                  child: Icon(

                    icon,

                    color:
                    iconColor,

                    size: 24,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Text(

                  title,

                  textAlign:
                  TextAlign.center,

                  style:
                  const TextStyle(

                    fontSize: 16,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  subtitle,

                  textAlign:
                  TextAlign.center,

                  style:
                  TextStyle(

                    color:
                    Colors.grey
                        .shade600,

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          if (badgeCount > 0)

            Positioned(

              top: 8,

              right: 8,

              child: Container(

                padding:
                const EdgeInsets.symmetric(

                  horizontal: 6,

                  vertical: 2,
                ),

                decoration:
                BoxDecoration(

                  color:
                  Colors.red,

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(

                  badgeCount.toString(),

                  style:
                  const TextStyle(

                    color:
                    Colors.white,

                    fontSize: 10,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}