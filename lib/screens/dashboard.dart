import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/screens/admin_panel.dart'; // Ensure this path is correct

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  // Neo-Brutalism Colors
  final Color _bgYellow = const Color(0xFFFFFFF9);
  final Color _accentOrange = const Color(0xFFFFB67A);
  final Color _accentPurple = const Color(0xFF7A64D8);
  final Color _accentGreen = const Color(0xFF3CE5C4);

  final List<Map<String, dynamic>> _pastWeeksData = [
    {
      'title': 'This Week',
      'lessons': 48,
      'hours': 12,
      'chartData': {'Mon': 39.0, 'Tue': 14.0, 'Wed': 48.0, 'Thr': 24.0, 'Fri': 22.0}
    },
    {
      'title': 'Last Week',
      'lessons': 42,
      'hours': 10,
      'chartData': {'Mon': 25.0, 'Tue': 30.0, 'Wed': 45.0, 'Thr': 15.0, 'Fri': 35.0}
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgYellow,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderBackBtn(),
                _buildAdminEntryBtn(), // Admin button only visible to admins
              ],
            ),
            const SizedBox(height: 10),
            _buildProgressTitle(),
            const SizedBox(height: 24),
            _buildProgressCard(), // Includes the swipeable bar charts
            const SizedBox(height: 32),
            _buildRecentCoursesHeader(),
            const SizedBox(height: 20),
            _buildRecentCoursesList(), // Now powered by live Firebase data
          ],
        ),
      ),
    );
  }

  // --- ADMIN ROLE CHECK ---
  Widget _buildAdminEntryBtn() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['role'] == 'admin') {
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanel())),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.5),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
                ),
                child: const Icon(Icons.admin_panel_settings, color: Colors.white),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  // --- RECENT ACTIVITY LIST (FIREBASE) ---
  Widget _buildRecentCoursesList() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('appliedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("NO APPLICATIONS YET", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
          );
        }

        final docs = snapshot.data!.docs;
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final bool isInternship = data['type'] == 'internship';
            final String status = data['status'] ?? 'pending';

            // Calculate progress and color based on status
            double progressValue = 0.5;
            Color tileTheme = _accentOrange;
            if (status == 'approved') {
              progressValue = 1.0;
              tileTheme = _accentGreen;
            } else if (status == 'rejected') {
              progressValue = 0.0;
              tileTheme = Colors.redAccent;
            }

            return _buildBruteTile({
              'title': data['itemTitle'] ?? 'Untitled',
              'author': isInternship ? "INTERNSHIP" : "WORKSHOP",
              'status': status,
              'progress': progressValue,
              'color': isInternship ? _accentPurple : tileTheme,
              'icon': isInternship ? Icons.work : Icons.event,
            });
          }).toList(),
        );
      },
    );
  }

  // --- UI COMPONENT: APPLICATION TILE ---
  Widget _buildBruteTile(Map<String, dynamic> item) {
    Color statusBg;
    switch (item['status'].toString().toLowerCase()) {
      case 'approved': statusBg = const Color(0xFFE2FFDD); break;
      case 'rejected': statusBg = const Color(0xFFFFD4D4); break;
      default: statusBg = const Color(0xFFF9E79F);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: item['color'], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2)),
            child: Icon(item['icon'] as IconData, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16), overflow: TextOverflow.ellipsis)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black, width: 1.5)),
                      child: Text(item['status'].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
                    ),
                  ],
                ),
                Text(item['author'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                _buildBruteProgressBar(item['progress'], item['color']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PROGRESS CARD (SWIPEABLE CHARTS) ---
  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EE),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.insights, color: Colors.white)),
              Text(_pastWeeksData[_currentPageIndex]['title'].toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pastWeeksData.length,
              onPageChanged: (index) => setState(() => _currentPageIndex = index),
              itemBuilder: (context, index) => _buildWeekPage(index),
            ),
          ),
          const SizedBox(height: 10),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildWeekPage(int index) {
    final weekData = _pastWeeksData[index];
    final chartData = weekData['chartData'] as Map<String, double>;
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildBruteStat(weekData['lessons'].toString(), 'LESSONS'), _buildBruteStat(weekData['hours'].toString(), 'HOURS')]),
        const SizedBox(height: 20),
        _buildBarChart(chartData),
      ],
    );
  }

  Widget _buildBarChart(Map<String, double> data) {
    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((entry) {
          bool isActive = entry.value == maxValue;
          double barHeight = (entry.value / maxValue) * 100;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 32, height: barHeight,
                decoration: BoxDecoration(color: isActive ? _accentOrange : Colors.white, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text("${entry.value.toInt()}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: isActive ? Colors.white : Colors.black)),
              ),
              const SizedBox(height: 4),
              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          );
        }).toList(),
      ),
    );
  }

  // --- SMALL HELPERS ---
  Widget _buildHeaderBackBtn() => GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2.5), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))]), child: const Icon(Icons.arrow_back, color: Colors.black)));
  Widget _buildProgressTitle() => const Text("YOUR PROGRESS 📈", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: 1.1));
  Widget _buildRecentCoursesHeader() => const Text("RECENT ACTIVITY", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900));
  Widget _buildBruteStat(String value, String label) => Column(children: [Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey))]);
  
  Widget _buildBruteProgressBar(double progress, Color color) {
    return Stack(
      children: [
        Container(height: 12, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black, width: 1.5))),
        FractionallySizedBox(widthFactor: progress, child: Container(height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black, width: 1.5)))),
      ],
    );
  }

  Widget _buildPageIndicator() => Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(2, (index) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: _currentPageIndex == index ? 24 : 12, height: 12, decoration: BoxDecoration(color: _currentPageIndex == index ? Colors.black : Colors.white, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(6)))));
}