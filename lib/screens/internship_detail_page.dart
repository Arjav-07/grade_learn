import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_learn/models/Intenship.dart';
// Ensure this path matches your actual file structure
import 'package:grade_learn/screens/application_from.dart'; 

class InternshipDetailsPage extends StatelessWidget {
  final Internship internship;
  const InternshipDetailsPage({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFF9),
        elevation: 0,
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.arrow_back, color: Colors.black, size: 28),
              SizedBox(width: 8),
              Text(
                "BACK",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER CARD ----------
            _CustomCard(
              color: internship.cardColor,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        internship.iconData,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    internship.role.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    internship.company.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- STATS ----------
            Row(
              children: [
                _buildStatItem(Icons.payments, internship.stipend, 'STIPEND'),
                const SizedBox(width: 12),
                _buildStatItem(Icons.timer, internship.duration, 'MONTHS'),
                const SizedBox(width: 12),
                _buildStatItem(
                  FontAwesomeIcons.briefcase,
                  internship.type,
                  'LEVEL',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------- DESCRIPTION ----------
            _CustomCard(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(title: "ROLE DESCRIPTION"),
                  Text(
                    internship.roledescription,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- SKILLS REQUIRED ----------
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: _SectionHeader(title: 'SKILLS REQUIRED'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: internship.skills.map((skill) => _skillBadge(skill)).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ---------- KEY RESPONSIBILITIES ----------
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: _SectionHeader(title: "KEY RESPONSIBILITIES"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFB5C0FF),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: internship.keyresponsibilities
                    .map((resp) => _includeRow(FontAwesomeIcons.briefcase, resp))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ---------- QUALIFICATIONS ----------
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: _SectionHeader(title: "QUALIFICATIONS"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFFDE798),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: internship.qualifications
                    .map((qual) => _includeRow(Icons.check_circle_outline, qual))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // --- ABOUT COMPANY ---
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: _SectionHeader(title: "ABOUT COMPANY"),
            ),
            const SizedBox(height: 12),
            _CustomCard(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.business, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              internship.companytitle,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                            Text(
                              internship.companysubtitle,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(internship.companyinfo, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // ---------- REQUIREMENTS ----------
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: _SectionHeader(title: 'APPLICATION PROCESS'),
            ),
            const SizedBox(height: 20),
            _numItem(1, 'APPLICATION REVIEW', internship.applicationreview),
            _numItem(2, 'ONLINE ASSESSMENT', internship.onlineassessment),
            _numItem(3, 'TECHNICAL INTERVIEW', internship.technicalinterview),
            _numItem(4, 'FINAL INTERVIEW', internship.finalinterview),
            _numItem(5, 'OFFER EXTENSION', internship.offerextension),
            
            const SizedBox(height: 20),

            // ---------- CONNECT ----------
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: _SectionHeader(title: "CONNECT WITH US"),
            ),
            const SizedBox(height: 8),
            _CustomCard(
              color: const Color(0xFFB5C0FF),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  _includeRow(Icons.mail_outline, internship.mail),
                  _includeRow(Icons.language, internship.website),
                  _includeRow(FontAwesomeIcons.linkedin, internship.linkedin),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // ---------- APPLY BUTTON ----------
            // ---------- DYNAMIC APPLY BUTTON ----------
StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('applications')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .where('itemId', isEqualTo: internship.id)
      .snapshots(),
  builder: (context, snapshot) {
    // Check if a document already exists for this user and this item
    bool alreadyApplied = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

    return GestureDetector(
      onTap: alreadyApplied
          ? null // Disable tap if already applied
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApplicationForm(
                    title: internship.role,
                    type: 'internship',
                    itemId: internship.id,
                  ),
                ),
              );
            },
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          // Change color to Grey if already applied to give visual feedback
          color: alreadyApplied ? Colors.grey[400] : Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: alreadyApplied 
              ? null // Remove shadow if disabled for a "pressed" look
              : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        alignment: Alignment.center,
        child: Text(
          alreadyApplied ? "ALREADY APPLIED" : "APPLY FOR INTERNSHIP",
          style: TextStyle(
            color: alreadyApplied ? Colors.black54 : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  },
),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------- HELPERS ----------
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(height: 6),
            Text(
              value.split(' ').first.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1));
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const _CustomCard({required this.child, required this.color, required this.padding});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        child: child,
      );
}

Widget _skillBadge(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
    );

Widget _includeRow(IconData icon, String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, height: 1.3),
            ),
          ),
        ],
      ),
    );

Widget _numItem(int n, String title, String desc) => Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black,
            child: Text('$n', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );