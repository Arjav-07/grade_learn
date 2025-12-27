import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart'; // Add this to pubspec.yaml
import 'package:flutter_riverpod/legacy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:grade_learn/screens/lesson_viewer.dart';
import '../models/course.dart';

// --- 1. MODELS & STATE ---
enum LessonType { video, text }

class Lesson {
  final String title, duration, contentUrl;
  final bool isCompleted;
  final LessonType type;

  Lesson({
    required this.title,
    required this.duration,
    required this.contentUrl,
    this.isCompleted = false,
    this.type = LessonType.text,
  });

  Lesson copyWith({bool? isCompleted}) => Lesson(
        title: title,
        duration: duration,
        contentUrl: contentUrl,
        type: type,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class CourseState {
  final List<Lesson> lessons;
  final int? activeIndex;
  final bool isEnrolled;

  CourseState({this.lessons = const [], this.activeIndex, this.isEnrolled = false});

  CourseState copyWith({List<Lesson>? lessons, int? activeIndex, bool? isEnrolled, bool clearActive = false}) =>
      CourseState(
        lessons: lessons ?? this.lessons,
        isEnrolled: isEnrolled ?? this.isEnrolled,
        activeIndex: clearActive ? null : (activeIndex ?? this.activeIndex),
      );
}

// --- 2. PROVIDER ---
final courseProv = StateNotifierProvider.autoDispose<CourseNotifier, CourseState>((ref) => CourseNotifier());

// --- 3. BUSINESS LOGIC (NOTIFIER) ---
class CourseNotifier extends StateNotifier<CourseState> {
  CourseNotifier() : super(CourseState());

  Future<void> init(Course course) async {
    final user = FirebaseAuth.instance.currentUser;
    bool enrolled = false;
    List<int> completedIndices = [];

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('enrolled_courses')
            .doc(course.id)
            .get();

        enrolled = doc.exists;
        if (enrolled && doc.data() != null && doc.data()!.containsKey('completed_lessons')) {
          completedIndices = List<int>.from(doc.data()!['completed_lessons']);
        }
      } catch (e) {
        debugPrint("Firestore Init Error: $e");
      }
    }

    state = CourseState(
      isEnrolled: enrolled,
      lessons: course.lessons.asMap().entries.map((entry) {
        return Lesson(
          title: entry.value['title'] ?? 'Untitled',
          duration: entry.value['duration'] ?? '00:00',
          contentUrl: entry.value['url'] ?? '',
          isCompleted: completedIndices.contains(entry.key),
          type: entry.value['type'] == 'video' ? LessonType.video : LessonType.text,
        );
      }).toList(),
    );
  }

  Future<void> enrollUser(String courseId, String courseTitle) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final enrollmentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('enrolled_courses')
        .doc(courseId);

    final doc = await enrollmentRef.get();

    if (!doc.exists) {
      // ✅ Store Title & Unique Issue Number
      String certNo = "GL-${user.uid.substring(0, 5)}-${courseId.toUpperCase()}";
      
      await enrollmentRef.set({
        'enrolledAt': FieldValue.serverTimestamp(),
        'courseTitle': courseTitle,
        'certificateNo': certNo,
        'completed_lessons': [],
      });
    }
    state = state.copyWith(isEnrolled: true);
  }

  void toggleComplete(int i, String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newList = [...state.lessons];
    newList[i] = newList[i].copyWith(isCompleted: !newList[i].isCompleted);
    state = state.copyWith(lessons: newList);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('enrolled_courses')
        .doc(courseId)
        .update({
      'completed_lessons': state.lessons
          .asMap()
          .entries
          .where((e) => e.value.isCompleted)
          .map((e) => e.key)
          .toList(),
    });
  }

  void setActive(int? i) => state = i == null ? state.copyWith(clearActive: true) : state.copyWith(activeIndex: i);
}

// --- 4. MAIN DETAIL SCREEN ---
class CourseDetailScreen extends ConsumerStatefulWidget {
  final Course course;
  const CourseDetailScreen({required this.course, super.key});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    Future.microtask(() => ref.read(courseProv.notifier).init(widget.course));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // ✅ BRANDED CERTIFICATE GENERATION
  Future<void> _generateCourseCertificate(String title, String? issueNo) async {
    final pdf = pw.Document();
    final user = FirebaseAuth.instance.currentUser;
    final String name = user?.displayName ?? "STUDENT";

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Container(
            color: PdfColor.fromInt(0xFFFFFFF9),
            child: pw.Container(
              margin: const pw.EdgeInsets.all(40),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 6),
                boxShadow: [const pw.BoxShadow(color: PdfColors.black, offset: PdfPoint(8, -8))],
              ),
              child: pw.Stack(
                children: [
                  pw.Positioned(
                    top: 0, right: 0,
                    child: pw.Container(width: 150, height: 150, color: PdfColor.fromInt(0xFFFDE798)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(40),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("CERTIFICATE OF COMPLETION", 
                          style: pw.TextStyle(fontSize: 34, fontWeight: pw.FontWeight.bold, letterSpacing: 2)),
                        pw.Container(height: 4, color: PdfColors.black, width: 100, margin: const pw.EdgeInsets.symmetric(vertical: 20)),
                        pw.Text("THIS IS TO CERTIFY THAT", style: const pw.TextStyle(fontSize: 16)),
                        pw.SizedBox(height: 15),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromInt(0xFFB5C0FF),
                            border: pw.Border.all(color: PdfColors.black, width: 3),
                          ),
                          child: pw.Text(name.toUpperCase(), style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text("HAS SUCCESSFULLY COMPLETED THE COURSE", style: const pw.TextStyle(fontSize: 14)),
                        pw.Text(title.toUpperCase(), style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                        pw.Spacer(),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("GRADE LEARN ACADEMY", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.Text("ISSUE NO: ${issueNo ?? 'PENDING'}"),
                              ]
                            ),
                            pw.Text("DATE: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseProv);
    final notifier = ref.read(courseProv.notifier);

    final bool allCompleted = state.lessons.isNotEmpty && state.lessons.every((l) => l.isCompleted);

    if (state.lessons.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    if (state.activeIndex != null) {
      return LessonViewer(
        lesson: state.lessons[state.activeIndex!],
        onClose: () => notifier.setActive(null),
        onComplete: () {
          notifier.toggleComplete(state.activeIndex!, widget.course.id);
          notifier.setActive(null);
          // Play celebration if final lesson finished
          if (ref.read(courseProv).lessons.every((l) => l.isCompleted)) {
            _confettiController.play();
          }
        },
      );
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
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
                  Text("BACK", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          bottomNavigationBar: state.isEnrolled ? _buildDarkBottomBar(state, notifier, widget.course.id) : null,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(widget.course, state),
                const SizedBox(height: 20),
                if (state.isEnrolled && allCompleted) _buildCertificateButton(widget.course),
                _buildInfoCard(widget.course),
                const SizedBox(height: 20),
                _buildAboutSection(widget.course),
                const SizedBox(height: 20),
                _buildSkillYouGainSection(widget.course),
                const SizedBox(height: 20),
                _buildCourseIncludes(widget.course),
                const SizedBox(height: 20),
                _buildwhatwillyoulearnSection(widget.course),
                const SizedBox(height: 20),
                _buildinstructorsSection(widget.course),
                const SizedBox(height: 60),
                if (!state.isEnrolled)
                  _buildEnrollButton(notifier, widget.course.id)
                else ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 16),
                    child: Text("COURSE CONTENT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                  ...state.lessons.asMap().entries.map(
                    (e) => _LessonTile(lesson: e.value, isLocked: false, onTap: () => notifier.setActive(e.key)),
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Color(0xFFFDE798), Color(0xFFB5C0FF), Color(0xFF3CE5C4), Colors.black],
        ),
      ],
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildCertificateButton(Course course) {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('enrolled_courses')
        .doc(course.id)
        .get(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const SizedBox.shrink(); 
      }

      // ✅ FIX: Access data as a Map to prevent StateError
      final docData = snapshot.data!.data() as Map<String, dynamic>?;
      final String? issueNo = (docData != null && docData.containsKey('certificateNo')) 
          ? docData['certificateNo'] 
          : "PENDING"; 

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          onTap: () => _generateCourseCertificate(course.title, issueNo),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3CE5C4),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 2.5),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.workspace_premium, color: Colors.black),
                SizedBox(width: 10),
                Text("CLAIM YOUR CERTIFICATE", 
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }
  );
}

  Widget _buildHeaderCard(Course course, CourseState state) {
    int completedCount = state.lessons.where((l) => l.isCompleted).length;
    double progress = state.lessons.isEmpty ? 0 : completedCount / state.lessons.length;

    return _CustomCard(
      padding: EdgeInsets.zero,
      color: const Color(0xFFFDE798),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100, height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                width: 70, height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    course.logoPath, 
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.business, size: 30),
                  ),
                ),
              ),
              ],
            ),
            const SizedBox(height: 15),
            Text(course.title.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            Text("BY ${course.providerName.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _headerStat(Icons.star, "${course.ratingsCount}"),
                _headerStat(Icons.person, "${(course.userCount / 1000).toStringAsFixed(0)}K"),
                _headerStat(Icons.check_circle, "${(progress * 100).toInt()}%"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... (Include your original _buildInfoCard, _buildAboutSection, _buildSkillYouGainSection, _buildCourseIncludes, _buildwhatwillyoulearnSection, _buildinstructorsSection)

  Widget _buildInfoCard(Course course) {
    return _CustomCard(
      color: Colors.white,
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _infoField("LEVEL", course.difficulty, isBadge: true)),
              Expanded(child: _infoField("LESSONS", "${course.lessonsNo} LESSONS", icon: Icons.book)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _infoField("CATEGORIES", course.category.split(' ').first)),
              Expanded(child: _infoField("DURATIONS", course.timeDuration, icon: Icons.schedule)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Course course) {
    return _CustomCard(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: "ABOUT COURSE"),
          Text(course.about, style: const TextStyle(fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildSkillYouGainSection(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'SKILLS YOU WILL GAIN'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Wrap(
            spacing: 12, runSpacing: 12,
            children: course.skills.map((skill) => _skillBadge(skill)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _skillBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
    ),
    child: Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
  );

  Widget _buildCourseIncludes(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "THE COURSE INCLUDES"),
        _CustomCard(
          color: const Color(0xFFB5C0FF),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _includeRow(Icons.videocam, "${course.timeDuration} OF VIDEO LECTURES"),
              _includeRow(Icons.article, "${course.lessonsNo} ARTICLES & RESOURCES"),
              _includeRow(Icons.all_inclusive, "FULL LIFETIME ACCESS"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _includeRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildwhatwillyoulearnSection(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "WHAT YOU WILL LEARN"),
        ...course.skills.map((skill) => Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 10),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.black, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(skill, style: const TextStyle(fontSize: 16))),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildinstructorsSection(Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "YOUR INSTRUCTORS"),
        _CustomCard(
          color: Colors.white, padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(children: [
                  CircleAvatar(radius: 25, backgroundImage: AssetImage(course.instructorimg)),
                  const SizedBox(width: 15),
                  Text(course.instructorName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Text(course.instructorBio, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnrollButton(CourseNotifier notifier, String courseId) {
    return InkWell(
      onTap: () => notifier.enrollUser(courseId, widget.course.title),
      child: const _CustomCard(
        color: Colors.black, padding: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("ENROLL NOW", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2))),
        ),
      ),
    );
  }

  Widget _buildDarkBottomBar(CourseState state, CourseNotifier notifier, String courseId) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Expanded(child: Text("KEEP GOING!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDE798), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                int next = state.lessons.indexWhere((l) => !l.isCompleted);
                notifier.setActive(next != -1 ? next : 0);
              },
              child: const Text("RESUME", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerStat(IconData i, String v) => Row(children: [Icon(i, size: 18), const SizedBox(width: 4), Text(v, style: const TextStyle(fontWeight: FontWeight.w900))]);

  Widget _infoField(String label, String value, {bool isBadge = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 6),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFD4FFD4), borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.black, width: 2)),
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          )
        else
          Row(children: [if (icon != null) Icon(icon, size: 20), const SizedBox(width: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18))]),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12, left: 10), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)));
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const _CustomCard({required this.child, required this.color, required this.padding});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: padding,
    decoration: BoxDecoration(
      color: color, borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
    ),
    child: child,
  );
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final bool isLocked;
  final VoidCallback onTap;
  const _LessonTile({required this.lesson, required this.isLocked, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
    ),
    child: ListTile(
      onTap: isLocked ? null : onTap,
      leading: Icon(lesson.type == LessonType.video ? Icons.play_circle : Icons.description, color: Colors.black),
      title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      trailing: Icon(lesson.isCompleted ? Icons.check_circle : (isLocked ? Icons.lock : Icons.chevron_right), color: Colors.black),
    ),
  );
}