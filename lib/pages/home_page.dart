import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_learn/pages/workshop_page.dart';
import 'package:grade_learn/services/user_service.dart';

const Color kBackgroundColor = Color(0xFFFFFFF9);
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
                    delegate: SliverChildListDelegate([
                      // Adjusted top spacing as SafeArea now handles the status bar area
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'YOUR PROGRESS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkTextColor,
                            ),
                          ),
                        ],
                      ),
                      _buildOlympiadCard(),
                      const SizedBox(height: 20),
                      _buildStatsRow(),
                      const SizedBox(height: 30),
                      _buildProgressPerformanceCard(),
                      const SizedBox(height: 120),
                    ]),
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
              radius: 34,
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
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
                        'HELLO, ${_username.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kDarkTextColor,
                        ),
                      ),
                Row(
                  children: const [
                    SizedBox(width: 5),
                    Text(
                      'HOW ARE YOU TODAY?',
                      style: TextStyle(fontSize: 14, color: kDarkTextColor),
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
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Icon(Icons.search, color: Colors.black, size: 28),
        ),
      ],
    );
  }

  Widget _buildOlympiadCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 220, // 🔥 FIX: gives Stack a boundary
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            /// BACKGROUND IMAGE
            Positioned.fill(
              child: Image.asset('assets/images/files.png', fit: BoxFit.fill),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 56),
                  Row(
                    children: [
                      Expanded(
                        child: _folderButton(
                          iconColor: Colors.green,
                          text: 'COURSES ENROLLED',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _folderButton(
                          iconColor: Colors.deepPurple,
                          text: 'INTERNSHIP ENROLLED',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _folderButton(
                          iconColor: Colors.blue,
                          text: 'CERTIFICATES',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _folderButton(
                          iconColor: Colors.amber,
                          text: 'WORKSHOP ENROLLED',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _folderButton({
    required Color iconColor,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.folder, size: 26, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextButton(
              onPressed: onTap,

              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kDarkTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemedStatCard({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required SizedBox spacer,
    VoidCallback? onTap,
  }) {
    final Color textColor = kDarkTextColor;

    return ElevatedButton(
      onPressed: onTap ?? () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black, width: 2),
        ),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: textColor),
          spacer,
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOMMENDED',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildThemedStatCard(
                icon: Icons.design_services,
                spacer: SizedBox(width: 8),
                title: 'WORKSHOP',
                backgroundColor: Color(0xFFFFE499),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) =>  WorkshopPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildThemedStatCard(
                title: 'CHATBOT',
                icon: FontAwesomeIcons.robot,
                spacer: SizedBox(width: 16),
                backgroundColor: Color(0xFFB6B8FF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressPerformanceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT ENROLLED COURSES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            ],
          ),
        ),
      ],
    );
  }
}
