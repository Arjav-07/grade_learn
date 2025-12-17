import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:grade_learn/screens/lesson_viewer.dart';

// -------------------------------------------------------------------
// 1. MODELS & STATE
// -------------------------------------------------------------------

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

  CourseState({
    this.lessons = const [],
    this.activeIndex,
    this.isEnrolled = false,
  });

  CourseState copyWith({
    List<Lesson>? lessons,
    int? activeIndex,
    bool? isEnrolled,
    bool clearActive = false,
  }) => CourseState(
    lessons: lessons ?? this.lessons,
    isEnrolled: isEnrolled ?? this.isEnrolled,
    activeIndex: clearActive ? null : (activeIndex ?? this.activeIndex),
  );
}

class CourseNotifier extends StateNotifier<CourseState> {
  CourseNotifier() : super(CourseState());

  void init() {
    if (state.lessons.isNotEmpty) return;
    state = CourseState(
      lessons: [
        Lesson(
          title: '01. INTRODUCTION TO JAVA',
          duration: '05:30',
          contentUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          type: LessonType.video,
        ),
        Lesson(
          title: '02. SETTING UP JDK',
          duration: '12:15',
          contentUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          type: LessonType.video,
        ),
        Lesson(
          title: '03. HELLO WORLD PROGRAM',
          duration: '10:00',
          contentUrl: 'doc_1',
          type: LessonType.text,
        ),
        Lesson(
          title: '04. VARIABLES & DATA TYPES',
          duration: '15:45',
          contentUrl: 'vid_3',
          type: LessonType.video,
        ),
      ],
    );
  }

  void enrollUser() => state = state.copyWith(isEnrolled: true);
  void toggleComplete(int i) {
    final newList = [...state.lessons];
    newList[i] = newList[i].copyWith(isCompleted: !newList[i].isCompleted);
    state = state.copyWith(lessons: newList);
  }

  void setActive(int? i) => state = i == null
      ? state.copyWith(clearActive: true)
      : state.copyWith(activeIndex: i);
}

final courseProv = StateNotifierProvider<CourseNotifier, CourseState>(
  (ref) => CourseNotifier(),
);

// -------------------------------------------------------------------
// 2. MAIN DETAIL SCREEN
// -------------------------------------------------------------------

class CourseDetailScreen extends ConsumerWidget {
  final dynamic course;
  const CourseDetailScreen({required this.course, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseProv);
    final notifier = ref.read(courseProv.notifier);

    if (state.lessons.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifier.init());
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.activeIndex != null) {
      return LessonViewer(
        lesson: state.lessons[state.activeIndex!],
        onClose: () => notifier.setActive(null),
        onComplete: () {
          notifier.toggleComplete(state.activeIndex!);
          notifier.setActive(null);
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFF9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFF9),
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
      bottomNavigationBar: state.isEnrolled
          ? _buildDarkBottomBar(state, notifier)
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CustomCard(
              padding: EdgeInsets.zero,
              color: const Color(0xFFFDE798),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFB5C0FF),
                      child: Icon(
                        course.iconData ?? Icons.code,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    course.title.toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    "BY TIM BUCHALKA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _headerStat(Icons.star, "4.7"),
                      _headerStat(Icons.person, "18K"),
                      _headerStat(Icons.access_time, "3.8HR"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- UPDATED INFO GRID SECTION ---
            _CustomCard(
              color: Colors.white,
              padding: const EdgeInsets.all(22),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Shrinks the card to fit content
                  children: [
                    // ROW 1: Level and Lessons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _infoField("LEVEL", "BEGINNER", isBadge: true),
                        ),
                        Expanded(
                          child: _infoField(
                            "LESSONS",
                            "148 LESSONS",
                            icon: Icons.book,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Explicit spacing between rows
                    // ROW 2: Categories and Durations
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _infoField("CATEGORIES", "JAVA")),
                        Expanded(
                          child: _infoField(
                            "DURATIONS",
                            "42 HOURS",
                            icon: Icons.schedule,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ---------------------------------
            const SizedBox(height: 20),

            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: "ABOUT COURSE"),
                  const Text(
                    "LEARN JAVA FROM THE GROUND UP. THIS COURSE COVERS CORE JAVA CONCEPTS, OOP PRINCIPLES, AND PREPARES YOU FOR ADVANCED TOPICS AND CERTIFICATIONS.",
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: const _SectionHeader(title: 'SKILL YOU WILL GAIN'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  "JAVA CORE",
                  "OOP",
                  "DEBUGGING",
                ].map((skill) => _skillBadge(skill)).toList(),
              ),
            ),
            SizedBox(height: 20),
            //---THIS COURSE INCLUDES SECTION---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "THE COURSE INCLUDES"),
            ),
            _CustomCard(
              color: const Color(0xFFB5C0FF),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _includeRow(Icons.videocam, "42 HOURS OF VIDEO LECTURES"),
                  _includeRow(Icons.article, "12 ARTICLES & RESOURCES"),
                  _includeRow(Icons.all_inclusive, "FULL LIFETIME ACCESS"),
                ],
              ),
            ),
            SizedBox(height: 20),
            // --- WHAT YOU WILL LEARN ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "WHAT YOU WILL LEARN"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                children: [
                  ...["BUILD COMPLEX OOP PROJECTS", "MASTER JAVA COLLECTIONS", "PREPARE FOR CERTIFICATIONS"].map((text) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 20),
                          const SizedBox(width: 10),
                          Text(text),
                        ],
                      ),
                    ),
                  ).toList(),
                ],
              ),
            ),
            SizedBox(height: 20),

            // --- INSTRUCTOR ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: const _SectionHeader(title: "YOUR INSTRUCTOR"),
            ),
            _CustomCard(
              color: Colors.white,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Row(children: [
                    const CircleAvatar(radius: 25, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 15),
                    const Text("TIM BUCHALKA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  ]),
                  const SizedBox(height: 10),
                  const Text("TIM HAD BEEN A PROFESSIONAL SOFTWARE DEVELOPER FOR OVER 35 YEARS AND HAS TAUGHT OVER 1M STUDENTS WORLDWIDE.", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            if (!state.isEnrolled)
              _buildEnrollButton(notifier)
            else ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    "COURSE CONTENT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...state.lessons.asMap().entries.map(
                (e) => _LessonTile(
                  lesson: e.value,
                  isLocked: false,
                  onTap: () => notifier.setActive(e.key),
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkBottomBar(CourseState state, CourseNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CONTINUE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "NEXT LECTURE...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDE798),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                int next = state.lessons.indexWhere((l) => !l.isCompleted);
                notifier.setActive(next != -1 ? next : 0);
              },
              child: const Text(
                "RESUME",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerStat(IconData i, String v) => Row(
    children: [
      Icon(i, size: 18),
      const SizedBox(width: 4),
      Text(v, style: const TextStyle(fontWeight: FontWeight.w900)),
    ],
  );

  Widget _skillBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
      ),
    );
  }

  Widget _infoField(
    String label,
    String value, {
    bool isBadge = false,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment
          .center, // Centers content vertically in the grid cell
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w700,
            fontSize: 14, // Increased size
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6), // More space between label and value
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD4FFD4), // Light green
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16, // Bigger badge text
              ),
            ),
          )
        else
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.black),
                const SizedBox(width: 6),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18, // Bigger value text
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildEnrollButton(CourseNotifier notifier) => InkWell(
    onTap: () => notifier.enrollUser(),
    child: _CustomCard(
      color: Colors.black,
      padding: EdgeInsets.zero,
      child: const Center(
        child: Text(
          "ENROLL NOW",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    ),
  );
}
Widget _includeRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [Icon(icon, size: 20), const SizedBox(width: 12), Text(text, style: const TextStyle(fontWeight: FontWeight.bold))]),
  );

// -------------------------------------------------------------------
// 4. UI COMPONENTS
// -------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 0, bottom: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
    ),
  );
}

class _CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  const _CustomCard({
    required this.child,
    required this.color,
    required EdgeInsets padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0),
        ],
      ),
      child: child,
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final bool isLocked;
  final VoidCallback onTap;
  const _LessonTile({
    required this.lesson,
    required this.isLocked,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)],
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.black, width: 2),

    ),
    child: ListTile(
      onTap: isLocked ? null : onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      leading: Icon(
        lesson.type == LessonType.video ? Icons.play_circle : Icons.description,
        color: Colors.black,
      ),
      title: Text(
        lesson.title,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
      ),
      subtitle: Text(
        lesson.duration,
        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
      ),
      trailing: Icon(
        lesson.isCompleted
            ? Icons.check_circle
            : (isLocked ? Icons.lock : Icons.chevron_right),
        color: Colors.black,
      ),
    ),
  );
}
