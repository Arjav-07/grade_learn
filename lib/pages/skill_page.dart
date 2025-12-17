import 'package:flutter/material.dart';
import 'package:grade_learn/models/course.dart';
import 'package:grade_learn/screens/skill_detail_page.dart';


class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Course> _filteredCourses = [];
  bool _showCategories = false;

  final List<Course> _allCourses = [
    Course(
      backgroundColor: const Color(0xFF2C2C2C),
      iconData: Icons.all_out,
      category: 'GEOMETRY IN ACTION',
      title: 'Creative approaches to\nplane shapes',
      userCount: 43000,
      iconColor: Colors.black,
      textColor: Colors.black,
      difficulty: 'INTERMEDIATE',
      timeDuration: '38 HR',
      lessonsNo: '49',
    ),
    Course(
      backgroundColor: const Color(0xFFD3E5FD),
      iconData: Icons.language,
      iconColor: const Color(0xFF00468D),
      textColor: const Color(0xFF00468D),
      category: 'LANGUAGE CONVERSATION',
      title: 'Spanish Conversation\nMastery',
      userCount: 1540000,
      difficulty: 'ADVANCED',
      timeDuration: '45 HR',
      lessonsNo: '128',
    ),
    Course(
      backgroundColor: const Color(0xFFF9BE84),
      iconData: Icons.history_edu,
      iconColor: const Color(0xFF86542A),
      textColor: const Color(0xFF86542A),
      category: 'ANCIENT CIVILIZATIONS',
      title: 'A journey through\nancient Rome',
      userCount: 28000,
      difficulty: 'BEGINNER',
      timeDuration: '132 HR',
      lessonsNo: '92',
    ),
  ];

  final Map<String, String> _categoryMap = {
    'All': 'ALL',
    'LITERARY ANALYSIS': 'LITERATURE',
    'GEOMETRY IN ACTION': 'MATH',
    'LANGUAGE CONVERSATION': 'LANGUAGE',
    'ANCIENT CIVILIZATIONS': 'HISTORY',
  };

  final Map<String, IconData> _iconMap = {
    'ALL': Icons.apps,
    'LITERATURE': Icons.book,
    'MATH': Icons.calculate,
    'LANGUAGE': Icons.language,
    'HISTORY': Icons.history_edu,
  };

  @override
  void initState() {
    super.initState();
    _filteredCourses = _allCourses;
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final categoryMatches =
            _selectedCategory == 'All' || course.category == _selectedCategory;
        final searchMatches =
            searchQuery.isEmpty ||
            course.title.toLowerCase().contains(searchQuery) ||
            course.category.toLowerCase().contains(searchQuery);
        return categoryMatches && searchMatches;
      }).toList();
    });
  }

  void _onCategorySelected(String categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
      _showCategories = false;
    });
    _filterCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _showCategories
                          ? _buildCategorySelector()
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    ..._filteredCourses.map(
                      (course) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CourseDetailScreen(course: course),
                              ),
                            );
                          },
                          child: CourseCard(
                            backgroundColor: course.backgroundColor,
                            iconData: course.iconData,
                            category: course.category,
                            title: course.title,
                            userCount: course.userCount,
                            iconColor: course.iconColor,
                            textColor: course.textColor,
                            difficulty: course.difficulty,
                            timeDuration: course.timeDuration,
                            lessonsNo: course.lessonsNo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WELCOME TO', style: TextStyle(fontSize: 16)),
          Text(
            'COURSES📚',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'EG " WORKSHOP "',
                        border: InputBorder.none,
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => _showCategories = !_showCategories),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Icon(_showCategories ? Icons.close : Icons.tune),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categoryMap.entries.map((entry) {
          final isActive = _selectedCategory == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              side: const BorderSide(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              avatar: Icon(
                _iconMap[entry.value],
                color: isActive ? Colors.white : Colors.black,
              ),
              label: Text(entry.value),
              onPressed: () => _onCategorySelected(entry.key),
              backgroundColor: isActive ? Colors.black : Colors.white,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final Color textColor;
  final String category;
  final String title;
  final int userCount;
  final String difficulty;
  final String timeDuration;
  final String lessonsNo;

  const CourseCard({
    super.key,
    required this.backgroundColor,
    required this.iconData,
    required this.category,
    required this.title,
    required this.userCount,
    required this.difficulty,
    required this.timeDuration,
    required this.lessonsNo,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toUpperCase()) {
      case 'BEGINNER':
        return const Color(0xFFE2FFDD);
      case 'INTERMEDIATE':
        return const Color(0xFFF9E79F);
      case 'ADVANCED':
        return const Color(0xFFFFD4D4);
      default:
        return const Color(0xFFE2FFDD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/google.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.business),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'GOOGLE',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: const Icon(Icons.receipt_long, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.access_time, timeDuration),
                  _infoRow(Icons.menu_book, '$lessonsNo LESSONS'),
                  _infoRow(
                    Icons.people,
                    '${(userCount / 1000).toStringAsFixed(0)}K USERS',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      difficulty.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(Icons.arrow_forward, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
