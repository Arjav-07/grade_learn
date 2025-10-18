// --- New Detailed Internship Page ---

// A placeholder for a real company logo asset
import 'package:flutter/material.dart';

const String companyLogoUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/G-logo.svg/2048px-G-logo.svg.png';

class InternshipDetailSliverPage extends StatelessWidget {
  const InternshipDetailSliverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      // Use bottomNavigationBar for a clean, persistent button at the bottom
      bottomNavigationBar: _buildApplyButton(context),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          // The rest of the page content goes into this sliver
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection("About the Internship",
                    "Join our dynamic team as a Flutter Developer Intern and contribute to building beautiful, high-performance mobile applications. This is a hands-on role where you will work closely with our senior developers and designers to translate ideas into reality."),
                _buildResponsibilitiesSection(),
                _buildSkillsSection(),
                _buildPerksAndBenefitsSection(),
                const SizedBox(height: 20), // Extra padding at the bottom
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Builds the new collapsing AppBar.
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF6A5AE0),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.2),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // In a real app, use Navigator.pop(context)
            },
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0).copyWith(top: 80), // Adjust padding for app bar
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A5AE0), Color(0xFF8879E8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Logo
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: NetworkImage(companyLogoUrl),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Flutter Developer Intern",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "at Google",
                              style: TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Internship metadata (Location, Duration, Stipend)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(Icons.location_on_outlined, "Remote"),
                      _buildInfoItem(Icons.timer_outlined, "3 Months"),
                      _buildInfoItem(Icons.currency_rupee, "25,000/month"),
                    ],
                  ),
                   const SizedBox(height: 10),
                ],
              ),
            ),
             // Decorative shape on the right
            Positioned(
              top: 30,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                transform: Matrix4.rotationZ(0.5),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper widget for metadata items in the header
  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  // Generic widget for building a content section
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for "Key Responsibilities" section
  Widget _buildResponsibilitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Key Responsibilities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          _buildListItem("Collaborate with the team to design and ship new features."),
          _buildListItem("Ensure the performance, quality, and responsiveness of applications."),
          _buildListItem("Identify and correct bottlenecks and fix bugs."),
          _buildListItem("Help maintain code quality, organization, and automation."),
        ],
      ),
    );
  }

  // Widget for "Skills Required" section with chips
  Widget _buildSkillsSection() {
    final skills = ["Flutter", "Dart", "UI/UX", "Git", "Firebase", "REST APIs"];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Skills Required",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: skills
                .map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: const Color(0xFFEAEAF2),
                      labelStyle: const TextStyle(color: Color(0xFF6A5AE0)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Widget for "Perks & Benefits" section
  Widget _buildPerksAndBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Perks & Benefits",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          _buildListItem("Certificate of Internship"),
          _buildListItem("Letter of Recommendation"),
          _buildListItem("Flexible work hours"),
          _buildListItem("5 days a week"),
        ],
      ),
    );
  }

  // Helper for creating list items for responsibilities and perks
  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the floating "Apply Now" button at the bottom
  Widget _buildApplyButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: MediaQuery.of(context).padding.bottom + 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle Apply Now logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A5AE0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            "Apply Now",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

