// --- DATA MODELS (Static Elements & Quality of Code) ---

class DonationHistoryItem {
  final String title;
  final String date;
  final String status;
  final String imageUrl;

  const DonationHistoryItem({
    required this.title,
    required this.date,
    required this.status,
    required this.imageUrl,
  });
}

class DonationItem {
  final String title;
  final String quantity;
  final String distance;
  final String timeAgo;
  final String description;
  final String imageUrl;
  final String donorName;

  const DonationItem({
    required this.title,
    required this.quantity,
    required this.distance,
    required this.timeAgo,
    required this.description,
    required this.imageUrl,
    required this.donorName,
  });

  static List<DonationItem> mockDonations = [

    const DonationItem(
      title: "Organic Red Apples",
      quantity: "3 kg",
      distance: "0.8 km",
      timeAgo: "2 hours ago",
      description:
          "Freshly picked from my garden, too many to eat!",
      imageUrl:
          "https://cdn.pixabay.com/photo/2016/08/12/22/34/apple-1589869_1280.jpg",
      donorName: "Sarah J.",
    ),

    const DonationItem(
      title: "Whole Wheat Bread",
      quantity: "2 loaves",
      distance: "1.2 km",
      timeAgo: "4 hours ago",
      description:
          "Freshly baked this morning, extra loaves available.",
      imageUrl:
          "https://images.unsplash.com/photo-1715189997923-dd8bf6e9bd91?q=80&w=1170&auto=format&fit=crop",
      donorName: "John D.",
    ),

    const DonationItem(
      title: "Fresh Carrots",
      quantity: "1 kg",
      distance: "2.5 km",
      timeAgo: "1 day ago",
      description:
          "Crispy carrots from the local farm market.",
      imageUrl:
          "https://images.unsplash.com/photo-1757332914679-0906a57881e1?q=80&w=1170&auto=format&fit=crop",
      donorName: "Emma W.",
    ),
  ];
}

class UserProfile {
  final String name;
  final String donorLevel;
  final String bio;
  final int totalDonations;
  final int peopleHelped;
  final String profileImageUrl;
  final List<DonationHistoryItem> donationHistory;

  const UserProfile({
    required this.name,
    required this.donorLevel,
    required this.bio,
    required this.totalDonations,
    required this.peopleHelped,
    required this.profileImageUrl,
    required this.donationHistory,
  });

  static const UserProfile mockProfile = UserProfile(
    name: "Daisy",

    donorLevel: "Top Food Contributor",

    bio:
        "Helping reduce food waste by sharing extra meals with the community.",

    totalDonations: 15,

    peopleHelped: 42,

    profileImageUrl:
        "https://images.unsplash.com/photo-1602233158242-3ba0ac4d2167?q=80&w=736&auto=format&fit=crop",

    donationHistory: [

      DonationHistoryItem(
        title: "Fresh Vegetables",
        date: "May 20, 2025",
        status: "Completed",
        imageUrl:
            "https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=1200&auto=format&fit=crop",
      ),

      DonationHistoryItem(
        title: "Cooked Fried Rice",
        date: "May 15, 2025",
        status: "Completed",
        imageUrl:
            "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=1200&auto=format&fit=crop",
      ),

      DonationHistoryItem(
        title: "Bread & Pastries",
        date: "May 10, 2025",
        status: "Completed",
        imageUrl:
            "https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=1200&auto=format&fit=crop",
      ),

      DonationHistoryItem(
        title: "Fresh Fruits",
        date: "May 2, 2025",
        status: "Completed",
        imageUrl:
            "https://images.unsplash.com/photo-1619566636858-adf3ef46400b?q=80&w=1200&auto=format&fit=crop",
      ),

      DonationHistoryItem(
        title: "Packed Meals",
        date: "Apr 28, 2025",
        status: "Completed",
        imageUrl:
            "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1200&auto=format&fit=crop",
      ),
    ],
  );
}