import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/pages/setting.dart';
import 'package:grade_learn/screens/applied.dart';
import 'package:grade_learn/screens/completed.dart';
import 'package:grade_learn/screens/dashboard.dart';
import 'package:grade_learn/screens/recent.dart';
import 'package:grade_learn/services/user_service.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  // User-related state
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
        debugPrint('Error loading username: $e');
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required String unit,
  }) {
    return Expanded(
      child: Container(
        height: 92,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$value $unit',
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    const Color kCardColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sign out helper
  Future<void> _signOutAndNavigate(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.black;
    const Color cardBlue = Color(0xFF7A64D8);
    const Color cardOrange = Color(0xFFFF9900);
    const Color iconDark = Color(0xFF424242);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 0),
          children: [
            const SizedBox(height: 20),

            // --- 1. User Info Section ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade200,
                        child: const CircleAvatar(
                          radius: 38,
                          backgroundImage:
                              AssetImage('assets/images/profile.png'),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _isLoadingUsername
                              ? const SizedBox(
                                  width: 140,
                                  child: LinearProgressIndicator(
                                    color: cardBlue,
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              : Text(
                                  'Hello, $_username',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                          Row(
                            children: [
                              Icon(Icons.flash_on,
                                  size: 20, color: cardOrange),
                              const SizedBox(width: 5),
                              const Text(
                                'Progress: 72%',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  // --- MODIFIED: Wrapped settings icon to make it tappable ---
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.grey.shade300, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: primaryColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 2. Stat Cards Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard(
                    title: 'Lesson Completed',
                    value: '78',
                    unit: '',
                    color: cardOrange,
                  ),
                  _buildStatCard(
                    title: 'Hours Completed',
                    value: '43',
                    unit: '',
                    color: cardBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. Scrollable Menu List ---
            _buildDetailTile(
              icon: Icons.access_time,
              title: 'Recents',
              subtitle: 'Past Enrolls',
              iconColor: iconDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecentsPage()),
                );
              },
            ),
            _buildDetailTile(
              icon: Icons.leaderboard_outlined,
              title: 'My Dashboard',
              subtitle: 'Get your Statistics',
              iconColor: iconDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()),
                );
              },
            ),
            _buildDetailTile(
              icon: Icons.route_outlined,
              title: 'Applied',
              subtitle: '7',
              iconColor: iconDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppliedPage()),
                );
              },
            ),
            _buildDetailTile(
              icon: Icons.emoji_events_outlined,
              title: 'Completed',
              subtitle: 'Show all',
              iconColor: iconDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CompletedPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            // --- 4. Centered Logout Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _signOutAndNavigate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF7A64D8).withOpacity(0.7),
                    foregroundColor: Colors.white, // White text/icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.logout, size: 24),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}