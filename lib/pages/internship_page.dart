import 'package:flutter/material.dart';
import 'package:grade_learn/models/Intenship.dart';
import 'package:grade_learn/screens/internship_detail_page.dart';

/// [COMPONENT: DATA MODEL]
/// Defines the structure for an Internship object.
class Internship {
  final String role;
  final String company;
  final String location;
  final String stipend;
  final String duration;
  final String category;
  final Color cardColor;
  final Color textColor;
  final IconData iconData;
  final String type;

  Internship({
    required this.role,
    required this.company,
    required this.location,
    required this.stipend,
    required this.duration,
    required this.category,
    required this.cardColor,
    required this.textColor,
    required this.iconData, required this.type,
  });
}

class InternshipPage extends StatefulWidget {
  const InternshipPage({super.key});

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

class _InternshipPageState extends State<InternshipPage> {
  // Controllers and State variables
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _showCategories = false;

  /// [COMPONENT: DATA SOURCE]
  /// Hardcoded list of internships. In a real app, this would come from an API.
  final List<Internship> _allInternships = [
    Internship(
      role: 'UI/UX DESIGN INTERNSHIP',
      company: 'GOOGLE',
      location: 'INDIA',
      stipend: '\$3,500/Mo',
      duration: '6 MONTHS',
      category: 'DESIGN',
      cardColor: const Color(0xFFD3E5FD),
      textColor: const Color(0xFF00468D),
      iconData: Icons.brush, type: 'REMOTE',
    ),
    Internship(
      role: 'Backend Developer',
      company: 'AMAZON',
      location: 'SEATTLE, WA',
      stipend: '\$4,200/Mo',
      duration: '3 MONTHS',
      category: 'DEV',
      cardColor: const Color(0xFFF9BE84),
      textColor: const Color(0xFF86542A),
      iconData: Icons.code,
      type: 'ON-SITE',
    ),
    Internship(
      role: 'Data Scientist',
      company: 'META',
      location: 'HYBRID',
      stipend: '\$5,000/Mo',
      duration: '4 MONTHS',
      category: 'DATA',
      cardColor: const Color(0xFF2C2C2C),
      textColor: Colors.white,
      iconData: Icons.analytics,
      type: 'HYBRID',
    ),
  ];

  List<Internship> _filteredInternships = [];

  // Mapping for the filter chips UI
  final Map<String, String> _categoryMap = {
    'All': 'ALL',
    'DESIGN': 'DESIGN',
    'DEV': 'DEV',
    'DATA': 'DATA',
    'HYBRID': 'HYBRID',
    'REMOTE': 'REMOTE',
    'ON-SITE': 'ON-SITE',
  };

  @override
  void initState() {
    super.initState();
    _filteredInternships = _allInternships; // Initialize with all data
    _searchController.addListener(_filter); // Listen to search bar changes
  }

  /// [COMPONENT: FILTER LOGIC]
  /// Combines text search and category selection to update the UI.
  void _filter() {
  final query = _searchController.text.toLowerCase();
  setState(() {
    _filteredInternships = _allInternships.where((item) {
      final categoryMatches =
          _selectedCategory == 'All' ||
          item.category == _selectedCategory || // DESIGN, DEV, DATA
          item.type == _selectedCategory;        // REMOTE, ON-SITE, HYBRID

      final searchMatches =
          item.role.toLowerCase().contains(query) ||
          item.company.toLowerCase().contains(query);

      return categoryMatches && searchMatches;
    }).toList();
  });
}

Color _gettypeColor(String difficulty) {
    switch (difficulty.toUpperCase()) {
      case 'REMOTE':
        return const Color(0xFFE2FFDD);
      case 'ON-SITE':
        return const Color(0xFFF9E79F);
      case 'HYBRID':
        return const Color(0xFFFFD4D4);
      default:
        return const Color(0xFFE2FFDD);
    }
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
                    // Expands/Collapses the category list
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: _showCategories ? _buildCategorySelector() : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    // Maps the filtered list into individual Internship Cards
                    ..._filteredInternships.map((data) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InternshipDetailsPage(
                              lessonData: LessonCardData(
                                lessonTitle: data.role,
                                instructor: data.company,
                                level: data.category,
                                price: data.stipend,
                                totalDuration: data.duration,
                                cardColor: data.cardColor,
                                textColor: data.textColor,
                              ),
                            ),
                          ),
                        );
                      },
                      child: _buildInternshipCard(data),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// [COMPONENT: HEADER]
  /// Large bold typography for branding.
  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EXPLORE OPEN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text('INTERNSHIPS 💼', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  /// [COMPONENT: SEARCH BAR]
  /// Custom styled container with a text field and filter toggle button.
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
                        hintText: 'SEARCH ROLES...',
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
              height: 56, width: 56,
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

  /// [COMPONENT: CATEGORY SELECTOR]
  /// Row of chips that filter the list by industry/type.
  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categoryMap.entries.map((entry) {
          final isActive = _selectedCategory == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              side: const BorderSide(width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              label: Text(entry.value),
              onPressed: () {
                setState(() => _selectedCategory = entry.key);
                _filter();
              },
              backgroundColor: isActive ? Colors.black : Colors.white,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// [COMPONENT: INTERNSHIP CARD]
  /// The main visual element. Uses BoxShadow offset to create a 3D effect.
  Widget _buildInternshipCard(Internship data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
              // Company Icon Container
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: data.cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: Icon(data.iconData, color: data.textColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.role.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    Text(data.company, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(Icons.location_on_outlined, data.location),
                      _infoRow(Icons.payments_outlined, data.stipend),
                      _infoRow(Icons.timer_outlined, data.duration),
                        
                    ],
                  ),
                  SizedBox(width: 20,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                                              padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                          color: _gettypeColor(data.type),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                                              ),
                                              child: Text(
                          data.type.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                                              ),
                                            ),
                        ],
                      ),
                      
                ],
              ),
              // Forward Arrow CTA
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: data.cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(Icons.arrow_forward, color: data.textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// [HELPER: INFO ROW]
  /// Small reusable row for displaying icon + text pairs.
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}