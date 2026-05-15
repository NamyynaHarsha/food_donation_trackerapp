import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();

  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Reduce Food Waste",
      "description":
          "Connect with neighbors to share surplus food and help those in need.",
      "image":
          "https://t4.ftcdn.net/jpg/01/84/16/83/360_F_184168316_XuIwBx9xLpC6y3E67HpS3EMMDaM6WIju.jpg",
    },
    {
      "title": "Help Your Community",
      "description":
          "Make an impact by donating extra food easily and safely.",
      "image":
          "https://img.freepik.com/premium-vector/volunteers-help-charity-set-with-people-care-helping-seniours-invalids-poor-social-support-illustrations-set-volunteering-community-donation-voluntary_109722-2233.jpg",
    },
    {
      "title": "Track Your Impact",
      "description":
          "See how many meals you’ve shared and lives you’ve helped.",
      "image":
          "https://img.freepik.com/premium-vector/donate-icon-vector_946691-933.jpg?w=360",
    },
  ];

  void nextPage() {
    if (currentIndex == pages.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,

                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(25),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: Image.network(
                            pages[index]["image"]!,
                            height: 280,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Text(
                          pages[index]["title"]!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          pages[index]["description"]!,
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),

                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  width: currentIndex == index ? 22 : 8,
                  height: 8,

                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? primary
                        : Colors.grey[400],

                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),

              child: SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,

                    padding: const EdgeInsets.symmetric(vertical: 18),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: nextPage,

                  child: Text(
                    currentIndex == pages.length - 1
                        ? "Get Started"
                        : "Next",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}