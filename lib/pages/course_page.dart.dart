import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_learn/screens/course_detail_page.dart';
import '../models/course.dart';

class SkillPage extends StatefulWidget {
  const SkillPage({super.key});
  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = true;
  bool _showCategories = false;

  // --- MAPS FOR CATEGORY UI ---
  final Map<String, String> _categoryMap = {
    'All': 'ALL',
    'GEOMETRY IN ACTION': 'MATH',
    'LANGUAGE CONVERSATION': 'LANGUAGE',
    'ANCIENT CIVILIZATIONS': 'HISTORY',
  };

  final Map<String, IconData> _iconMap = {
    'ALL': Icons.apps,
    'MATH': Icons.calculate,
    'LANGUAGE': Icons.language,
    'HISTORY': Icons.history_edu,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterCourses);
  }

  Future<void> _loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allCourses = data.map((c) => Course.fromJson(c)).toList();
        _filteredCourses = _allCourses;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses.where((c) {
        final catMatch = _selectedCategory == 'All' || c.category == _selectedCategory;
        final searchMatch = c.title.toLowerCase().contains(query) || 
                          c.category.toLowerCase().contains(query);
        return catMatch && searchMatch;
      }).toList();
    });
  }

  void _onCategorySelected(String categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
    });
    _filterCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      body: SafeArea(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _buildCategorySelector(),
                            )
                          : const SizedBox.shrink(),
                    ),
                    
                    ..._filteredCourses.map(
                      (course) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(course: course),
                              ),
                            );
                          },
                          child: CourseCard(course: course),
                        ),
                      ),
                    ),
                    
                    if (_filteredCourses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "NO COURSES MATCH YOUR SEARCH",
                            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey),
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
      padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WELCOME TO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          Text('COURSES📚', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
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
                border: Border.all(color: Colors.black, width: 2.5),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'SEARCH COURSES...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => _showCategories = !_showCategories),
            child: Container(
              height: 56, width: 56,
              decoration: BoxDecoration(
                color: _showCategories ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
              ),
              child: Icon(
                _showCategories ? Icons.close : Icons.tune,
                color: _showCategories ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categoryMap.entries.map((entry) {
          final isActive = _selectedCategory == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              side: const BorderSide(color: Colors.black, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              avatar: Icon(
                _iconMap[entry.value],
                color: isActive ? Colors.white : Colors.black,
                size: 18,
              ),
              label: Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              onPressed: () => _onCategorySelected(entry.key),
              backgroundColor: isActive ? Colors.black : Colors.white,
              labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  Color _getDifficultyColor(String difficulty) {
    if (difficulty.toUpperCase().contains('BEGINNER')) return const Color(0xFFE2FFDD);
    if (difficulty.toUpperCase().contains('INTERMEDIATE')) return const Color(0xFFF9E79F);
    return const Color(0xFFFFD4D4);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    course.logoPath, 
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.business, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title.toUpperCase(), 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      course.providerName.toUpperCase(), 
                      style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.receipt_long, size: 24),
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
                  _infoRow(Icons.access_time, course.timeDuration),
                  _infoRow(Icons.menu_book, '${course.lessonsNo} LESSONS'),
                  _infoRow(Icons.people, '${(course.userCount / 1000).toStringAsFixed(0)}K USERS'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(course.difficulty),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Text(
                      course.difficulty.toUpperCase(), 
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
                    ),
                  ),
                ],
              ),
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
                ),
                child: const Icon(Icons.arrow_forward, size: 28),
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
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
        ],
      ),
    );
  }
}