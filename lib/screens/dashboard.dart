import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grade_learn/services/user_service.dart';

// Color constants for consistency
const Color kPurpleCardColor = Color(0xFF7A64D8);
const Color kLightOrangeColor = Color(0xFFFFB67A);
const Color kDarkTextColor = Color(0xFF282C35);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final UserService _userService = UserService();

  late PageController _pageController;
  int _currentPageIndex = 0;

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
    {
      'title': '2 Weeks Ago',
      'lessons': 55,
      'hours': 14,
      'chartData': {'Mon': 40.0, 'Tue': 20.0, 'Wed': 55.0, 'Thr': 30.0, 'Fri': 18.0}
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // This function can now be removed if the username is no longer displayed,
  // but I'll leave it in case you need it for other purposes.
  Future<void> _loadUsername() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser != null) {
      try {
        final userData = await _userService.fetchUserByUid(currentUser.uid);
        
        if (userData != null && userData['username'] != null) {
          if (mounted) {
            setState(() {
            });
          }
        } else {
           if (mounted) {
            setState(() {
            });
          }
        }
      } catch (e) {
        print('Error loading username: $e');
        if (mounted) {
          setState(() {
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 10), // Reduced spacing after header
            _buildProgressTitle(),
            const SizedBox(height: 20),
            _buildProgressCard(),
            const SizedBox(height: 30),
            _buildRecentCourses(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  // --- MODIFIED: Header now only contains the back arrow ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align to the start
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDarkTextColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildProgressTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Progress',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              )
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.grid_view_rounded, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'All subjects',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF232323),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bar_chart_rounded, color: Colors.white),
              ),
              Text(
                _pastWeeksData[_currentPageIndex]['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pastWeeksData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildWeekPage(index);
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildWeekPage(int index) {
    final weekData = _pastWeeksData[index];
    final lessonsCount = weekData['lessons'].toString();
    final hoursCount = weekData['hours'].toString();
    final chartData = weekData['chartData'] as Map<String, double>;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(lessonsCount, 'lessons'),
            _buildStatColumn(hoursCount, 'hours'),
          ],
        ),
        const SizedBox(height: 15),
        _buildBarChart(chartData),
      ],
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(text: '$value '),
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> data) {
    final maxValue = data.values.isNotEmpty ? data.values.reduce((a, b) => a > b ? a : b) : 1.0;

    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.entries.map((entry) {
          final bool isActive = entry.value == maxValue;
          return _buildBar(entry.key, entry.value, maxValue, isActive: isActive);
        }).toList(),
      ),
    );
  }

  Widget _buildBar(String day, double value, double maxValue, {bool isActive = false}) {
    final barHeight = (value / maxValue) * 120;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 45,
          height: barHeight > 0 ? barHeight : 0,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE5883C) : const Color(0xFFFFDCC1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isActive)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(-0.5, -0.8),
                      colors: [Colors.transparent, Colors.white24, Colors.transparent],
                      stops: [0.0, 0.5, 1.0],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                ),
              Text(
                '${value.toInt()}',
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFFE5883C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pastWeeksData.length, (index) {
        return _buildDot(isActive: _currentPageIndex == index);
      }),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildRecentCourses() {
    // Dummy data for recent courses
    final List<Map<String, dynamic>> recentCourses = [
      {
        'icon': Icons.design_services,
        'color': const Color(0xFF6F6AE8),
        'title': 'UI/UX Fundamentals',
        'author': 'by John Doe',
        'progress': 0.75, // 75%
      },
      {
        'icon': Icons.code,
        'color': const Color(0xFFE5883C),
        'title': 'Flutter for Beginners',
        'author': 'by Jane Smith',
        'progress': 0.40, // 40%
      },
      {
        'icon': Icons.storage,
        'color': const Color(0xFF3CE5C4),
        'title': 'Firebase Firestore',
        'author': 'by Mike Ross',
        'progress': 0.90, // 90%
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Courses',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentCourses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final course = recentCourses[index];
            return _buildCourseProgressTile(
              icon: course['icon'],
              color: course['color'],
              title: course['title'],
              author: course['author'],
              progress: course['progress'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCourseProgressTile({
    required IconData icon,
    required Color color,
    required String title,
    required String author,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  author,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: color.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(fontWeight: FontWeight.bold, color: color),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}