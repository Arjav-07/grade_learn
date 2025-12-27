import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_learn/models/workshop_model.dart';
import 'package:grade_learn/screens/work_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Added for live data

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({super.key});

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _showCategories = false;
  final List<WorkshopData> _allWorkshops = [];
  List<WorkshopData> _filteredWorkshops = [];

  final Map<String, String> _categoryMap = {
    'All': 'ALL',
    'LIVE': 'LIVE',
    'UPCOMING': 'UPCOMING',
    'COMPLETED': 'COMPLETED',
  };

  @override
  void initState() {
    super.initState();
    _loadWorkshopData(); 
    _searchController.addListener(_filter);
  }

  Future<void> _loadWorkshopData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/workshops.json');
      final Map<String, dynamic> data = json.decode(response);
      
      setState(() {
        _allWorkshops.clear();
        final List<dynamic> workshopJsonList = data['workshops'] as List;

        _allWorkshops.addAll(
          workshopJsonList.map((item) {
            final String docId = item['course_id'] ?? ''; 
            return WorkshopData.fromJson(item, docId);
          }).toList(),
        );
        _filter(); 
      });
    } catch (e) {
      debugPrint("CRITICAL ERROR: $e");
    }
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      _filteredWorkshops = _allWorkshops.where((w) {
        final workshopDate = DateTime.tryParse(w.date) ?? today;
        final bool isExpired = workshopDate.isBefore(today);
        String effectiveStatus = isExpired ? 'COMPLETED' : w.type;

        final categoryMatch = _selectedCategory == 'All' || effectiveStatus == _selectedCategory;
        final searchMatch = w.title.toLowerCase().contains(query) ||
            w.instructor.toLowerCase().contains(query);
            
        return categoryMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      body: SafeArea(
        child: _allWorkshops.isEmpty 
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildBackButton(),
                  const SizedBox(height: 20),
                  const Text("WELCOME TO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text("WORKSHOPS 📝", style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, height: 1.1)),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: _showCategories ? Padding(padding: const EdgeInsets.only(top: 20), child: _buildCategorySelector()) : const SizedBox(),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredWorkshops.length,
                      itemBuilder: (context, index) {
                        final workshop = _filteredWorkshops[index];

                        // ✅ Live Stream for Seats Only (matches document ID with course_id)
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('workshops')
                              .doc(workshop.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            int liveSeats = workshop.seatsLeft;

                            if (snapshot.hasData && snapshot.data!.exists) {
                              liveSeats = snapshot.data!.get('seatsLeft') ?? workshop.seatsLeft;
                            }

                            return _buildWorkshopCard(context, workshop, liveSeats);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 28),
          SizedBox(width: 8),
          Text("BACK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(BuildContext context, WorkshopData data, int liveSeats) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final workshopDate = DateTime.tryParse(data.date) ?? today;
    
    final bool isExpired = workshopDate.isBefore(today);
    final bool isFull = liveSeats <= 0; // ✅ Uses Live Data

    String displayType = data.type;
    if (isExpired) {
      displayType = "COMPLETED";
    } else if (isFull) {
      displayType = "FULL";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(data),
          const SizedBox(height: 16),
          _buildStatusBar(isExpired, isFull, liveSeats), // ✅ Uses Live Data
          const SizedBox(height: 12),
          _buildCardFooter(context, data, displayType, isExpired, liveSeats), // ✅ Uses Live Data
        ],
      ),
    );
  }

  Widget _buildCardHeader(WorkshopData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: data.brandColor.withOpacity(0.2),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Icon(Icons.code, size: 20, color: data.brandColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, height: 1.1)),
              const SizedBox(height: 4),
              Text(data.instructor, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Column(
          children: [
            const Icon(Icons.timer_outlined, size: 20),
            Text(data.duration, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar(bool isExpired, bool isFull, int seats) {
    return Padding(
      padding: const EdgeInsets.only(right: 80.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
        ),
        alignment: Alignment.center,
        child: Text(
          isExpired ? "REGISTRATION CLOSED" : (isFull ? "WORKSHOP FULL" : "ONLY $seats SEATS LEFT!"),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCardFooter(BuildContext context, WorkshopData data, String displayType, bool isExpired, int liveSeats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _badge(displayType, color: _typeColor(displayType)),
            const SizedBox(width: 6),
            _badge(data.date),
            if (!isExpired) ...[
              const SizedBox(width: 6),
              _badge("$liveSeats SEATS"), // ✅ Live Badge
            ]
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => WorkshopDetailsPage(data: data)));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case "LIVE": return const Color(0xFFFFB5B5);
      case "UPCOMING": return const Color(0xFFB6F3C1);
      case "FULL": return const Color(0xFFB5D8FF);
      case "COMPLETED": return const Color(0xFFE0E0E0);
      default: return Colors.white;
    }
  }

  Widget _badge(String text, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20),
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
                    decoration: const InputDecoration(border: InputBorder.none, hintText: "SEARCH WORKSHOPS..."),
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
            height: 60, width: 60,
            decoration: BoxDecoration(
              color: _showCategories ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2.5),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
            ),
            child: Icon(_showCategories ? Icons.close : Icons.tune, color: _showCategories ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categoryMap.entries.map((e) {
          final isActive = _selectedCategory == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              label: Text(e.value),
              backgroundColor: isActive ? Colors.black : Colors.white,
              labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.w900),
              side: const BorderSide(width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              onPressed: () {
                setState(() => _selectedCategory = e.key);
                _filter();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}