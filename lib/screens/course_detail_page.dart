import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
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
      // PERSISTENT FETCH: Check if user document exists
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('enrolled_courses')
          .doc(course.id)
          .get();

      enrolled = doc.exists;

      // LOAD STATIC PROGRESS: Fetch the array of finished lesson indices
      if (enrolled && doc.data() != null && doc.data()!.containsKey('completed_lessons')) {
        completedIndices = List<int>.from(doc.data()!['completed_lessons']);
      }
    }

    state = CourseState(
      isEnrolled: enrolled,
      lessons: course.lessons.asMap().entries.map((entry) {
        return Lesson(
          title: entry.value['title'] ?? 'Untitled',
          duration: entry.value['duration'] ?? '00:00',
          contentUrl: entry.value['url'] ?? '',
          isCompleted: completedIndices.contains(entry.key), // Restore static checkmarks
          type: entry.value['type'] == 'video' ? LessonType.video : LessonType.text,
        );
      }).toList(),
    );
  }

  Future<void> enrollUser(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final enrollmentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('enrolled_courses')
        .doc(courseId);

    final doc = await enrollmentRef.get();

    // PREVENT RE-ENROLLMENT: Check for existing document first
    if (!doc.exists) {
      await enrollmentRef.set({
        'enrolledAt': FieldValue.serverTimestamp(),
        'completed_lessons': [], // Initial static progress is empty
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

    // SAVE PROGRESS STATICALLY: Update the array in Firestore
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
class CourseDetailScreen extends ConsumerWidget {
  final Course course;
  const CourseDetailScreen({required this.course, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseProv);
    final notifier = ref.read(courseProv.notifier);

    if (state.lessons.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifier.init(course));
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    if (state.activeIndex != null) {
      return LessonViewer(
        lesson: state.lessons[state.activeIndex!],
        onClose: () => notifier.setActive(null),
        onComplete: () {
          notifier.toggleComplete(state.activeIndex!, course.id); // Fixed Persistence
          notifier.setActive(null);
        },
      );
    }

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
              Text("BACK", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: state.isEnrolled ? _buildDarkBottomBar(state, notifier, course.id) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(course),
            const SizedBox(height: 20),
            _buildInfoCard(course),
            const SizedBox(height: 20),
            _buildAboutSection(course),
            const SizedBox(height: 20),
            _buildSkillYouGainSection(course),
            const SizedBox(height: 20),
            _buildCourseIncludes(course),
            const SizedBox(height: 20),
            _buildwhatwillyoulearnSection(course),
            const SizedBox(height: 20),
            _buildinstructorsSection(course),
            const SizedBox(height: 60),






            
            if (!state.isEnrolled)
              _buildEnrollButton(notifier, course.id)
            else ...[
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text("COURSE CONTENT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 16),
              ...state.lessons.asMap().entries.map(
                    (e) => _LessonTile(lesson: e.value, isLocked: false, onTap: () => notifier.setActive(e.key)),
                  ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeaderCard(Course course) {
    return _CustomCard(
      padding: EdgeInsets.zero,
      color: const Color(0xFFFDE798),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFB5C0FF),
                child: Icon(course.iconData ?? Icons.code, size: 40, color: Colors.black),
              ),
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
                _headerStat(Icons.access_time, course.timeDuration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Course course) {
    return _CustomCard(
      color: Colors.white,
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _infoField("LEVEL", course.difficulty, isBadge: true)),
              Expanded(child: _infoField("LESSONS", "${course.lessonsNo} LESSONS", icon: Icons.book)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          spacing: 12,
          runSpacing: 12,
          // Use course.skills from your updated model
          children: course.skills.map((skill) => _skillBadge(skill)).toList(),
        ),
      ),
    ],
  );
}

// Helper to create the badge UI
Widget _skillBadge(String label) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
  ),
  child: Text(
    label.toUpperCase(), 
    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)
  ),
);





Widget _buildCourseIncludes(Course course) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: _SectionHeader(title: "THE COURSE INCLUDES"),
      ),
      _CustomCard(
        color: const Color(0xFFB5C0FF),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Uses dynamic time duration and lesson counts from the model
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
    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: "WHAT YOU WILL LEARN"),
          ...course.skills.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.black, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(skill, style: const TextStyle(fontSize: 16))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildinstructorsSection(Course course) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: const _SectionHeader(title: "YOUR INSTRUCTORS"),
        ),
        _CustomCard(
        
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0,right: 12.0, top: 12.0,),
                        child: Row(children: [
                          CircleAvatar(radius: 25, backgroundImage: AssetImage(course.instructorimg)),
                          const SizedBox(width: 15),
                          Row(
                            children: [
                              Text(course.instructorName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                            ],
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
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
      onTap: () => notifier.enrollUser(courseId),
      child: const _CustomCard(
        color: Colors.black,
        padding: EdgeInsets.zero,
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
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CONTINUE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                  Text("NEXT LECTURE...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDE798),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                int next = state.lessons.indexWhere((l) => !l.isCompleted);
                notifier.setActive(next != -1 ? next : 0);
              },
              child: const Text("RESUME", style: TextStyle(fontWeight: FontWeight.w900)),
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
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)));
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const _CustomCard({required this.child, required this.color, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
        ),
        child: ListTile(
          onTap: isLocked ? null : onTap,
          leading: Icon(lesson.type == LessonType.video ? Icons.play_circle : Icons.description, color: Colors.black),
          title: Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          subtitle: Text(lesson.duration, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          trailing: Icon(lesson.isCompleted ? Icons.check_circle : (isLocked ? Icons.lock : Icons.chevron_right), color: Colors.black),
        ),
      );
}