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

  @override
  void initState() {
    super.initState();

    loadRequests();
  }

  // =========================
  // LOAD MY REQUESTS
  // =========================

  Future<void> loadRequests() async {

    final data = await DatabaseHelper
        .instance
        .getMyRequests(
      widget.user['name'],
    );

    setState(() {

      requests = data;

      isLoading = false;
    });
  }

  // =========================
  // COMPLETE REQUEST
  // =========================

  Future<void> completeRequest(
    int requestId,
  ) async {

    await DatabaseHelper.instance
        .updateRequestStatus(
      requestId,
      'Completed',
    );

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

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      appBar: AppBar(

        backgroundColor: primary,

        elevation: 0,

        title: const Text(
          "My Requests",

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
                        Icons.receipt_long,
                        size: 90,
                        color: Colors.grey[400],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Text(
                        "No requests made yet",

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

                                    const Text(
                                      "Requested From",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .grey,
                                      ),
                                    ),

                                    const SizedBox(
                                      height:
                                          4,
                                    ),

                                    Text(
                                      request[
                                          'donorName'],

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
                                          8,
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
                                                  'donorPhone'] ??
                                              '',
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
                                            request['donorAddress'] ??
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

                          // STATUS LABEL

                          Row(
                            children: [

                              const Text(
                                "Request Status",

                                style:
                                    TextStyle(
                                  fontSize: 15,

                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const Spacer(),

                              Container(

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 16,
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
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          // STATUS MESSAGE

                          Container(

                            width: double.infinity,

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

                              status ==
                                      'Accepted'

                                  ? 'Your request has been accepted. Please contact the donor for collection.'

                                  : status ==
                                          'Rejected'

                                      ? 'Unfortunately, your request was rejected by the donor.'

                                      : status ==
                                              'Completed'

                                          ? 'Food collection has been completed successfully.'

                                          : 'Waiting for donor response...',

                              style: TextStyle(
                                color:
                                    Colors.grey[
                                        800],

                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          // COMPLETE BUTTON

                          if (status ==
                              'Accepted')

                            SizedBox(
                              width:
                                  double.infinity,

                              height: 50,

                              child:
                                  ElevatedButton(

                                onPressed: () {

                                  completeRequest(
                                    request[
                                        'id'],
                                  );
                                },

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      primary,

                                  foregroundColor:
                                      Colors
                                          .white,

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
                                  "Mark as Completed",
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