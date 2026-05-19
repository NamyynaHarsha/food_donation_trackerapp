import 'dart:io';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import 'donation_details_screen.dart';

class BrowseDonationsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const BrowseDonationsScreen({
    super.key,
    required this.user,
  });

  @override
  State<BrowseDonationsScreen> createState() =>
      _BrowseDonationsScreenState();
}

class _BrowseDonationsScreenState
    extends State<BrowseDonationsScreen> {
  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Meals',
    'Bakery',
    'Dairy',
  ];

  String _selectedCategory = 'All';

  final TextEditingController
  _searchController =
  TextEditingController();

  List<Map<String, dynamic>>
  donations = [];

  List<Map<String, dynamic>>
  filteredDonations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadDonations();

    _searchController.addListener(() {
      filterDonations();
    });
  }

  // =========================
  // LOAD DONATIONS
  // =========================

  Future<void> loadDonations() async {
    final data =
    await DatabaseHelper.instance
        .getAvailableDonations(
      widget.user['id'],
    );

    setState(() {
      donations = data;

      filteredDonations = data;

      isLoading = false;
    });
  }

  // =========================
  // SEARCH FILTER
  // =========================

  void filterDonations() {
    final query =
    _searchController.text
        .toLowerCase();

    setState(() {
      filteredDonations =
          donations.where((donation) {
            final title =
            donation['title']
                .toString()
                .toLowerCase();

            final location =
            donation['location']
                .toString()
                .toLowerCase();

            return title.contains(query) ||
                location.contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
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

      body: Column(
        children: [
          // =========================
          // HEADER
          // =========================

          Container(
            color: primary,

            child: SafeArea(
              bottom: false,

              child: Padding(
                padding:
                const EdgeInsets.all(
                  18,
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context);
                          },

                          child: const Icon(
                            Icons
                                .arrow_back_ios,

                            color:
                            Colors.white,

                            size: 22,
                          ),
                        ),

                        const Text(
                          'Browse Donations',

                          style:
                          TextStyle(
                            color:
                            Colors.white,

                            fontSize: 24,

                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const Icon(
                          Icons.tune,

                          color:
                          Colors.white,

                          size: 25,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // SEARCH BAR

                    Container(
                      height: 52,

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.white,

                        borderRadius:
                        BorderRadius
                            .circular(
                          30,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.06,
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

                      child: TextField(
                        controller:
                        _searchController,

                        decoration:
                        const InputDecoration(
                          hintText:
                          'Search food, location, etc...',

                          hintStyle:
                          TextStyle(
                            color:
                            Colors.grey,

                            fontSize: 14,
                          ),

                          prefixIcon:
                          Icon(
                            Icons.search,

                            color:
                            Colors.grey,
                          ),

                          border:
                          InputBorder
                              .none,

                          contentPadding:
                          EdgeInsets
                              .symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =========================
          // CATEGORY CHIPS
          // =========================

          Container(
            color: Colors.white,

            height: 64,

            child: ListView.builder(
              scrollDirection:
              Axis.horizontal,

              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 14,
              ),

              itemCount:
              _categories.length,

              itemBuilder:
                  (context, index) {
                final isSelected =
                    _selectedCategory ==
                        _categories[
                        index];

                return Padding(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 5,
                    vertical: 12,
                  ),

                  child:
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds:
                      200,
                    ),

                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 18,
                    ),

                    decoration:
                    BoxDecoration(
                      color: isSelected
                          ? primary
                          : Colors.white,

                      borderRadius:
                      BorderRadius
                          .circular(
                        22,
                      ),

                      border: Border.all(
                        color: isSelected
                            ? primary
                            : Colors.grey[
                        300]!,
                      ),
                    ),

                    alignment:
                    Alignment.center,

                    child: Text(
                      _categories[
                      index],

                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,

                        fontWeight:
                        isSelected
                            ? FontWeight
                            .bold
                            : FontWeight
                            .w500,

                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // =========================
          // LOCATION INFO
          // =========================

          Container(
            color: Colors.white,

            padding:
            const EdgeInsets
                .fromLTRB(
              18,
              0,
              18,
              16,
            ),

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

              children: [
                Row(
                  children: [
                    Icon(
                      Icons
                          .location_on_outlined,

                      color: primary,

                      size: 17,
                    ),

                    const SizedBox(
                        width: 4),

                    const Text(
                      'Near you • Within 10 km',

                      style: TextStyle(
                        fontSize: 13,

                        fontWeight:
                        FontWeight
                            .w500,
                      ),
                    ),
                  ],
                ),

                Text(
                  '${filteredDonations.length} donations found',

                  style:
                  const TextStyle(
                    color: Colors.grey,

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // DONATION LIST
          // =========================

          Expanded(
            child: isLoading
                ? const Center(
              child:
              CircularProgressIndicator(),
            )
                : filteredDonations
                .isEmpty
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
                      fontSize:
                      18,

                      color: Colors
                          .grey[
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
                const EdgeInsets
                    .fromLTRB(
                  16,
                  18,
                  16,
                  24,
                ),

                itemCount:
                filteredDonations
                    .length,

                itemBuilder:
                    (context,
                    index) {
                  final item =
                  filteredDonations[
                  index];

                  return Padding(
                    padding:
                    const EdgeInsets
                        .only(
                      bottom: 18,
                    ),

                    child:
                    GestureDetector(
                      onTap:
                          () async {
                        await Navigator
                            .push(
                          context,

                          MaterialPageRoute(
                            builder:
                                (context) =>
                                DonationDetailsScreen(
                                  donation:
                                  item,

                                  currentUser:
                                  widget.user,
                                ),
                          ),
                        );

                        loadDonations();
                      },

                      child:
                      Container(
                        height: 128,

                        decoration:
                        BoxDecoration(
                          color: Colors
                              .white,

                          borderRadius:
                          BorderRadius
                              .circular(
                            22,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.04,
                              ),

                              blurRadius:
                              12,

                              offset:
                              const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child:
                        Padding(
                          padding:
                          const EdgeInsets
                              .all(
                            12,
                          ),

                          child: Row(
                            children: [
                              // IMAGE

                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(
                                  16,
                                ),

                                child: item['imageUrl'] !=
                                    null &&
                                    item['imageUrl']
                                        .toString()
                                        .isNotEmpty
                                    ? Image.file(
                                  File(
                                    item['imageUrl'],
                                  ),

                                  width:
                                  95,

                                  height:
                                  95,

                                  fit: BoxFit
                                      .cover,
                                )
                                    : Container(
                                  width:
                                  95,

                                  height:
                                  95,

                                  color:
                                  Colors.grey[
                                  300],

                                  child:
                                  const Center(
                                    child:
                                    Icon(
                                      Icons
                                          .broken_image,

                                      color:
                                      Colors.grey,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  width:
                                  14),

                              // DETAILS

                              Expanded(
                                child:
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                                  children: [
                                    Text(
                                      item[
                                      'title'],

                                      maxLines:
                                      1,

                                      overflow:
                                      TextOverflow
                                          .ellipsis,

                                      style:
                                      const TextStyle(
                                        fontSize:
                                        17,

                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,

                                          size:
                                          14,

                                          color:
                                          Colors.grey,
                                        ),

                                        const SizedBox(
                                            width:
                                            4),

                                        Expanded(
                                          child:
                                          Text(
                                            item['location'],

                                            overflow:
                                            TextOverflow.ellipsis,

                                            style:
                                            const TextStyle(
                                              fontSize:
                                              12,

                                              color:
                                              Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.shopping_bag_outlined,

                                          size:
                                          14,

                                          color:
                                          Colors.grey,
                                        ),

                                        const SizedBox(
                                            width:
                                            4),

                                        Expanded(
                                          child:
                                          Text(
                                            item['quantity'],

                                            overflow:
                                            TextOverflow.ellipsis,

                                            style:
                                            const TextStyle(
                                              fontSize:
                                              12,

                                              color:
                                              Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline,

                                          size:
                                          14,

                                          color:
                                          Colors.grey,
                                        ),

                                        const SizedBox(
                                            width:
                                            4),

                                        Expanded(
                                          child:
                                          Text(
                                            item['donorName'],

                                            overflow:
                                            TextOverflow.ellipsis,

                                            style:
                                            const TextStyle(
                                              fontSize:
                                              12,

                                              color:
                                              Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                  width: 8),

                              // STATUS

                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .end,

                                children: [
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal:
                                      10,

                                      vertical:
                                      5,
                                    ),

                                    decoration:
                                    BoxDecoration(
                                      color:
                                      primary.withOpacity(
                                        0.12,
                                      ),

                                      borderRadius:
                                      BorderRadius.circular(
                                        8,
                                      ),
                                    ),

                                    child:
                                    Text(
                                      'Available',

                                      style:
                                      TextStyle(
                                        color:
                                        primary,

                                        fontSize:
                                        11,

                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const Icon(
                                    Icons
                                        .arrow_forward_ios,

                                    size: 15,

                                    color:
                                    Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}