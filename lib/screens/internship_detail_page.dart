import 'package:flutter/material.dart';
import 'package:grade_learn/models/Intenship.dart';

class InternshipDetailsPage extends StatelessWidget {
  final LessonCardData lessonData;
  const InternshipDetailsPage({super.key, required this.lessonData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      // --- STANDARD FLUTTER APP BAR ---
      appBar: AppBar(
        backgroundColor: lessonData.cardColor, // Matches the header color
        elevation: 0, // Removes the shadow for that flat look
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'DETAILS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
        // This adds the bold black line at the bottom of the normal app bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.black,
            height: 0.0,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Role Description'),
                  const SizedBox(height: 12),
                  _buildDescription(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Requirements'),
                  const SizedBox(height: 12),
                  _buildRequirements(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header section without the navigation row (since it's now in the AppBar)
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      decoration: BoxDecoration(
        color: lessonData.cardColor,
        border: const Border(bottom: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(lessonData.tagIcon ?? Icons.business, size: 40, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Text(
            lessonData.lessonTitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          Text(
            lessonData.instructor,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ... (Stats, Description, and Bottom Bar widgets remain the same as before)
  
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(Icons.payments, lessonData.price),
        const SizedBox(width: 12),
        _buildStatItem(Icons.timer, lessonData.totalDuration),
        const SizedBox(width: 12),
        _buildStatItem(Icons.bar_chart, lessonData.level),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 8),
            Text(text.split(' ').first, 
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title.toUpperCase(), 
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.2));
  }

  Widget _buildDescription() {
    return Text(
      "Join the team at ${lessonData.instructor} as a ${lessonData.lessonTitle}. This ${lessonData.level} position is for ${lessonData.totalDuration}.",
      style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildRequirements() {
    final requirements = ['Strong problem solving', 'Portfolio of projects', 'Communication skills'];
    return Column(
      children: requirements.map((req) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Icon(Icons.check_circle, size: 20),
            const SizedBox(width: 12),
            Text(req, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black, width: 2)),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('APPLY NOW', 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
      ),
    );
  }
}