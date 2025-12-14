import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// NOTE: The 'legacy.dart' import is often unnecessary in modern Riverpod setups
// unless you are dealing with very old code or specific packages that require it.

// -------------------------------------------------------------------
// 1. DATA AND HELPER STRUCTURES
// -------------------------------------------------------------------

/// Mock Course class (Shared Model)
class Course {
  final String title;
  final String category;
  final int userCount;
  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  Course({
    required this.title,
    required this.category,
    required this.userCount,
    required this.iconData,
    required this.backgroundColor,
    required this.iconColor,
    this.textColor = Colors.white,
  });
}

/// Enum for Lesson Type
enum LessonType { video, text }

/// Simple Lesson model
class LessonModel {
  final String? title;
  final String? duration;
  final bool? isCompleted;
  final LessonType type;
  // 🎯 ADDED: URL for the remote content (video stream, PDF, etc.)
  final String? contentUrl;

  LessonModel({
    this.title,
    this.duration,
    this.isCompleted,
    this.type = LessonType.text,
    this.contentUrl,
  });

  LessonModel copyWith({
    String? title,
    String? duration,
    bool? isCompleted,
    LessonType? type,
    String? contentUrl,
  }) {
    return LessonModel(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      type: type ?? this.type,
      contentUrl: contentUrl ?? this.contentUrl,
    );
  }
}

/// Course detail model that holds a list of lessons
class CourseDetailModel {
  final List<LessonModel> lessonsList;

  CourseDetailModel({required this.lessonsList});
}

/// State exposed by the notifier
class CourseDetailState {
  final CourseDetailModel? courseDetailModel;
  // This index now points to the lesson currently being played/viewed
  final int? activeLessonIndex;
  // 🎯 ADDED: Flag to conditionally show a non-video view (e.g., PDF/Text)
  final bool isTextLessonActive;

  CourseDetailState({
    this.courseDetailModel,
    this.activeLessonIndex,
    this.isTextLessonActive = false,
  });

  CourseDetailState copyWith({
    CourseDetailModel? courseDetailModel,
    int? activeLessonIndex,
    bool? isTextLessonActive,
  }) {
    return CourseDetailState(
      courseDetailModel: courseDetailModel ?? this.courseDetailModel,
      // For activeLessonIndex, null must be explicitly passed to clear it
      activeLessonIndex: activeLessonIndex,
      isTextLessonActive: isTextLessonActive ?? this.isTextLessonActive,
    );
  }
}

/// Notifier to manage course detail state
class CourseDetailNotifier extends StateNotifier<CourseDetailState> {
  CourseDetailNotifier() : super(CourseDetailState());

  // Initialize with mock lessons, including video and content URLs
  void initializeCourse() {
    final lessons = List.generate(
      6,
      (index) {
        final isVideo = index % 4 == 0;
        final type = isVideo ? LessonType.video : LessonType.text;
        return LessonModel(
          title: isVideo
              ? 'Video Introduction (5:30)'
              : 'Lesson ${index + 1}: Core Concepts',
          duration: isVideo ? '5:30' : '${5 + index * 2} mins',
          isCompleted: index % 3 == 0 ? true : false,
          type: type,
          // 🎯 Mocking Content URLs for demonstration
          contentUrl: isVideo
              ? 'https://www.youtube.com/watch?v=m7WbH6mY7YM'
              : 'https://drive.google.com/file/d/1HdumwDHyH_QtwkdbP3ICyBIzQkYfoy51/view?usp=sharing',
        );
      },
    );
    state = state.copyWith(
      courseDetailModel: CourseDetailModel(lessonsList: lessons),
      activeLessonIndex: null,
      isTextLessonActive: false,
    );
  }

  // Toggle lesson completion status
  void toggleLessonCompletion(int index) {
    final current = state.courseDetailModel;
    if (current == null) return;
    final list = List<LessonModel>.from(current.lessonsList);
    if (index < 0 || index >= list.length) return;
    final item = list[index];
    list[index] = item.copyWith(isCompleted: !(item.isCompleted ?? false));
    state = state.copyWith(courseDetailModel: CourseDetailModel(lessonsList: list));
  }

  // Sets the currently active lesson to be played/viewed
  void setActiveLesson(int index) {
    final list = state.courseDetailModel?.lessonsList;
    if (list == null || index < 0 || index >= list.length) {
      clearActiveLesson();
      return;
    }

    // Clear any existing active view
    clearActiveLesson();

    if (list[index].type == LessonType.video) {
      // Set video lesson as active
      state = state.copyWith(activeLessonIndex: index, isTextLessonActive: false);
    } else {
      // Set non-video lesson (text/PDF) as active
      state = state.copyWith(activeLessonIndex: index, isTextLessonActive: true);
    }
  }

  // Clear the active lesson (e.g., when the user closes the video/pdf)
  void clearActiveLesson() {
    state = state.copyWith(activeLessonIndex: null, isTextLessonActive: false);
  }
}

/// Riverpod provider used by the screen
final courseDetailNotifier =
    StateNotifierProvider<CourseDetailNotifier, CourseDetailState>(
  (ref) => CourseDetailNotifier(),
);

// -------------------------------------------------------------------
// 2. MAIN SCREEN WIDGET (CourseDetailScreen - CONNECTED)
// -------------------------------------------------------------------

class CourseDetailScreen extends ConsumerStatefulWidget {
  final Course course;

  CourseDetailScreen({required this.course, Key? key}) : super(key: key);

  @override
  CourseDetailScreenState createState() => CourseDetailScreenState();
}

class CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  Color get headerColor => widget.course.backgroundColor.withOpacity(0.2);
  Color get primaryColor => widget.course.iconColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseDetailNotifier.notifier).initializeCourse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(courseDetailNotifier);
    final notifier = ref.read(courseDetailNotifier.notifier);

    final lessonsList = state.courseDetailModel?.lessonsList ?? [];
    final completedLessons =
        lessonsList.where((lesson) => lesson.isCompleted ?? false).length;
    final totalLessons = lessonsList.length;
    final progress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    final isActiveLesson = state.activeLessonIndex != null && lessonsList.isNotEmpty;

    // CONDITIONAL UI RENDERING: Video Player / Text View vs. Course Details
    if (isActiveLesson) {
      final activeLesson = lessonsList[state.activeLessonIndex!];

      if (state.isTextLessonActive) {
        // Show Text/PDF Viewer for non-video lessons
        return TextLessonView(
          lesson: activeLesson,
          primaryColor: primaryColor,
          onClose: notifier.clearActiveLesson,
          onComplete: () {
            notifier.toggleLessonCompletion(state.activeLessonIndex!);
            notifier.clearActiveLesson();
          },
        );
      } else {
        // Show Video Player for video lessons
        return VideoPlayerWidget(
          lessonTitle: activeLesson.title ?? 'Untitled Video Lesson',
          // Pass the content URL to the player
          contentUrl: activeLesson.contentUrl ?? 'No URL',
          primaryColor: primaryColor,
          onClose: notifier.clearActiveLesson,
          onComplete: () {
            notifier.toggleLessonCompletion(state.activeLessonIndex!);
            notifier.clearActiveLesson();
          },
        );
      }
    }

    // Default Course Detail Screen
    return Container(
      color: headerColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _buildBottomBar(context, notifier, lessonsList),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, progress, completedLessons, totalLessons),
                const SizedBox(height: 24),
                _buildStatsSection(totalLessons),
                const SizedBox(height: 24),
                _buildDescription(),
                const SizedBox(height: 24),
                _buildLessonsList(state, notifier),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET IMPLEMENTATIONS (Same as original, except for _buildLessonsList and _buildBottomBar logic) ---

  Widget _buildHeader(
      BuildContext context, double progress, int completed, int total) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 20),
          _buildCourseIcon(),
          const SizedBox(height: 16),
          _buildBeginnerChip(),
          const SizedBox(height: 8),
          _buildCourseTitle(),
          const SizedBox(height: 16),
          _buildProgressIndicator(progress, completed, total),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double progress, int completed, int total) {
    final Color progressColor = primaryColor;
    final percentage = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              Text(
                '$percentage% ($completed of $total lessons)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList(
      CourseDetailState state, CourseDetailNotifier notifier) {
    final lessonsList = state.courseDetailModel?.lessonsList ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...lessonsList.asMap().entries.map((entry) {
            final lessonModel = entry.value;
            final index = entry.key;

            return GestureDetector(
              onTap: () {
                // Now, tapping any lesson sets it as active,
                // and the main build method decides which view to show.
                notifier.setActiveLesson(index);
              },
              child: LessonTile(
                title: lessonModel.title ?? 'Untitled Lesson',
                duration: lessonModel.duration ?? '0 mins',
                isCompleted: lessonModel.isCompleted ?? false,
                type: lessonModel.type,
                primaryColor: primaryColor,
              ),
            );
          }).toList(),
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
            'Lesson Details',
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

  Widget _buildCourseIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Icon(
        widget.course.iconData, // 🎯 USED PASSED DATA
        color: primaryColor,
        size: 40,
      ),
    );
  }

  Widget _buildBeginnerChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        widget.course.category.split(' ').first, // 🎯 USED PASSED DATA
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCourseTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        widget.course.title, // 🎯 USED PASSED DATA
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildStatsSection(int totalLessons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatCard(
            icon: Icons.book_outlined,
            value: totalLessons.toString(),
            label: 'Lessons',
            color: const Color(0xFFD3E5FD),
            iconColor: const Color(0xFF00468D),
          ),
          const SizedBox(width: 16),
          const StatCard(
            icon: Icons.quiz_outlined,
            value: '12',
            label: 'Quizzes',
            color: Color(0xFFFFE8D6),
            iconColor: Color(0xFFC26A00),
          ),
          const SizedBox(width: 16),
          StatCard(
            icon: Icons.group,
            value: '${widget.course.userCount}+', // 🎯 USED PASSED DATA
            label: 'Students',
            color: const Color(0xFFF3E5F5),
            iconColor: const Color(0xFF6A1B9A),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        'Enhance your skills in **${widget.course.category}** with this course, **${widget.course.title}**. Master common concepts and improve your practical application today.', // 🎯 USED PASSED DATA
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black54,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CourseDetailNotifier notifier,
      List<LessonModel> lessonsList) {
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
          )),
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
              onPressed: () {
                // Find the first uncompleted lesson
                final firstUncompleted = lessonsList
                    .indexWhere((l) => !(l.isCompleted ?? false));

                if (firstUncompleted != -1) {
                  // If found, activate it (video or text)
                  notifier.setActiveLesson(firstUncompleted);
                } else {
                  // All lessons completed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("All lessons are completed!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
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
              child: const Text('Start Next Lesson'),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// 3. AUXILIARY WIDGETS
// -------------------------------------------------------------------

/// Mock Video Player Widget - Now receives contentUrl
class VideoPlayerWidget extends StatelessWidget {
  final String lessonTitle;
  final String contentUrl; // 🎯 New: Content URL
  final Color primaryColor;
  final VoidCallback onClose;
  final VoidCallback onComplete;

  const VideoPlayerWidget({
    super.key,
    required this.lessonTitle,
    required this.contentUrl,
    required this.primaryColor,
    required this.onClose,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // In a real application, you would initialize a video player (e.g., video_player)
    // using the 'contentUrl' here.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onClose,
        ),
        title: Text(
          lessonTitle,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline, color: primaryColor),
            onPressed: onComplete,
            tooltip: 'Mark as Completed',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.grey.shade900,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.movie,
                        color: Colors.white54,
                        size: 80,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Streaming from:\n$contentUrl', // 🎯 Display the URL
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock Text/PDF View Widget
class TextLessonView extends StatelessWidget {
  final LessonModel lesson;
  final Color primaryColor;
  final VoidCallback onClose;
  final VoidCallback onComplete;

  const TextLessonView({
    super.key,
    required this.lesson,
    required this.primaryColor,
    required this.onClose,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // In a real application, if lesson.type == LessonType.text,
    // you would use a package like 'flutter_pdfview' to load lesson.contentUrl.
    final contentType = lesson.contentUrl!.endsWith('.pdf') ? 'PDF' : 'Text Article';
    final icon = lesson.contentUrl!.endsWith('.pdf') ? Icons.picture_as_pdf : Icons.article;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        title: Text(
          lesson.title ?? 'Untitled Lesson',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed: onComplete,
            tooltip: 'Mark as Completed',
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: primaryColor),
              const SizedBox(height: 16),
              Text(
                '$contentType Viewer Placeholder',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Lesson URL:\n${lesson.contentUrl}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const Text(
                'This screen simulates loading and displaying a non-video asset (like a PDF or rich text). The lesson is marked complete upon closing.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable widget for statistics cards
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

/// Reusable widget for a single lesson tile
class LessonTile extends StatelessWidget {
  final String title;
  final String duration;
  final bool isCompleted;
  final LessonType type;
  final Color primaryColor;

  const LessonTile({
    super.key,
    required this.title,
    required this.duration,
    this.isCompleted = false,
    this.type = LessonType.text,
    this.primaryColor = const Color(0xFF6750A4),
  });

  IconData get _iconData {
    switch (type) {
      case LessonType.video:
        return Icons.play_circle_outline;
      case LessonType.text:
        return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ]),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(_iconData, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.grey : Colors.black87,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      type == LessonType.video
                          ? Icons.ondemand_video
                          : Icons.menu_book,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          if (!isCompleted && type == LessonType.video)
            Icon(
              Icons.play_arrow_rounded,
              size: 30,
              color: primaryColor,
            ),
          if (!isCompleted && type == LessonType.text)
            Icon(
              Icons.chevron_right,
              size: 30,
              color: primaryColor,
            ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// 4. APPLICATION ENTRY POINT
// -------------------------------------------------------------------
