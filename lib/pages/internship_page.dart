import 'package:flutter/material.dart';

// --- Color Palette based on the image ---
const Color kBackgroundColor = Color(0xFFF7F7F9); // White background
const Color kDarkTextColor = Color(0xFF282C35); // Dark text/icon color
const Color kPurpleCardColor = Color(0xFF7A64D8); // Primary purple for recommended card
const Color kLightCardBackground = Color.fromARGB(255, 255, 255, 255); // Very light grey/white for standard cards
const Color kChipColorDark = Color(0xFF282C35);
const Color kChipColorLight = Color(0xFFF0F0F0);
// **MISSING COLOR CONSTANT ADDED**
const Color kLightOrangeColor = Color(0xFFFF9900); // Placeholder orange for progress icon

// --- Main Widget for the Page ---

class InternshipPage extends StatelessWidget {
  const InternshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // **HEADER/PROFILE SECTION ADDED HERE**
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildHeader(),
              ),
              const SizedBox(height: 30),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 30),

              // Featured Jobs Section
              _buildSectionHeader(context, 'Featured Jobs'),
              const SizedBox(height: 16),
              _buildFeaturedJobsList(),
              const SizedBox(height: 30),

              // Recommended Jobs Section
              _buildSectionHeader(context, 'Recommended'),
              const SizedBox(height: 16),
              // Use the custom widget for the Recommended Card (Purple Style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildRecommendedJobCard(
                  jobTitle: 'Sr. Lead Designer',
                  company: 'Youtube',
                  salary: '\$100k - 120k / year',
                  iconText: '▶', // Using a YouTube-like icon/text
                  color: kPurpleCardColor,
                  jobType1: 'Full Time',
                  jobType2: 'Office',
                ),
              ),
              const SizedBox(height: 20),
              
              // Second Recommended Card (Standard Style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildStandardJobCard(
                  jobTitle: 'Product Designer',
                  company: 'Dribbble',
                  salary: '\$50k - 80k / year',
                  iconText: '🏀', // Dribbble icon
                  iconColor: const Color(0xFFea4c89),
                  jobType1: 'Freelance',
                  jobType2: 'Remote',
                ),
              ),
              const SizedBox(height: 100), // Extra space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // **Extracted Header/Profile Widget**
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // User Avatar: Using a NetworkImage placeholder since 'assets/images/profile.png' is not available
            CircleAvatar(
              radius: 40, // Adjusted radius for a more standard look
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 38,
                // Replace with actual image asset
                backgroundImage: AssetImage('assets/images/profile.png'
              )
              ) 
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello, Arjav',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kDarkTextColor,
                  ),
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.flash_on,
                      size: 20,
                      color: kLightOrangeColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Progress: 72%',
                      style: TextStyle(
                        fontSize: 14,
                        color: kDarkTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Notification Bell Icon
        Container(
          width: 60, // Adjusted size
          height: 60, // Adjusted size
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: kDarkTextColor,
            size: 28,
          ),
        ),
      ],
    );
  }

  // --- UI Components ---

// --- Search Bar Widget ---
Widget _buildSearchBar() {
  // Use kLightCardBackground for the background color consistency
  const Color searchBarColor = Colors.white; 

  return Container(
    // Added a small horizontal padding for visual separation from the sides
    padding: const EdgeInsets.symmetric(horizontal: 20.0), 
    height: 60, // Fixed height makes the pill shape look better
    decoration: BoxDecoration(
      color: searchBarColor, 
      // The radius needs to be about half the height to make the ends circular
      borderRadius: BorderRadius.circular(30.0), 
      border: Border.all(color: Colors.grey.shade200, width: 1.0),
    ),
    child: Row(
      children: [
        const Icon(Icons.search, color: Colors.grey, size: 24),
        const SizedBox(width: 8),
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search a job',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero, // Remove default padding
            ),
            style: TextStyle(color: kDarkTextColor),
          ),
        ),
        // Filter Icon with Circular Edges
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kDarkTextColor, // A darker color for the filter button
            borderRadius: BorderRadius.circular(20), // Half the width/height
          ),
          child: const Icon(
            Icons.tune,
            color: Colors.white, // White icon on dark background
            size: 20,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kDarkTextColor,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle 'See all' tap
            },
            child: const Text(
              'See all',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey, // Subtle color
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // --- Horizontal List for Featured Jobs ---
  Widget _buildFeaturedJobsList() {
    return SizedBox(
      height: 200, // Fixed height for the horizontal list
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          // 1. Featured Card 1 (Figma)
          _buildFeaturedJobCard(
            jobTitle: 'UX Designer',
            company: 'Figma',
            salary: '\$80k - 110k / year',
            iconText: 'F', // Figma icon
            iconColor: const Color(0xFFf24e1e),
            jobType1: 'Full Time',
            jobType2: 'Remote',
            jobType3: 'Junior',
          ),
          const SizedBox(width: 16),
          // 2. Featured Card 2 (Google)
          _buildFeaturedJobCard(
            jobTitle: 'Data Analyst',
            company: 'Google',
            salary: '\$100k - 130k / year',
            iconText: 'G', // Google icon
            iconColor: const Color(0xFF4285F4),
            jobType1: 'Full Time',
            jobType2: 'Office',
            jobType3: 'Senior',
          ),
          const SizedBox(width: 16),
          // Add more cards if needed
        ],
      ),
    );
  }


  // --- Individual Featured Job Card Widget (Horizontal List) ---
  Widget _buildFeaturedJobCard(
      {required String jobTitle,
      required String company,
      required String salary,
      required String iconText,
      required Color iconColor,
      required String jobType1,
      required String jobType2,
      required String jobType3}) {
    return Container(
      width: 280, // Fixed width for horizontal card
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kLightCardBackground, // Light background
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Info and Bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconContainer(iconText, iconColor, Colors.white),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: kDarkTextColor),
                      ),
                      Text(
                        company,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.bookmark_border, color: Colors.grey, size: 24),
            ],
          ),
          const SizedBox(height: 15),

          // Job Type Chips
          Row(
            children: [
              _buildChip(jobType1, isDark: false),
              const SizedBox(width: 8),
              _buildChip(jobType2, isDark: false),
              const SizedBox(width: 8),
              _buildChip(jobType3, isDark: false),
            ],
          ),
          const Spacer(),

          // Salary
          Text(
            salary,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kDarkTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // --- Recommended Job Card Widget (Purple, Vertical List) ---
  Widget _buildRecommendedJobCard({
    required String jobTitle,
    required String company,
    required String salary,
    required String iconText,
    required Color color,
    required String jobType1,
    required String jobType2,
  }) {
    return Container(
      height: 150, // Fixed height for a comfortable feel
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Company Info and Bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconContainer(iconText, Colors.white, kPurpleCardColor),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        company,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.bookmark_sharp, color: Colors.white, size: 24),
            ],
          ),

          // Bottom Row: Chips and Salary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildChip(jobType1, isDark: true),
                  const SizedBox(width: 8),
                  _buildChip(jobType2, isDark: true),
                ],
              ),
              Text(
                salary,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Standard Job Card Widget (Light Grey, Vertical List) ---
  Widget _buildStandardJobCard({
    required String jobTitle,
    required String company,
    required String salary,
    required String iconText,
    required Color iconColor,
    required String jobType1,
    required String jobType2,
  }) {
    return Container(
      height: 150, // Fixed height for a comfortable feel
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kLightCardBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Company Info and Bookmark
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconContainer(iconText, iconColor, kLightCardBackground),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: kDarkTextColor),
                      ),
                      Text(
                        company,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.bookmark_border, color: Colors.grey, size: 24),
            ],
          ),

          // Bottom Row: Chips and Salary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildChip(jobType1, isDark: false),
                  const SizedBox(width: 8),
                  _buildChip(jobType2, isDark: false),
                ],
              ),
              Text(
                salary,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kDarkTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // --- Helper Widgets ---

  // Custom Icon Container (e.g., F for Figma, G for Google)
  Widget _buildIconContainer(String text, Color iconColor, Color bgColor) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        // Add border for contrast if background is very light
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: iconColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Custom Job Type Chip
  Widget _buildChip(String label, {required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? kChipColorDark.withOpacity(0.4) : kChipColorLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white : kDarkTextColor.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// **MAIN APP WRAPPER FOR RUNNABILITY**
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InternshipPage(),
    );
  }
}