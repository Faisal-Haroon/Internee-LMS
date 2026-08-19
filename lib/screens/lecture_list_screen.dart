import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_routes.dart';
import '../utils/dummy_data.dart';
import '../models/course.dart';
import '../models/lecture.dart';
import '../services/progress_service.dart';

class LectureListScreen extends StatefulWidget {
  const LectureListScreen({super.key});

  @override
  State<LectureListScreen> createState() => _LectureListScreenState();
}

class _LectureListScreenState extends State<LectureListScreen> {
  final ProgressService _progressService = ProgressService();
  List<String> _completedLectureIds = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await _progressService.getCompletedLectures();
    if (mounted) {
      setState(() {
        _completedLectureIds = completed;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    
    // Filter lectures for this specific course
    final courseLectures = dummyLectures.where((l) => l.courseId == course.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courseLectures.length,
              itemBuilder: (context, index) {
                final lecture = courseLectures[index];
                final isCompleted = _completedLectureIds.contains(lecture.id);

                return _LectureItem(
                  lecture: lecture,
                  course: course,
                  isCompleted: isCompleted,
                  onReturned: _loadProgress,
                );
              },
            ),
    );
  }
}

class _LectureItem extends StatelessWidget {
  final Lecture lecture;
  final Course course;
  final bool isCompleted;
  final VoidCallback onReturned;

  const _LectureItem({
    required this.lecture,
    required this.course,
    required this.isCompleted,
    required this.onReturned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.success.withValues(alpha: 0.15)
                : AppTheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : Icons.play_circle_fill_rounded,
            color: isCompleted ? AppTheme.success : AppTheme.primary,
            size: 28,
          ),
        ),
        title: Text(
          '${lecture.order}. ${lecture.title}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isCompleted ? AppTheme.textGrey : AppTheme.textDark,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppTheme.textGrey),
              const SizedBox(width: 4),
              Text(
                lecture.duration,
                style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
              ),
              if (isCompleted) ...[
                const SizedBox(width: 10),
                const Text(
                  'Completed',
                  style: TextStyle(fontSize: 12, color: AppTheme.success),
                ),
              ],
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
        onTap: () async {
          // Wait for video screen to pop, then reload progress
          await Navigator.pushNamed(
            context,
            AppRoutes.video,
            arguments: {'lecture': lecture, 'course': course},
          );
          onReturned();
        },
      ),
    );
  }
}
