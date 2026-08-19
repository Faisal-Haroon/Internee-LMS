import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_routes.dart';
import '../models/course.dart';
import '../services/progress_service.dart';
import '../utils/dummy_data.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final ProgressService _progressService = ProgressService();
  Course? _course;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_course == null) {
      _course = ModalRoute.of(context)!.settings.arguments as Course;
      _loadProgress();
    }
  }

  Future<void> _loadProgress() async {
    if (_course == null) return;
    int count = await _progressService.getCompletedLecturesCountForCourse(
        _course!.id, dummyLectures);
    final score = await _progressService.getQuizScore(_course!.id);
        
    if (mounted) {
      setState(() {
        _course = _course!.copyWith(
          completedLectures: count,
          hasAttemptedQuiz: score != null,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final course = _course!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, course),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressSection(course),
                  const SizedBox(height: 24),
                  const Text(
                    'About this Course',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(course),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.lectures,
                        arguments: course,
                      );
                      _loadProgress();
                    },
                    child: Text(
                      course.completedLectures > 0
                          ? 'Continue Course'
                          : 'Start Course',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.quiz,
                      arguments: course,
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Take Quiz'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, Course course) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          course.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: Image.asset(
          course.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppTheme.primary,
            child: const Icon(Icons.school, size: 64, color: Colors.white54),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(Course course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${(course.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: course.progress,
            backgroundColor: Colors.white,
            color: course.progress >= 1 ? AppTheme.success : AppTheme.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${course.completedLectures} lectures completed',
                style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
              ),
              Text(
                '${course.totalLectures} total',
                style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Course course) {
    return Row(
      children: [
        Expanded(child: _infoChip(Icons.person_outlined, course.instructor)),
        const SizedBox(width: 12),
        _infoChip(Icons.video_library_outlined, '${course.totalLectures} lectures'),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppTheme.textGrey),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
