import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_learn/screens/internship_detail_page.dart';

// --- Data Model for a Lesson Card (Renamed and updated fields) ---
class LessonCardData {
  final String lessonTitle; // Formerly jobTitle
  final String instructor; // Formerly company
  final String level; // Formerly location
  final String price; // Formerly salary
  final String totalDuration; // Formerly duration
  final String? tagText;
  final IconData? tagIcon;
  final Color cardColor;
  final Color textColor;

  LessonCardData({
    required this.lessonTitle,
    required this.instructor,
    required this.level,
    required this.price,
    required this.totalDuration,
    this.tagText,
    this.tagIcon,
    required this.cardColor,
    required this.textColor,
  });
}

// --- Color Palette ---
const Color kOrangeHeader = Color(0xFFF9A86E);
const Color kOrangePill = Color(0xFFE87A3E);
const Color kDarkPill = Color(0xFF2C2C2C);
const Color kPageBackground = Color(0xFFF3F3F3);
const Color kPurpleCardColor = Color(0xFF7A64D8);
const Color kDarkTextColor = Color(0xFF2C2C2C);

// --- Main Widget for the Page ---
class InternshipPage extends StatefulWidget {
  const InternshipPage({super.key});

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

class _InternshipPageState extends State<InternshipPage> {
  final TextEditingController _searchController = TextEditingController();

  // Updated Data to LessonCardData
  final List<LessonCardData> _allLessons = [
    LessonCardData(
      tagText: 'Web Dev',
      tagIcon: Icons.html_outlined,
      lessonTitle: 'Introduction to React.js',
      instructor: 'Dr. Angela Yu',
      level: 'Intermediate',
      price: '\$ 49.99 (one time)',
      totalDuration: '10 Hours',
      cardColor: const Color(0xFFF9BE84),
      textColor: const Color(0xFF86542A),
    ),
    LessonCardData(
      tagText: 'Trending',
      tagIcon: Icons.trending_up,
      lessonTitle: 'Complete Python Bootcamp',
      instructor: 'Jose Portilla',
      level: 'Beginner',
      price: '\$ 19.99 (sale price)',
      totalDuration: '22 Hours',
      cardColor: const Color(0xFFE4D9FF),
      textColor: const Color(0xFF65499D),
    ),
    LessonCardData(
      tagText: 'Mobile',
      tagIcon: Icons.phone_android,
      lessonTitle: 'Advanced Flutter State Management',
      instructor: 'Andrea Bizzotto',
      level: 'Expert',
      price: '\$ 99.00',
      totalDuration: '18 Lessons',
      cardColor: kDarkPill,
      textColor: Colors.white,
    ),
    LessonCardData(
      tagText: 'Database',
      tagIcon: Icons.storage,
      lessonTitle: 'SQL and PostgreSQL Basics',
      instructor: 'Zomato Academy',
      level: 'Beginner',
      price: 'Free',
      totalDuration: '5 Hours',
      cardColor: const Color(0xFF673AB7),
      textColor: Colors.white,
    ),
  ];

  List<LessonCardData> _filteredLessons = [];
  String _selectedCategory = 'All';
  bool _showCategories = false;

  final Map<String, String> _categoryMap = {
    'All': 'All',
    'Web Dev': 'Web Dev',
    'Mobile': 'Mobile',
    'Database': 'Database',
    'Trending': 'Trending',
  };

  final Map<String, IconData> _iconMap = {
    'All': Icons.apps,
    'Web Dev': Icons.html_outlined,
    'Mobile': Icons.phone_android,
    'Database': Icons.storage,
    'Trending': Icons.trending_up,
  };

  @override
  void initState() {
    super.initState();
    _filteredLessons = _allLessons;
    _searchController.addListener(_filterLessons);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLessons);
    _searchController.dispose();
    super.dispose();
  }

  void _filterLessons() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredLessons = _allLessons.where((lesson) {
        final categoryMatches =
            _selectedCategory == 'All' || lesson.tagText == _selectedCategory;
        final searchMatches = searchQuery.isEmpty ||
            lesson.lessonTitle.toLowerCase().contains(searchQuery) ||
            lesson.instructor.toLowerCase().contains(searchQuery);
        return categoryMatches && searchMatches;
      }).toList();
    });
  }

  void _onCategorySelected(String categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
    });
    _filterLessons();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFF9093E1).withOpacity(0.9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildLessonContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Changed image for lessons/courses
          Positioned(
            top: -40,
            right: -20,
            child: SizedBox(
              height: 180,
              child: Image.asset(
                // NOTE: Use a different asset for "learning" if available
                'assets/images/grad_cap.jpg', 
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.black, size: 28),
              ),
              const SizedBox(height: 20),
              const Text(
                'Find your \nnext course', // Updated text
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatPill('92% Progress', const Color(0xFF2C2C2C)), // Updated stat
                  const SizedBox(width: 10),
                  _buildStatPill('5 Enrolled', Colors.white.withOpacity(0.2)), // Updated stat
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildLessonContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _showCategories
                  ? _buildCategorySelector()
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader(context, 'Recommended Courses'), // Updated text
            const SizedBox(height: 16),
            _buildLessonList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList() {
    if (_filteredLessons.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Text(
            'No matching lessons found.', // Updated text
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredLessons.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final lesson = _filteredLessons[index];
        // --- NAVIGATE AND PASS THE DATA ---
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Pass the LessonCardData object
                builder: (context) => InternshipDetailsPage(lessonData: lesson), 
              ),
            );
          },
          child: _buildLessonCard(
            lessonTitle: lesson.lessonTitle,
            instructor: lesson.instructor,
            level: lesson.level,
            price: lesson.price,
            totalDuration: lesson.totalDuration,
            tagText: lesson.tagText,
            tagIcon: lesson.tagIcon,
            cardColor: lesson.cardColor,
            textColor: lesson.textColor,
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 60,
      decoration: BoxDecoration(
        color: kPageBackground,
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for courses...', // Updated text
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: kDarkTextColor, size: 24),
            onPressed: () {
              setState(() {
                _showCategories = !_showCategories;
              });
            },
            tooltip: 'Filter by Category',
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categoryMap.entries.map((entry) {
            final categoryKey = entry.key;
            final categoryName = entry.value;
            final bool isActive = _selectedCategory == categoryKey;

            return GestureDetector(
              onTap: () => _onCategorySelected(categoryKey),
              child: _buildCategoryChip(
                categoryName,
                _iconMap[categoryName] ?? Icons.error,
                isActive,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title, IconData icon, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Chip(
        avatar: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey[600],
          size: 18,
        ),
        label: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            isActive ? const Color(0xFF2C2C2C) : const Color(0xFFF3F3F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kDarkTextColor,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color.withOpacity(0.8), size: 20),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }

  // Updated method name and parameters to reflect lessons
  Widget _buildLessonCard({
    required String lessonTitle,
    required String instructor,
    required String level,
    required String price,
    required String totalDuration,
    String? tagText,
    IconData? tagIcon,
    required Color cardColor,
    required Color textColor,
  }) {
    final bool isDarkCard = textColor == Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tagText != null && tagIcon != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDarkCard
                    ? Colors.white.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tagIcon, color: textColor, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    tagText,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          if (tagText != null) const SizedBox(height: 16),
          Text(
            lessonTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            instructor,
            style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: textColor.withOpacity(0.2)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                        Icons.school_outlined, level, textColor), // Level
                    _buildDetailRow(
                        Icons.payments_outlined, price, textColor), // Price
                    _buildDetailRow(
                        Icons.schedule, totalDuration, textColor), // Duration
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}