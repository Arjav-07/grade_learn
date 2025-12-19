import 'package:flutter/material.dart';
import 'package:grade_learn/models/workshop_model.dart';
import 'package:grade_learn/screens/work_detail_page.dart';

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({super.key});

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _showCategories = false;

  final List<WorkshopData> _allWorkshops = [
    WorkshopData(
      title: "BUILD FULL STACK APP WITH MERN STACK",
      instructor: "SARAH MITCHELL",
      duration: "3HR",
      seatsLeft: 0, // Testing "FULL" state
      totalSeats: 60,
      date: "12-01-2026",
      brandColor: Colors.red,
      type: "FULL",
    ),
    WorkshopData(
      title: "PYTHON DATA SCIENCE BOOTCAMP",
      instructor: "DR. JAMES CHEN",
      duration: "4.5HR",
      seatsLeft: 12,
      totalSeats: 60,
      date: "12-01-2026",
      brandColor: Colors.blue,
      type: "LIVE",
    ),
  ];

  List<WorkshopData> _filteredWorkshops = [];

  final Map<String, String> _categoryMap = {
    'All': 'ALL',
    'LIVE': 'LIVE',
    'UPCOMING': 'UPCOMING',
    'FULL': 'FULL',
  };

  @override
  void initState() {
    super.initState();
    _filteredWorkshops = _allWorkshops;
    _searchController.addListener(_filter);
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWorkshops = _allWorkshops.where((w) {
        final categoryMatch =
            _selectedCategory == 'All' || w.type == _selectedCategory;
        final searchMatch =
            w.title.toLowerCase().contains(query) ||
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // BACK BUTTON
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "BACK",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "WELCOME TO",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "WORKSHOPS 📝",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 24),
              _buildSearchBar(),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: _showCategories
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _buildCategorySelector(),
                      )
                    : const SizedBox(),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredWorkshops.length,
                  itemBuilder: (context, index) =>
                      _buildWorkshopCard(context, _filteredWorkshops[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    hintText: "SEARCH WORKSHOPS...",
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
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: _showCategories ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: Icon(
              _showCategories ? Icons.close : Icons.tune,
              color: _showCategories ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- CATEGORY CHIPS ----------------
  Widget _buildCategorySelector() {
    return Row(
      children: _categoryMap.entries.map((e) {
        final isActive = _selectedCategory == e.key;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ActionChip(
            label: Text(e.value),
            backgroundColor: isActive ? Colors.black : Colors.white,
            labelStyle: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w900,
            ),
            side: const BorderSide(width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            onPressed: () {
              setState(() => _selectedCategory = e.key);
              _filter();
            },
          ),
        );
      }).toList(),
    );
  }

  // ---------------- WORKSHOP CARD ----------------
  // ---------------- WORKSHOP CARD ----------------
  Widget _buildWorkshopCard(BuildContext context, WorkshopData data) {
    // Determine if we should show "0" seats based on your rules
    bool showNoSeats = data.type == "LIVE" || data.type == "FULL" || data.seatsLeft == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Always white (or your brand color)
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
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
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.instructor,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.timer_outlined),
                  Text(
                    data.duration,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // STATUS BAR
          Padding(
            padding: const EdgeInsets.only(right: 80.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black, // Keep it black for high contrast
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
              ),
              alignment: Alignment.center,
              child: Text(
                // Use the custom logic for seat text
                showNoSeats ? "WORKSHOP FULL" : "ONLY ${data.seatsLeft} SEATS LEFT!",
                style: const TextStyle(
                  fontWeight: FontWeight.w900, 
                  fontSize: 14, 
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // BADGES + ARROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _badge(data.type, color: _typeColor(data.type)),
                  const SizedBox(width: 6),
                  _badge(data.date),
                  const SizedBox(width: 6),
                  // Logic to show 0 seats if LIVE or FULL
                  _badge("${showNoSeats ? 0 : data.seatsLeft} SEATS"),
                ],
              ),
              GestureDetector(
                onTap: () { 
                  // Always accessible now
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkshopDetailsPage(data: data),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case "LIVE":
        return const Color(0xFFFFB5B5); // Red
      case "UPCOMING":
        return const Color(0xFFB6F3C1); // Green
      case "FULL":
        return const Color(0xFFB5D8FF); // Blue
      default:
        return Colors.white;
    }
  }

  Widget _badge(String text, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
    );
  }
}