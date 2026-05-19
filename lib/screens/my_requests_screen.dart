import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class MyRequestsScreen
    extends StatefulWidget {

  final Map<String, dynamic> user;

  const MyRequestsScreen({
    super.key,
    required this.user,
  });

  @override
  State<MyRequestsScreen> createState() =>
      _MyRequestsScreenState();
}

class _MyRequestsScreenState
    extends State<MyRequestsScreen> {

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

    final data =
    await DatabaseHelper.instance
        .getUserRequests(
      widget.user['id'],
    );

    final pending =
        data.where((request) {

          return request['status'] ==
              'Pending';

        }).length;

    setState(() {

      requests = data;

      pendingCount = pending;

      isLoading = false;
    });
  }

  // =========================
  // COMPLETE REQUEST
  // =========================


  Future<void> completeRequest(
      int requestId,
      int donationId,
      ) async {

    // UPDATE REQUEST STATUS

    await DatabaseHelper.instance
        .updateRequestStatus(
      requestId,
      'Completed',
    );

    // UPDATE DONATION STATUS

    await DatabaseHelper.instance
        .updateDonationStatus(
      donationId,
      'Completed',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Request marked as completed',
        ),
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

  // =========================
  // STATUS MESSAGE
  // =========================

  String getStatusMessage(
      String status,
      ) {

    switch (status) {

      case 'Accepted':
        return 'Your request has been accepted. Please contact the donor for collection.';

      case 'Rejected':
        return 'Unfortunately, your request was rejected by the donor.';

      case 'Completed':
        return 'Food collection has been completed successfully.';

      default:
        return 'Waiting for donor response...';
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

              "My Requests",

              style: TextStyle(
                color: Colors.white,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(width: 10),

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
              Icons.receipt_long,
              size: 90,
              color:
              Colors.grey[400],
            ),

            const SizedBox(
              height: 20,
            ),

            Text(

              "No requests made yet",

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

          : ListView.builder(

        padding:
        const EdgeInsets.all(
          16,
        ),

        itemCount:
        requests.length,

        itemBuilder:
            (context, index) {

          final request =
          requests[index];

          final status =
          request['status'];

          final statusColor =
          getStatusColor(
            status,
          );

          return Container(

            margin:
            const EdgeInsets.only(
              bottom: 18,
            ),

            padding:
            const EdgeInsets.all(
              18,
            ),

            decoration:
            BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(
                20,
              ),

              boxShadow: [

                BoxShadow(
                  color: Colors.black
                      .withValues(
                    alpha: 0.05,
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
                      child: Text(

                        request[
                        'foodTitle'],

                        style:
                        const TextStyle(
                          fontSize: 22,

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
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration:
                      BoxDecoration(

                        color:
                        statusColor
                            .withValues(
                          alpha: 0.12,
                        ),

                        borderRadius:
                        BorderRadius
                            .circular(
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
                          FontWeight
                              .bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // DONOR INFO

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

                        request[
                        'donorName'][0]
                            .toUpperCase(),

                        style:
                        TextStyle(

                          color:
                          primary,

                          fontSize: 24,

                          fontWeight:
                          FontWeight
                              .bold,
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

                          const Text(

                            "Requested From",

                            style:
                            TextStyle(
                              color:
                              Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(

                            request[
                            'donorName'],

                            style:
                            const TextStyle(
                              fontSize: 18,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Row(
                            children: [

                              Icon(
                                Icons.phone,
                                size: 16,
                                color:
                                primary,
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Expanded(
                                child: Text(

                                  request[
                                  'donorPhone'] ??
                                      '',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Row(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Icon(
                                Icons
                                    .location_on,
                                size: 16,
                                color:
                                primary,
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Expanded(
                                child: Text(

                                  request[
                                  'donorAddress'] ??
                                      '',

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

                const SizedBox(
                  height: 22,
                ),

                // STATUS MESSAGE

                Container(

                  width:
                  double.infinity,

                  padding:
                  const EdgeInsets
                      .all(16),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.grey[100],

                    borderRadius:
                    BorderRadius
                        .circular(
                      14,
                    ),
                  ),

                  child: Text(

                    getStatusMessage(
                      status,
                    ),

                    style: TextStyle(

                      color:
                      Colors.grey[
                      800],

                      height: 1.5,
                    ),
                  ),
                ),

                // COMPLETE BUTTON

                if (status ==
                    'Accepted')

                  Padding(

                    padding:
                    const EdgeInsets
                        .only(
                      top: 18,
                    ),

                    child: SizedBox(

                      width:
                      double.infinity,

                      height: 50,

                      child:
                      ElevatedButton(

                        onPressed: () {

                          completeRequest(

                            request['id'],

                            request['donationId'],
                          );
                        },

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          primary,

                          foregroundColor:
                          Colors.white,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),
                        ),

                        child:
                        const Text(
                          "Mark as Completed",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}