import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Data Model for a Job Card ---
class JobCardData {
  final String jobTitle;
  final String company;
  final String location;
  final String salary;
  final String duration;
  final String? tagText;
  final IconData? tagIcon;
  final Color cardColor;
  final Color textColor;

  JobCardData({
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.duration,
    this.tagText,
    this.tagIcon,
    required this.cardColor,
    required this.textColor,
  });
}

// --- Color Palette from the Course Theme ---
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
  
  // Master list of all jobs
  final List<JobCardData> _allJobs = [
    JobCardData(
      tagText: 'Internship',
      tagIcon: Icons.hourglass_bottom_outlined,
      jobTitle: 'UX Designer',
      company: 'Figma',
      location: 'Bangalore, India',
      salary: '₹ 80,000 - 1,20,000 /month',
      duration: '4 Months',
      cardColor: const Color(0xFFF9BE84), // Light peach
      textColor: const Color(0xFF86542A), // Dark orange text
    ),
    JobCardData(
      tagText: 'Actively hiring',
      tagIcon: Icons.trending_up,
      jobTitle: 'Graphic Design',
      company: 'Idea Usher',
      location: 'Work From Home',
      salary: '₹ 12,000 - 1,50,000 /month',
      duration: '6 Months',
      cardColor: const Color(0xFFE4D9FF), // Light purple
      textColor: const Color(0xFF65499D), // Dark purple text
    ),
    JobCardData(
      tagText: 'Full-Time',
      tagIcon: Icons.business_center_outlined,
      jobTitle: 'Flutter Developer',
      company: 'Skill Waves',
      location: 'Remote (India)',
      salary: '₹ 40,000 - 90,000 /month',
      duration: 'Permanent',
      cardColor: kDarkPill, // Dark grey
      textColor: Colors.white, // White text
    ),
    
  ];
  
  // --- State Variables for Filtering ---
  List<JobCardData> _filteredJobs = [];
  String _selectedCategory = 'All';
  bool _showCategories = false;
  
  // Map category keys to display names and icons
  final Map<String, String> _categoryMap = {
    'All': 'All',
    'Actively hiring': 'Hiring',
    'Full-Time': 'Full-Time',
    'Internship': 'Internship',
  };
  
  final Map<String, IconData> _iconMap = {
    'All': Icons.apps,
    'Hiring': Icons.trending_up,
    'Full-Time': Icons.business_center,
    'Internship': Icons.school,
  };


  @override
  void initState() {
    super.initState();
    _filteredJobs = _allJobs;
    _searchController.addListener(_filterJobs);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterJobs);
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIC FOR COMBINED SEARCH AND CATEGORY FILTERING ---
  void _filterJobs() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        // Check if the job matches the selected category (or if 'All' is selected)
        final categoryMatches = _selectedCategory == 'All' || job.tagText == _selectedCategory;
        
        // Check if the job title or company matches the search query
        final searchMatches = searchQuery.isEmpty ||
            job.jobTitle.toLowerCase().contains(searchQuery) ||
            job.company.toLowerCase().contains(searchQuery);
            
        return categoryMatches && searchMatches;
      }).toList();
    });
  }

  void _onCategorySelected(String categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
    });
    // Re-run the filter logic when a new category is selected
    _filterJobs(); 
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
              _buildInternshipContent(),
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
          Positioned(
            top: -40,
            right: -20,
            child: SizedBox( // Use SizedBox to control the image size
              height: 180, // Adjust height as needed
              // Replace the Icon with Image.asset
              child: Image.asset(
                'assets/images/internship.png', // <--- Your image asset path here
                fit: BoxFit.contain, // Adjust fit as needed
                // REMOVED: color: Colors.black.withOpacity(0.08), 
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
                'Find your \ninternship',
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatPill('72% Profile', const Color(0xFF2C2C2C)),
                  const SizedBox(width: 10),
                  _buildStatPill('12 Applied', Colors.white.withOpacity(0.2)),
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

  // The main content area below the header
  Widget _buildInternshipContent() {
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
              child: _showCategories ? _buildCategorySelector() : const SizedBox.shrink(),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader(context, 'Recommended for you'),
            const SizedBox(height: 16),
            // Build job cards from the filtered list
            _buildJobList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // Widget to display the list of job cards
  Widget _buildJobList() {
    if (_filteredJobs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Text(
            'No matching jobs found.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredJobs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final job = _filteredJobs[index];
        return _buildJobCard(
          jobTitle: job.jobTitle,
          company: job.company,
          location: job.location,
          salary: job.salary,
          duration: job.duration,
          tagText: job.tagText,
          tagIcon: job.tagIcon,
          cardColor: job.cardColor,
          textColor: job.textColor,
        );
      },
    );
  }

  // --- Reusable Themed Widgets ---

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
                hintText: 'Search for jobs...',
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
        backgroundColor: isActive ? const Color(0xFF2C2C2C) : const Color(0xFFF3F3F3),
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

  Widget _buildJobCard({
    required String jobTitle,
    required String company,
    required String location,
    required String salary,
    required String duration,
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
            jobTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            company,
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
                    _buildDetailRow(Icons.location_on_outlined, location, textColor),
                    _buildDetailRow(Icons.currency_rupee_rounded, salary, textColor),
                    _buildDetailRow(Icons.calendar_today_outlined, duration, textColor),
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