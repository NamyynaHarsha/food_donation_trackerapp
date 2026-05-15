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

  @override
  void initState() {
    super.initState();

    loadRequests();
  }

  // =========================
  // LOAD REQUESTS
  // =========================

  Future<void> loadRequests() async {

    final data = await DatabaseHelper
        .instance
        .getIncomingRequests(
      widget.user['name'],
    );

    setState(() {

      requests = data;

      isLoading = false;
    });
  }

  // =========================
  // UPDATE STATUS
  // =========================

  Future<void> updateStatus(
    Map<String, dynamic> request,
    String status,
  ) async {

    // UPDATE REQUEST STATUS

    await DatabaseHelper.instance
        .updateRequestStatus(
      request['id'],
      status,
    );

    // IF ACCEPTED
    // REMOVE DONATION FROM PUBLIC

    if (status == 'Accepted') {

      await DatabaseHelper.instance
          .updateDonationStatus(

        request['donationId'],

        'Completed',
      );
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(
        content:
            Text('Request $status'),
      ),
    );

    loadRequests();
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      appBar: AppBar(

        backgroundColor: primary,

        elevation: 0,

        title: const Text(
          "Incoming Requests",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),
      ),

      backgroundColor:
          const Color(0xFFF5F5F5),

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
                        color: Colors.grey[400],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        "No incoming requests yet",

                        style: TextStyle(
                          fontSize: 18,
                          color:
                              Colors.grey[600],
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
                            BorderRadius
                                .circular(20),

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

                          Text(
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

                          const SizedBox(
                            height: 18,
                          ),

                          // REQUESTER INFO

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
                                          'requesterName'][0]
                                      .toUpperCase(),

                                  style:
                                      TextStyle(
                                    color:
                                        primary,

                                    fontSize:
                                        24,

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

                                    Text(
                                      request[
                                          'requesterName'],

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
                                      height:
                                          6,
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
                                          width:
                                              8,
                                        ),

                                        Text(
                                          request[
                                              'requesterPhone'],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height:
                                          6,
                                    ),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

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

                          const SizedBox(
                            height: 22,
                          ),

                          // STATUS

                          Container(

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  status ==
                                          'Accepted'

                                      ? Colors
                                          .green
                                          .withValues(
                                          alpha:
                                              0.12,
                                        )

                                      : status ==
                                              'Rejected'

                                          ? Colors
                                              .red
                                              .withValues(
                                              alpha:
                                                  0.12,
                                            )

                                          : status ==
                                                  'Completed'

                                              ? Colors
                                                  .blue
                                                  .withValues(
                                                  alpha:
                                                      0.12,
                                                )

                                              : Colors
                                                  .orange
                                                  .withValues(
                                                  alpha:
                                                      0.12,
                                                ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                30,
                              ),
                            ),

                            child: Text(

                              status,

                              style:
                                  TextStyle(

                                fontWeight:
                                    FontWeight
                                        .bold,

                                color:
                                    status ==
                                            'Accepted'

                                        ? Colors
                                            .green

                                        : status ==
                                                'Rejected'

                                            ? Colors
                                                .red

                                            : status ==
                                                    'Completed'

                                                ? Colors
                                                    .blue

                                                : Colors
                                                    .orange,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          // BUTTONS

                          if (status ==
                              'Pending')

                            Row(
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
                                          Colors
                                              .green,

                                      foregroundColor:
                                          Colors
                                              .white,

                                      minimumSize:
                                          const Size(
                                        double
                                            .infinity,

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
                                          Colors
                                              .red,

                                      foregroundColor:
                                          Colors
                                              .white,

                                      minimumSize:
                                          const Size(
                                        double
                                            .infinity,

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
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}