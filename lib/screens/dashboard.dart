import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_learn/screens/admin_panel.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  // Neo-Brutalism Theme Colors
  final Color _bgYellow = const Color(0xFFFFFFF9);
  final Color _accentOrange = const Color(0xFFFFB67A);
  final Color _accentGreen = const Color(0xFF3CE5C4);
  final Color _accentBlue = const Color(0xFFB5D8FF);

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
            // --- HEADER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderBackBtn(),
                _buildAdminEntryBtn(), 
              ],
            ),
            const SizedBox(height: 20),
            
            _buildProgressTitle(),
            const SizedBox(height: 20),
            
            // --- STATS SUMMARY BAR ---
            _buildStatusSummaryBar(),
            const SizedBox(height: 24),
            
            // --- PROGRESS CARD (SWIPEABLE) ---
            _buildProgressCard(), 
            
            const SizedBox(height: 32),
            
            // --- RECENT ACTIVITY SECTION ---
            const Text("RECENT ACTIVITY ⚡", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            
            // DYNAMIC LIST LOADER
            _buildRecentActivityList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- COMPONENT: STATUS SUMMARY BAR ---
  Widget _buildStatusSummaryBar() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        int approved = 0;
        int pending = 0;

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final status = (doc.data() as Map)['status'];
            if (status == 'approved') approved++;
            else if (status == 'pending') pending++;
          }
        }

        return Row(
          children: [
            _buildSmallCounter("APPROVED", approved.toString(), _accentGreen),
            const SizedBox(width: 12),
            _buildSmallCounter("PENDING", pending.toString(), const Color(0xFFFDE798)),
          ],
        );
      },
    );
  }

  // --- COMPONENT: RECENT ACTIVITY LIST (DYNAMIC) ---
  Widget _buildRecentActivityList() {
    final user = FirebaseAuth.instance.currentUser;
    
    return StreamBuilder<QuerySnapshot>(
      // Ensure 'userId' exists in your Firestore documents and 'appliedAt' is a Timestamp
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('appliedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // 1. Check for errors (This will print the missing index link if it's the problem)
        if (snapshot.hasError) {
          debugPrint("Firestore Error: ${snapshot.error}");
          return Center(child: Text("QUERY ERROR - CHECK CONSOLE"));
        }

        // 2. While waiting for data, show the loading indicator, NOT the empty state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        // 3. Only show empty state if the list is TRULY empty after loading
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final docs = snapshot.data!.docs;
        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final String type = data['type'] ?? 'internship';
            final String status = data['status'] ?? 'pending';
            
            IconData icon = type == 'internship' ? Icons.work_outline : Icons.bolt;
            Color cardColor = type == 'internship' ? _accentBlue : _accentGreen;
            
            double progressValue = 0.5;
            if (status == 'approved') progressValue = 1.0;
            if (status == 'rejected') progressValue = 0.1;

            return _buildBruteTile(
              title: data['itemTitle'] ?? 'UNTITLED',
              category: type.toUpperCase(),
              status: status,
              progress: progressValue,
              color: cardColor,
              icon: icon,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBruteTile({
    required String title,
    required String category,
    required String status,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
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
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color, 
              borderRadius: BorderRadius.circular(12), 
              border: Border.all(color: Colors.black, width: 2)
            ),
            child: Icon(icon, color: Colors.black, size: 28),
          ),
          const SizedBox(width: 16),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(), 
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  category, 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)
                ),
                const SizedBox(height: 12),
                // Progress Bar
                _buildBruteProgressBar(progress, color),
                const SizedBox(height: 8),
                Text(
                  status.toUpperCase(), 
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.1)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BRUTAL PROGRESS BAR ---
  Widget _buildBruteProgressBar(double progress, Color color) {
    return Stack(
      children: [
        Container(
          height: 14, 
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(7), 
            border: Border.all(color: Colors.black, width: 2)
          )
        ),
        FractionallySizedBox(
          widthFactor: progress, 
          child: Container(
            height: 14, 
            decoration: BoxDecoration(
              color: color, 
              borderRadius: BorderRadius.circular(7), 
              border: Border.all(color: Colors.black, width: 2)
            )
          )
        ),
      ],
    );
  }

  // --- STAT BOX HELPER ---
  Widget _buildSmallCounter(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
            Text(count, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  // --- REMAINING UI ELEMENTS ---
  Widget _buildHeaderBackBtn() => GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2.5), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))]), child: const Icon(Icons.arrow_back, color: Colors.black)));
  
  Widget _buildProgressTitle() => const Text("YOUR PROGRESS 📈", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: 1.1));

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
                decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2.5), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))]),
                child: const Icon(Icons.admin_panel_settings, color: Colors.white),
              ),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFFFF6EE), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.black, width: 2.5), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))]),
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

  Widget _buildBruteStat(String value, String label) => Column(children: [Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey))]);
  
  Widget _buildPageIndicator() => Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(2, (index) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: _currentPageIndex == index ? 24 : 12, height: 12, decoration: BoxDecoration(color: _currentPageIndex == index ? Colors.black : Colors.white, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(6)))));

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
        const SizedBox(height: 16),
        const Text("NO ACTIVITY YET", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.grey)),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("EXPLORE NOW", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black))),
      ],
    );
  }
}