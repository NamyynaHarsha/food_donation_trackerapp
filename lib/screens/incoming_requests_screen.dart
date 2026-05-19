import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class IncomingRequestsScreen
    extends StatefulWidget {

  final Map<String, dynamic> user;

  const IncomingRequestsScreen({
    super.key,
    required this.user,
  });

  @override
  State<IncomingRequestsScreen> createState() =>
      _IncomingRequestsScreenState();
}

class _IncomingRequestsScreenState
    extends State<IncomingRequestsScreen> {

  List<Map<String, dynamic>> requests = [];

  bool isLoading = true;

  int pendingCount = 0;

  @override
  void initState() {

    super.initState();

    loadRequests();
  }

  // =========================
  // LOAD REQUESTS
  // =========================

  Future<void> loadRequests() async {

    try {

      final data =
      await DatabaseHelper.instance
          .getIncomingRequests(
        widget.user['id'],
      );

      final pending =
          data.where((request) {

            return request['status'] ==
                'Pending';

          }).length;

      if (!mounted) return;

      setState(() {

        requests = data;

        pendingCount = pending;

        isLoading = false;
      });

    } catch (e) {

      debugPrint(
        "LOAD REQUEST ERROR: $e",
      );

      if (!mounted) return;

      setState(() {

        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            'Error loading requests: $e',
          ),
        ),
      );
    }
  }

  // =========================
  // UPDATE STATUS
  // =========================

  Future<void> updateStatus(

      Map<String, dynamic> request,
      String status,

      ) async {

    await DatabaseHelper.instance
        .updateRequestStatus(

      request['id'],
      status,
    );

    // ACCEPTED

    if (status == 'Accepted') {

      await DatabaseHelper.instance
          .updateDonationStatus(

        request['donationId'],

        'Completed',
      );
    }

    // REJECTED

    if (status == 'Rejected') {

      await DatabaseHelper.instance
          .updateDonationStatus(

        request['donationId'],

        'Available',
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content:
        Text('Request $status'),
      ),
    );

    loadRequests();
  }

  // =========================
  // STATUS COLOR
  // =========================

  Color getStatusColor(
      String status,
      ) {

    switch (status) {

      case 'Accepted':
        return Colors.green;

      case 'Rejected':
        return Colors.red;

      case 'Completed':
        return Colors.blue;

      default:
        return Colors.orange;
    }
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

      appBar: AppBar(

        backgroundColor: primary,

        elevation: 0,

        title: Row(
          children: [

            const Text(

              "Incoming Requests",

              style: TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(width: 10),

            // BADGE

            if (pendingCount > 0)

              Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(

                  color: Colors.red,

                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(

                  pendingCount.toString(),

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
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

          : requests.isEmpty

          ? Center(
        child: Column(

          mainAxisAlignment:
          MainAxisAlignment
              .center,

          children: [

            Icon(
              Icons.notifications_none,
              size: 90,
              color:
              Colors.grey[400],
            ),

            const SizedBox(
              height: 20,
            ),

            Text(

              "No incoming requests yet",

              style: TextStyle(
                fontSize: 18,
                color:
                Colors.grey[
                600],
              ),
            ),
          ],
        ),
      )

          : Column(
        children: [

          // =========================
          // TOP SUMMARY
          // =========================

          Container(

            margin:
            const EdgeInsets.all(
              16,
            ),

            padding:
            const EdgeInsets.all(
              18,
            ),

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

            child: Row(

              mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,

              children: [

                buildStat(
                  value:
                  requests.length
                      .toString(),

                  label:
                  'Total',
                ),

                buildDivider(),

                buildStat(
                  value:
                  pendingCount
                      .toString(),

                  label:
                  'Pending',
                ),

                buildDivider(),

                buildStat(
                  value:
                  requests
                      .where(
                        (r) =>
                    r['status'] ==
                        'Accepted',
                  )
                      .length
                      .toString(),

                  label:
                  'Accepted',
                ),
              ],
            ),
          ),

          // =========================
          // REQUEST LIST
          // =========================

          Expanded(

            child:
            ListView.builder(

              padding:
              const EdgeInsets
                  .fromLTRB(
                16,
                0,
                16,
                24,
              ),

              itemCount:
              requests.length,

              itemBuilder:
                  (context, index) {

                final request =
                requests[index];

                final status =
                request[
                'status'];

                final statusColor =
                getStatusColor(
                  status,
                );

                return Container(

                  margin:
                  const EdgeInsets
                      .only(
                    bottom: 18,
                  ),

                  padding:
                  const EdgeInsets
                      .all(18),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius
                        .circular(
                      20,
                    ),

                    boxShadow: [

                      BoxShadow(
                        color: Colors
                            .black
                            .withValues(
                          alpha:
                          0.05,
                        ),

                        blurRadius:
                        10,

                        offset:
                        const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      // FOOD TITLE

                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          Expanded(
                            child:
                            Text(

                              request[
                              'foodTitle'],

                              style:
                              const TextStyle(
                                fontSize:
                                22,

                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ),
                          ),

                          Container(

                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal:
                              12,

                              vertical:
                              6,
                            ),

                            decoration:
                            BoxDecoration(

                              color:
                              statusColor
                                  .withValues(
                                alpha:
                                0.12,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                            ),

                            child: Text(

                              status,

                              style:
                              TextStyle(

                                color:
                                statusColor,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // USER INFO

                      Row(
                        children: [

                          CircleAvatar(

                            radius: 28,

                            backgroundColor:
                            primary
                                .withValues(
                              alpha:
                              0.15,
                            ),

                            child: Text(

                              request[
                              'requesterName'][0]
                                  .toUpperCase(),

                              style:
                              TextStyle(

                                color:
                                primary,

                                fontSize:
                                24,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 16,
                          ),

                          Expanded(

                            child:
                            Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  request[
                                  'requesterName'],

                                  style:
                                  const TextStyle(
                                    fontSize:
                                    18,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                  6,
                                ),

                                Row(
                                  children: [

                                    Icon(
                                      Icons
                                          .phone,

                                      size:
                                      16,

                                      color:
                                      primary,
                                    ),

                                    const SizedBox(
                                      width:
                                      8,
                                    ),

                                    Expanded(
                                      child:
                                      Text(
                                        request[
                                        'requesterPhone'],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height:
                                  6,
                                ),

                                Row(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Icon(
                                      Icons
                                          .location_on,

                                      size:
                                      16,

                                      color:
                                      primary,
                                    ),

                                    const SizedBox(
                                      width:
                                      8,
                                    ),

                                    Expanded(
                                      child:
                                      Text(

                                        request[
                                        'requesterAddress'],

                                        style:
                                        const TextStyle(
                                          height:
                                          1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // BUTTONS

                      if (status ==
                          'Pending')

                        Padding(

                          padding:
                          const EdgeInsets
                              .only(
                            top: 24,
                          ),

                          child: Row(
                            children: [

                              Expanded(

                                child:
                                ElevatedButton(

                                  onPressed:
                                      () {

                                    updateStatus(

                                      request,

                                      'Accepted',
                                    );
                                  },

                                  style:
                                  ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.green,

                                    foregroundColor:
                                    Colors.white,

                                    minimumSize:
                                    const Size(
                                      double.infinity,
                                      50,
                                    ),

                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                  ),

                                  child:
                                  const Text(
                                    "Accept",
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(

                                child:
                                ElevatedButton(

                                  onPressed:
                                      () {

                                    updateStatus(

                                      request,

                                      'Rejected',
                                    );
                                  },

                                  style:
                                  ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.red,

                                    foregroundColor:
                                    Colors.white,

                                    minimumSize:
                                    const Size(
                                      double.infinity,
                                      50,
                                    ),

                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        14,
                                      ),
                                    ),
                                  ),

                                  child:
                                  const Text(
                                    "Reject",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // STAT CARD
  // =========================

  Widget buildStat({

    required String value,
    required String label,
  }) {

    return Column(
      children: [

        Text(

          value,

          style: const TextStyle(
            fontSize: 24,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(

          label,

          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // =========================
  // DIVIDER
  // =========================

  Widget buildDivider() {

    return Container(

      width: 1,
      height: 40,

      color: Colors.grey[300],
    );
  }
}