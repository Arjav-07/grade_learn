import 'package:flutter/material.dart';

// --- Placeholder Color Definitions (Needed for the Header widget) ---
const Color kDarkTextColor = Colors.black;
const Color kLightOrangeColor = Color(0xFFFFB67A);


void main() {
  runApp(const SkillPage());
}

class SkillPage extends StatelessWidget {
  const SkillPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Color(0xFFF7F7F9), // Set global scaffold background to white
      ),
      home: const CourseHomePage(),
    );
  }
}

class CourseHomePage extends StatelessWidget {
  const CourseHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25), // Spacing after header
              _buildSearchBar(),
              const SizedBox(height: 30), // Spacing after search bar
              
              _buildFeaturedCard(),
              const SizedBox(height: 32),
              _buildSectionHeader('My Course 🤩', 'See all'),
              const SizedBox(height: 16),
              _buildMyCourseCard(),
              const SizedBox(height: 28),
              _buildFilterBar(),
              const SizedBox(height: 20),
              _buildCourseGrid(),
            ],
          ),
        ),
      ),
    );
  }
  
  // --- Header Widget: Profile and Notification ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Placeholder for the user avatar image
            CircleAvatar(
              radius: 40, // Adjusted size for better fit
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 38,
                // Replace with actual image asset
                backgroundImage: AssetImage('assets/images/profile.png')
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: kDarkTextColor,
            size: 28
          ),
        ),
      ],
    );
  }
  
  // --- Search Bar Widget ---
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Light grey background
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search for courses, skills, and topics...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none, // Removes the default underline
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 24),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
        style: TextStyle(color: kDarkTextColor),
      ),
    );
  }

  // --- Featured Card Widget (Blender 3D) ---
  Widget _buildFeaturedCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient( // Subtle white-to-light-grey gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7A64D8), Color(0xFF7A64D8)], 
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Lighter shadow for white background
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12,
            bottom: 40,
            child: Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.09), // Subtle black opacity for internal circle
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Blender 3D',
                          style: TextStyle(
                            color: Colors.white, // Changed to black
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Class 🎓',
                          style: TextStyle(
                            color: Colors.white, // Changed to black
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05), // Subtle black opacity background
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            '30% OFF',
                            style: TextStyle(
                              color: Colors.white, // Changed to black
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      '👋',
                      style: TextStyle(fontSize: 60),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Section Header Widget ---
  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black, // Changed to black
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Colors.grey, // Adjusted to grey for 'See all'
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // --- My Course Card Widget (Premiere Pro) ---
  Widget _buildMyCourseCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient( // Subtle white-to-light-grey gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Lighter shadow
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF7c3aed).withOpacity(0.15), // Tinted background for the icon
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Pr',
                style: TextStyle(
                  color: Color(0xFF7c3aed), // Use a specific color for the icon text
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adobe Premiere Pro',
                  style: TextStyle(
                    color: Colors.black, // Changed to black
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '4h 5 min left • 22 lessons',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7), // Slightly faded black
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Bar Widget (All Course Header) ---
  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'All Course ✨',
          style: TextStyle(
            color: Colors.black, // Changed to black
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06), // Lighter shadow
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Text(
                'Popular',
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 20, color: Colors.black), // Icon color to black
            ],
          ),
        ),
      ],
    );
  }

  // --- Course Grid Widget ---
  Widget _buildCourseGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildCourseCard(
          'Ai',
          'Adobe',
          'Illustrator',
          '5.0',
          const [Color(0xFFFF7684), Color(0xFFFF9EA7)], // Lighter red gradient
        ),
        _buildCourseCard(
          'F',
          'Figma',
          'UI Design',
          '4.9',
          const [Color(0xFFFF9FEA), Color(0xFFFFC0F5)], // Lighter pink gradient
        ),
        _buildCourseCard(
          'Ps',
          'Photoshop',
          'Photo Editing',
          '4.8',
          const [Color(0xFF8CD8FF), Color(0xFFB3E5FF)], // Lighter blue gradient
        ),
        _buildCourseCard(
          'Ae',
          'After Effects',
          'Animation',
          '4.7',
          const [Color(0xFF9AFFD4), Color(0xFFC4FFE8)], // Lighter teal gradient
        ),
      ],
    );
  }

  // --- Individual Course Card Widget ---
  Widget _buildCourseCard(
    String icon,
    String title,
    String subtitle,
    String rating,
    List<Color> gradientColors,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Lighter shadow
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05), // Subtle black opacity
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05), // Subtle black opacity background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7), // Slightly faded black icon text
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black, // Changed to black
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7), // Slightly faded black
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          '⭐',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.black, // Changed to black
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}