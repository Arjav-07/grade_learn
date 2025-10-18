import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Data Model for a Course ---
class Course {
  final String title;
  final String category;
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final int userCount;

  Course({
    required this.title,
    required this.category,
    required this.iconData,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    required this.userCount,
  });
}

// --- Main Page Widget ---
class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  // --- State Variables ---
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Course> _filteredCourses = [];
  bool _showCategories = false;

  // --- Master list of all available courses ---
  final List<Course> _allCourses = [
    Course(
      backgroundColor: const Color(0xFF2C2C2C),
      iconData: Icons.all_out,
      category: 'GEOMETRY IN ACTION',
      title: 'Creative approaches to\nplane shapes',
      userCount: 43,
    ),
    Course(
      backgroundColor: const Color(0xFFE4D9FF),
      iconData: Icons.science_outlined,
      iconColor: const Color(0xFF65499D),
      textColor: const Color(0xFF65499D),
      category: 'THE MICROCOSM AROUND US',
      title: 'Discoveries in\ncell biology',
      userCount: 12,
    ),
    Course(
      backgroundColor: const Color(0xFFF9BE84),
      iconData: Icons.history_edu,
      iconColor: const Color(0xFF86542A),
      textColor: const Color(0xFF86542A),
      category: 'ANCIENT CIVILIZATIONS',
      title: 'A journey through\nancient Rome',
      userCount: 28,
    ),
    Course(
      backgroundColor: const Color(0xFFD4EFFF),
      iconData: Icons.edit,
      iconColor: const Color(0xFF3B6D8F),
      textColor: const Color(0xFF3B6D8F),
      category: 'LITERARY ANALYSIS',
      title: 'Deconstructing the\nclassics',
      userCount: 51,
    ),
  ];

  // Map backend category names to display names for chips
  final Map<String, String> _categoryMap = {
    'All': 'All',
    'LITERARY ANALYSIS': 'Literature',
    'GEOMETRY IN ACTION': 'Math',
    'THE MICROCOSM AROUND US': 'Biology',
    'ANCIENT CIVILIZATIONS': 'History',
  };
  
  // Map display names to icons
  final Map<String, IconData> _iconMap = {
    'All': Icons.apps,
    'Literature': Icons.book,
    'Math': Icons.calculate,
    'Biology': Icons.biotech,
    'History': Icons.history_edu,
  };


  @override
  void initState() {
    super.initState();
    _filteredCourses = _allCourses;
    _searchController.addListener(_filterCourses);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    super.dispose();
  }

  // --- Filtering Logic ---
  void _filterCourses() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final categoryMatches = _selectedCategory == 'All' || course.category == _selectedCategory;
        final searchMatches = searchQuery.isEmpty ||
            course.title.toLowerCase().contains(searchQuery) ||
            course.category.toLowerCase().contains(searchQuery);
        return categoryMatches && searchMatches;
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFFFB67A),
      // --- MODIFIED: The SafeArea widget is now set to ignore the bottom ---
      body: SafeArea(
        bottom: false, // This is the key change
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Container(
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
                      _buildSearchBar(),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _showCategories ? _buildCategorySelector() : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 20),
                      ..._filteredCourses.map((course) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: CourseCard(
                              backgroundColor: course.backgroundColor,
                              iconData: course.iconData,
                              category: course.category,
                              title: course.title,
                              userCount: course.userCount,
                              iconColor: course.iconColor,
                              textColor: course.textColor,
                            ),
                      )).toList(),
                      if (_filteredCourses.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            'No courses found.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      // Adjusted top padding since SafeArea handles the status bar space
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: SizedBox(
              height: 180,
              child: Image.asset('assets/images/grad_cap.jpg', fit: BoxFit.contain),
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
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 28),
              ),
              const SizedBox(height: 20),
              const Text(
                'My\ncourses',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Colors.black),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatPill('12 Subjects', const Color(0xFF2C2C2C)),
                  const SizedBox(width: 10),
                  _buildStatPill('43 Lessons', Colors.white.withOpacity(0.2)),
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
        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
                hintText: 'Search for courses...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black87, size: 24),
            onPressed: () {
              setState(() {
                _showCategories = !_showCategories;
              });
            },
          ),
        ],
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
        backgroundColor: isActive ? const Color(0xFF2C2C2C) : const Color(0xFFF3F3F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}


// --- Reusable Course Card Widget (No changes needed here) ---
class CourseCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final Color textColor;
  final String category;
  final String title;
  final int userCount;

  const CourseCard({
    super.key,
    required this.backgroundColor,
    required this.iconData,
    required this.category,
    required this.title,
    required this.userCount,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 220,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor),
              ),
              Icon(Icons.open_in_new, color: iconColor),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAvatarStack(),
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

  Widget _buildAvatarStack() {
    const double overlap = 20.0;
    final urls = [
      'https://randomuser.me/api/portraits/women/79.jpg',
      'https://randomuser.me/api/portraits/men/41.jpg',
      'https://randomuser.me/api/portraits/women/44.jpg',
    ];

    List<Widget> stackChildren = List.generate(urls.length, (index) {
      return Positioned(
        left: index * overlap,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(urls[index]),
          ),
        ),
      );
    });

    stackChildren.add(
      Positioned(
        left: urls.length * overlap,
        child: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFF39B64),
          child: Text(
            '+$userCount',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      width: (urls.length + 1) * overlap + 36,
      height: 36,
      child: Stack(
        children: stackChildren,
      ),
    );
  }
}