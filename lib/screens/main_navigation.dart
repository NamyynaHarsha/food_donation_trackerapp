import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'post_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {

  final Map<String, dynamic> user;

  const MainNavigation({
    super.key,
    required this.user,
  });

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [

      DashboardScreen(
        user: widget.user,
      ),

      ProfileScreen(
        user: widget.user,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(

      body: screens[currentIndex],

      floatingActionButton:
      FloatingActionButton(

        backgroundColor: primary,

        elevation: 4,

        shape: const CircleBorder(),

        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),

        onPressed: () {

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  PostDonationScreen(
                    user: widget.user,
                  ),
            ),
          );
        },
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation
          .centerDocked,

      bottomNavigationBar: BottomAppBar(

        height: 75,

        shape:
        const CircularNotchedRectangle(),

        notchMargin: 10,

        color: Colors.white,

        elevation: 10,

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceAround,

          children: [

            // HOME
            GestureDetector(

              onTap: () {

                setState(() {
                  currentIndex = 0;
                });
              },

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.home,

                    color: currentIndex == 0
                        ? primary
                        : Colors.grey,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Home",

                    style: TextStyle(
                      color: currentIndex == 0
                          ? primary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 40),

            // PROFILE
            GestureDetector(

              onTap: () {

                setState(() {
                  currentIndex = 1;
                });
              },

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.person_outline,

                    color: currentIndex == 1
                        ? primary
                        : Colors.grey,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Profile",

                    style: TextStyle(
                      color: currentIndex == 1
                          ? primary
                          : Colors.grey,
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
}