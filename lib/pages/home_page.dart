// --- HOME PAGE IMPLEMENTATION ---

// Define the custom color palette from the image
import 'package:flutter/material.dart';
import 'package:grade_learn/widgets/navbar.dart';

const Color kBackgroundColor = Color(0xFFF7F7F9);
const Color kPurpleCardColor = Color(0xFF7A64D8);
const Color kLightOrangeColor = Color(0xFFFFB67A);
const Color kLightPurpleColor = Color(0xFF9093E1);
const Color kDarkTextColor = Color(0xFF282C35);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Set Home as the default selected item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, you would navigate to different pages here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // Wrap the content in a Stack to position the NavBar at the bottom
      body: Stack(
        children: [
          // Main content takes up most of the screen
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 80),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildOlympiadCard(),
                      const SizedBox(height: 20),
                      _buildStatsRow(),
                      const SizedBox(height: 30),
                      _buildProgressPerformanceCard(),
                      // Extra space to prevent content from being hidden behind the NavBar
                      const SizedBox(height: 120), 
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Navigation Bar positioned at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: NavBar(
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Placeholder for the user avatar image
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              child: CircleAvatar(
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
                      size: 18,
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
            ,
          ),
        ),
      ],
    );
  }

  Widget _buildOlympiadCard() {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: kPurpleCardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: kPurpleCardColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to ',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  'Upgrade?',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ready to to Ride the Next Wave of Learning?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                // --- REVISED ARROW BUTTON ---
                Container(
                  width: 50, // Fixed width
                  height: 50, // Fixed height
                  decoration: BoxDecoration(
                    color: kDarkTextColor, // Dark background
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2), // White outer ring
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24, // Slightly larger arrow icon
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Placeholder for the Trophy image
          Expanded(
            child: Image.asset(
              'assets/images/trophy.png',

              height: 180,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 130, // Fixed height for alignment
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: kDarkTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          title: 'Lessons',
          value: '78',
          color: kLightOrangeColor,
          icon: Icons.format_list_bulleted,
        ),
        const SizedBox(width: 20),
        _buildStatCard(
          title: 'Hours',
          value: '43',
          color: kLightPurpleColor,
          icon: Icons.timer_outlined,
        ),
      ],
    );
  }

  Widget _buildProgressPerformanceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Progress performance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkTextColor,
                ),
              ),
              Icon(Icons.more_horiz, color: kDarkTextColor),
            ],
          ),
          const SizedBox(height: 20),
          // The Progress Bar/Timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildProgressSegment(
                month: 'June',
                lessons: 23,
                color: kLightOrangeColor,
                percentage: 0.45, // Arbitrary visual percentage
              ),
              _buildProgressSegment(
                month: 'July',
                lessons: 43,
                color: kLightPurpleColor,
                percentage: 0.85, // Arbitrary visual percentage
              ),
              _buildProgressSegment(
                month: 'August',
                lessons: 12,
                color: kDarkTextColor.withOpacity(0.15),
                percentage: 0.25, // Arbitrary visual percentage
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSegment({
    required String month,
    required int lessons,
    required Color color,
    required double percentage,
  }) {
    return Expanded(
      child: Column(
        children: [
          // Vertical Bar
          Container(
            height: 100, // Fixed total height for the graph
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100 * percentage, // Dynamic height based on percentage
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Horizontal Indicator Line with a circle
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Text Labels
          Column(
            children: [
              Text(
                month,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kDarkTextColor,
                ),
              ),
              Text(
                '$lessons lessons',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}