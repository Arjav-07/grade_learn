import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_learn/models/Intenship.dart';
import 'package:grade_learn/screens/internship_detail_page.dart';

class InternshipPage extends StatefulWidget {
  const InternshipPage({super.key});

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

class _InternshipPageState extends State<InternshipPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _showCategories = false;
  
  List<Internship> _allInternships = [];
  List<Internship> _filteredInternships = [];

  final Map<String, String> _categoryMap = {
    'All': 'ALL',
    'DESIGN': 'DESIGN',
    'DEV': 'DEV',
    'DATA': 'DATA',
    'REMOTE': 'REMOTE',
    'ON-SITE': 'ON-SITE',
  };

  @override
  void initState() {
    super.initState();
    _loadInternshipData();
    _searchController.addListener(_filter);
  }

  // REPLACE YOUR OLD METHOD WITH THIS ONE
  Future<void> _loadInternshipData() async {
    try {
      debugPrint("DEBUG: Starting to load JSON...");
      
      // 1. Try to load the file
      final String response = await rootBundle.loadString('assets/data/internships.json');
      debugPrint("DEBUG: JSON String loaded successfully");

      // 2. Try to decode it
      final data = await json.decode(response);
      debugPrint("DEBUG: JSON Decoded. Found ${data['internships'].length} items");

      // 3. Try to map to objects
      final List<Internship> loadedList = (data['internships'] as List)
          .map((i) => Internship.fromJson(i))
          .toList();

      setState(() {
        _allInternships = loadedList;
        _filteredInternships = _allInternships;
      });
      
      debugPrint("DEBUG: State updated successfully!");
    } catch (e) {
      // THIS WILL PRINT THE EXACT ERROR TO YOUR CONSOLE
      debugPrint("CRITICAL ERROR: $e");
      
      // This shows the error directly on your phone screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInternships = _allInternships.where((item) {
        final categoryMatches = _selectedCategory == 'All' ||
            item.category == _selectedCategory ||
            item.type == _selectedCategory;
        final searchMatches = item.role.toLowerCase().contains(query) ||
            item.company.toLowerCase().contains(query);
        return categoryMatches && searchMatches;
      }).toList();
    });
  }

  Color _gettypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'REMOTE': return const Color(0xFFE2FFDD);
      case 'ON-SITE': return const Color(0xFFF9E79F);
      case 'HYBRID': return const Color(0xFFFFD4D4);
      default: return const Color(0xFFE2FFDD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      // Setting top to false allows the background to hit the very top of the screen
      body: SafeArea(
        child: _allInternships.isEmpty 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align header to left
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          child: _showCategories ? _buildCategorySelector() : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 20),
                        ..._filteredInternships.map((data) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InternshipDetailsPage(internship: data)),
                          ),
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
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(hintText: 'SEARCH ROLES...', border: InputBorder.none),
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
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
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
              side: const BorderSide(width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              label: Text(entry.value),
              onPressed: () {
                setState(() => _selectedCategory = entry.key);
                _filter();
              },
              backgroundColor: isActive ? Colors.black : Colors.white,
              labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      ),
    );
  }

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
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: data.cardColor, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(Icons.location_on_outlined, data.location),
                      _infoRow(Icons.payments_outlined, data.stipend),
                      _infoRow(Icons.timer_outlined, data.duration),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _gettypeColor(data.type),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(data.type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: data.cardColor, shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 2),boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],),
                child: Icon(Icons.arrow_forward, color: data.textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

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




