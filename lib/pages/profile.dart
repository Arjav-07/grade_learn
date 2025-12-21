import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/settings/setting.dart';
import 'package:grade_learn/screens/applied.dart';
import 'package:grade_learn/screens/completed.dart';
import 'package:grade_learn/screens/dashboard.dart';
import 'package:grade_learn/screens/recent.dart';
import 'package:grade_learn/services/user_service.dart';

// --- Brutalist Design Constants ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistYellow = Color(0xFFFDE798);
const Color kBrutalistPurple = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF282C35);

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
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
        setState(() {
          _username = (userData != null && userData['username'] != null)
              ? userData['username']
              : 'User';
          _isLoadingUsername = false;
        });
      } catch (e) {
        setState(() {
          _username = 'User';
          _isLoadingUsername = false;
        });
      }
    }
  }

  Future<void> _signOutAndNavigate(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // --- TOP NAVIGATION ROW ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "MY PROFILE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(Icons.settings, color: Colors.black, size: 24),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- SCROLLABLE CONTENT ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HERO PROFILE CARD (Matching Chatbot Hero Card)
                      _buildProfileHeroCard(),

                      const SizedBox(height: 30),

                      // 2. SECTION TITLE
                      const Text(
                        "ACCOUNT & ACTIVITY",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. MENU TILES (Matching Chatbot Feature Tiles)
                      _buildMenuTile(
                        icon: Icons.access_time,
                        title: "RECENT ACTIVITY",
                        desc: "VIEW YOUR PAST ENROLLMENTS AND WATCHLIST HISTORY.",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const WatchlistPage())),
                      ),
                      _buildMenuTile(
                        icon: Icons.leaderboard_outlined,
                        title: "STATISTICS DASHBOARD",
                        desc: "DETAILED INSIGHTS INTO YOUR LEARNING PROGRESS AND HOURS.",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const DashboardPage())),
                      ),
                      _buildMenuTile(
                        icon: Icons.route_outlined,
                        title: "APPLIED PROGRAMS",
                        desc: "TRACK THE STATUS OF YOUR 7 ACTIVE APPLICATIONS.",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AppliedPage())),
                      ),
                      _buildMenuTile(
                        icon: Icons.emoji_events_outlined,
                        title: "COMPLETED COURSES",
                        desc: "ACCESS ALL YOUR FINISHED LESSONS AND ACHIEVEMENTS.",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CompletedPage())),
                      ),

                      const SizedBox(height: 30),

                      // 4. LOGOUT BUTTON
                      _buildLogoutButton(context),

                      const SizedBox(height: 80), // Bottom Padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- PROFILE HERO CARD (Chatbot Style) ----------------
  Widget _buildProfileHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: kBrutalistBlue,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: Column(
        children: [
          // Profile Image with Bold Border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
          const SizedBox(height: 20),
          _isLoadingUsername
              ? const SizedBox(width: 120, child: LinearProgressIndicator(color: kBrutalistPurple))
              : Text(
                  _username.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
          const Text(
            "LEARNER SINCE 2024",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),

          // Badge Tag (Chatbot Style)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: kBrutalistYellow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, size: 16, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "VERIFIED LEARNER",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------------- MENU TILE (Chatbot Style) ----------------
  Widget _buildMenuTile(
      {required IconData icon, required String title, required String desc, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 32, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.black),
      ),
    );
  }

  // ---------------- LOGOUT BUTTON ----------------
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _signOutAndNavigate(context),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: kBrutalistPurple,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LOGOUT ACCOUNT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.logout, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}