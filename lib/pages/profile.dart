import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/auth/onboarding_page.dart';
import 'package:grade_learn/settings/setting.dart';
import 'package:grade_learn/screens/applied.dart';
import 'package:grade_learn/screens/completed.dart';
import 'package:grade_learn/screens/dashboard.dart';
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
  String _joinedYear = '2025'; // Dynamic year fallback
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final userData = await _userService.fetchUserByUid(currentUser.uid);
        if (userData != null) {
          setState(() {
            _username = userData['username'] ?? 'User';
            
            // --- NEW: Dynamic Year Fetching ---
            if (userData['createdAt'] != null) {
              // Convert Firestore Timestamp to DateTime object
              DateTime date = (userData['createdAt'] as Timestamp).toDate();
              _joinedYear = "${date.year}"; 
            }
            
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint("Error loading profile: $e");
        setState(() => _isLoading = false);
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                  ),
                  _buildCircularIconBtn(
                    icon: Icons.settings, 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HERO PROFILE CARD
                      _buildProfileHeroCard(),

                      const SizedBox(height: 30),

                      const Text(
                        "ACCOUNT & ACTIVITY",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 16),

                      // 2. MENU TILES
                      _buildMenuTile(
                        icon: Icons.leaderboard_outlined,
                        title: "STATISTICS DASHBOARD",
                        desc: "DETAILED INSIGHTS INTO YOUR LEARNING PROGRESS.",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardPage())),
                      ),
                      _buildMenuTile(
                        icon: Icons.route_outlined,
                        title: "APPLIED PROGRAMS",
                        desc: "TRACK THE STATUS OF YOUR ACTIVE APPLICATIONS.",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AppliedPage())),
                      ),
                      _buildMenuTile(
                        icon: Icons.emoji_events_outlined,
                        title: "COMPLETED COURSES",
                        desc: "ACCESS ALL YOUR FINISHED LESSONS.",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompletedPage())),
                      ),

                      const SizedBox(height: 30),

                      // 3. LOGOUT BUTTON
                      _buildLogoutButton(context),

                      const SizedBox(height: 80), 
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

  // ---------------- UI HELPERS ----------------

  Widget _buildProfileHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: kBrutalistBlue,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        children: [
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
              backgroundImage: AssetImage('assets/images/grad_cap.jpg'),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const SizedBox(width: 120, child: LinearProgressIndicator(color: kBrutalistPurple))
              : Text(
                  _username.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
          Text(
            "LEARNER SINCE $_joinedYear", // Dynamic Date
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          _buildBadgeTag(),
        ],
      ),
    );
  }

  Widget _buildBadgeTag() {
    return Container(
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
          Text("VERIFIED LEARNER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMenuTile({required IconData icon, required String title, required String desc, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 32, color: Colors.black),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward, color: Colors.black),
      ),
    );
  }

  Widget _buildCircularIconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _signOutAndNavigate(context),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [BoxShadow(color: kBrutalistPurple, offset: Offset(4, 4))],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("LOGOUT ACCOUNT", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            SizedBox(width: 12),
            Icon(Icons.logout, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}