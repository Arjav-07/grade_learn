import 'package:flutter/material.dart';

class InternshipDetailsPage extends StatelessWidget {
  const InternshipDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // New theme color for the status bar area
    const Color themeColor = Color(0xFFD1E5F8);

    return Container(
      color: themeColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _buildBottomBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildDescription(),
                const SizedBox(height: 24),
                // Replaced Lessons List with Internship Info Sections
                _buildInternshipInfoSections(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    const Color themeColor = Color(0xFFD1E5F8);
    
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 20),
          _buildInternshipIcon(),
          const SizedBox(height: 16),
          _buildInternshipTypeChip(),
          const SizedBox(height: 8),
          _buildInternshipTitle(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Content updated for an internship
  Widget _buildStatsSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatCard(
            icon: Icons.calendar_today_outlined,
            value: '3 Months',
            label: 'Duration',
            color: Color(0xFFD1E5F8),
            iconColor: Color(0xFF1E5B89),
          ),
          SizedBox(width: 16),
          StatCard(
            icon: Icons.currency_rupee,
            value: '25k /mo',
            label: 'Stipend',
            color: Color(0xFFE8F5E9),
            iconColor: Color(0xFF2E7D32),
          ),
          SizedBox(width: 16),
          StatCard(
            icon: Icons.people_alt_outlined,
            value: '1.2k+',
            label: 'Applicants',
            color: Color(0xFFFFF3E0),
            iconColor: Color(0xFFE65100),
          ),
        ],
      ),
    );
  }

  // New sections for internship details
  Widget _buildInternshipInfoSections() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _InfoSection(
            title: 'About the Internship',
            content: [
              'Work with our senior developers to build and maintain our flagship Flutter application.',
              'Participate in the entire application lifecycle, focusing on coding and debugging.',
              'Collaborate with cross-functional teams to define, design, and ship new features.',
            ],
          ),
          SizedBox(height: 20),
          _InfoSection(
            title: 'Skills Required',
            content: [
              'Proficiency in Dart and the Flutter framework.',
              'Understanding of state management solutions like Provider or BLoC.',
              'Experience with RESTful APIs and JSON.',
              'Familiarity with Git for version control.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            'Internship Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black87),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // Icon changed to one relevant for a job/internship
  Widget _buildInternshipIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(
        Icons.business_center_outlined,
        color: Color(0xFF1E5B89),
        size: 40,
      ),
    );
  }

  Widget _buildInternshipTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E5B89),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Text(
        'Full-time',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInternshipTitle() {
    return const Text(
      'Flutter Developer Intern\nat Google',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        height: 1.3,
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        'This is an exciting opportunity for a student or recent graduate passionate about mobile development to gain hands-on experience.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }

  // Bottom bar button changed to "Apply Now"
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.bookmark_border,
                size: 28, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Apply Now'),
            ),
          ),
        ],
      ),
    );
  }
}

// The StatCard widget is reused from your original code
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A new reusable widget for displaying sections like "About" and "Skills"
class _InfoSection extends StatelessWidget {
  final String title;
  final List<String> content;

  const _InfoSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        // Create a bulleted list from the content
        ...content.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 16, color: Colors.black54)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}