import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grade_learn/services/user_service.dart';

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
  final UserService _userService = UserService();
  String _username = 'User';
  bool _isLoadingUsername = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      try {
        final userData = await _userService.fetchUserByUid(currentUser.uid);
        
        if (userData != null && userData['username'] != null) {
          setState(() {
            _username = userData['username'];
            _isLoadingUsername = false;
          });
        } else {
          setState(() {
            _username = 'User';
            _isLoadingUsername = false;
          });
        }
      } catch (e) {
        print('Error loading username: $e');
        setState(() {
          _username = 'User';
          _isLoadingUsername = false;
        });
      }
    } else {
      setState(() {
        _username = 'Guest';
        _isLoadingUsername = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // --- MODIFIED: Wrapped the body in a SafeArea widget for the top only ---
      body: SafeArea(
        bottom: false, // Ensures padding is only applied to the top
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // Adjusted top spacing as SafeArea now handles the status bar area
                        const SizedBox(height: 20), 
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildOlympiadCard(),
                        const SizedBox(height: 20),
                        _buildStatsRow(),
                        const SizedBox(height: 30),
                        _buildProgressPerformanceCard(),
                        const SizedBox(height: 120), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/images/profile.png')
              ) 
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isLoadingUsername
                    ? const SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          color: kPurpleCardColor,
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : Text(
                        'Hello, $_username',
                        style: const TextStyle(
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
            size: 28,
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
        borderRadius: BorderRadius.circular(40),
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kDarkTextColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildThemedStatCard({
    required String title,
    required String value,
    required Color cardColor,
    required Color iconAccentColor,
    required IconData icon,
  }) {
    final Color textColor = kDarkTextColor;
    
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconAccentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    icon, 
                    color: Colors.white, 
                    size: 24
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.0,
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildThemedStatCard(
            title: 'Lessons',
            value: '78',
            cardColor: kLightOrangeColor,
            iconAccentColor: kLightOrangeColor,
            icon: Icons.splitscreen,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildThemedStatCard(
            title: 'Hours',
            value: '43',
            cardColor: kLightPurpleColor,
            iconAccentColor: kLightPurpleColor,
            icon: Icons.watch_later_outlined,
          ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildProgressSegment(
                month: 'June',
                lessons: 23,
                color: kLightOrangeColor,
                percentage: 0.45,
              ),
              _buildProgressSegment(
                month: 'July',
                lessons: 43,
                color: kLightPurpleColor,
                percentage: 0.85,
              ),
              _buildProgressSegment(
                month: 'August',
                lessons: 12,
                color: kDarkTextColor.withOpacity(0.15),
                percentage: 0.25,
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
          Container(
            height: 100,
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100 * percentage,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 10),
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