import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/course.dart';

// --- Design Constants from your SkillPage Pattern ---
const Color kBrutalistBg = Color(0xFFFFFFF9);
const Color kBrutalistBlue = Color(0xFFB5D8FF);
const Color kBrutalistYellow = Color(0xFFFDE798);

class CoursesEnrolledPage extends StatefulWidget {
  const CoursesEnrolledPage({super.key});

  @override
  State<CoursesEnrolledPage> createState() => _CoursesEnrolledPageState();
}

class _CoursesEnrolledPageState extends State<CoursesEnrolledPage> {
  List<Course> _allCoursesFromJson = [];
  bool _isJsonLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJsonData(); // Load local details first
  }

  Future<void> _loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allCoursesFromJson = data.map((c) => Course.fromJson(c)).toList();
        _isJsonLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
      setState(() => _isJsonLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: kBrutalistBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildHeaderBtn(context),
            _buildTitleSection(),
            const SizedBox(height: 10),
            Expanded(
              child: _isJsonLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : StreamBuilder<QuerySnapshot>(
                // FIXED: Reading from your verified sub-collection path
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('enrolled_courses')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.black));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  final docs = snapshot.data!.docs;

                  return AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        // The course ID is the Document ID in your sub-collection
                        final String courseId = docs[index].id; 
                        
                        // Cross-reference Firestore ID with local JSON metadata
                        final Course courseDetails = _allCoursesFromJson.firstWhere(
                          (c) => c.id == courseId,
                          orElse: () => Course(
                            id: courseId, 
                            title: 'COURSE NOT FOUND', 
                            logoPath: '', 
                            providerName: 'UNKNOWN', 
                            difficulty: '', 
                            lessonsNo: '0', 
                            userCount: 0, 
                            timeDuration: '', 
                            about: '', 
                            category: '', 
                            instructorBio: '', 
                            instructorName: '', 
                            instructorimg: '', 
                            skills: [], backgroundColor: Color(0xFFFFFFFF), lessons: [], ratingsCount: 0, whatyoulearn: []
                          ), 
                        );

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _BrutalistEnrolledCard(course: courseDetails),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTitleSection() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('MY LEARNING', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        Text('ENROLLED📚', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
      ],
    ),
  );

  Widget _buildHeaderBtn(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.arrow_back, size: 28, color: Colors.black),
        SizedBox(width: 8),
        Text("BACK", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      ]),
    ),
  );

  Widget _buildEmptyState() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.auto_stories, size: 80, color: Colors.black26),
        SizedBox(height: 16),
        Text("NO ENROLLED COURSES YET", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
      ],
    ),
  );
}

class _BrutalistEnrolledCard extends StatelessWidget {
  final Course course;
  const _BrutalistEnrolledCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2),
        // HARD SHADOW Pattern matched from SkillPage
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(
              color: kBrutalistBlue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                course.logoPath, 
                fit: BoxFit.cover, 
                errorBuilder: (c,e,s) => const Icon(Icons.play_lesson, size: 28)
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.title.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                Text(
                  "${course.lessonsNo} LESSONS • ${course.timeDuration}", 
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 30, color: Colors.black),
        ],
      ),
    );
  }
}