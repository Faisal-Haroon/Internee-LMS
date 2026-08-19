import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../utils/app_theme.dart';
import '../models/lecture.dart';
import '../models/course.dart';
import '../services/progress_service.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController? _youtubeController;
  final ProgressService _progressService = ProgressService();
  bool _isCompleted = false;
  late Lecture lecture;
  late Course course;
  bool _isInit = false;
  bool _isMarking = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      lecture = args['lecture'] as Lecture;
      course = args['course'] as Course;

      _initPlayer();
      _checkCompletion();
    }
  }

  void _checkCompletion() async {
    final completed = await _progressService.isLectureCompleted(lecture.id);
    if (mounted && completed) {
      setState(() => _isCompleted = true);
    }
  }

  void _markCompleted() async {
    if (_isCompleted) {
      Navigator.pop(context);
      return;
    }
    setState(() => _isMarking = true);
    await _progressService.markLectureCompleted(lecture.id);
    if (mounted) {
      setState(() {
        _isCompleted = true;
        _isMarking = false;
      });
      // Brief success feedback then go back
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);
    }
  }

  void _initPlayer() {
    if (lecture.videoUrl.isEmpty) return;

    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: lecture.videoUrl,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    _youtubeController!.listen((event) {
      if (event.playerState == PlayerState.ended) {
        _markCompleted();
      }
    });
  }

  @override
  void dispose() {
    _youtubeController?.close();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          course.title,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // ─── Video Player ───
          if (lecture.videoUrl.isEmpty || _youtubeController == null)
            Container(
              height: 220,
              color: const Color(0xFF111827),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam_off, color: Colors.white30, size: 48),
                    SizedBox(height: 8),
                    Text(
                      'No video available',
                      style: TextStyle(color: Colors.white38),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: YoutubePlayer(controller: _youtubeController!),
            ),

          // ─── Content Card ───
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Lecture order chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Lecture ${lecture.order}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lecture title
                    Text(
                      lecture.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Meta row: duration + course
                    Row(
                      children: [
                        _metaChip(Icons.access_time_rounded, lecture.duration),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _metaChip(Icons.school_outlined, course.title, truncate: true),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 28),

                    // ─── Mark as Complete Button ───
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _isCompleted
                          ? _buildCompletedState()
                          : _buildMarkCompleteButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(IconData icon, String label, {bool truncate = false}) {
    final text = Text(
      label,
      style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
      overflow: truncate ? TextOverflow.ellipsis : null,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.textGrey),
        const SizedBox(width: 6),
        truncate ? Expanded(child: text) : text,
      ],
    );
  }

  Widget _buildMarkCompleteButton() {
    return SizedBox(
      key: const ValueKey('btn'),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isMarking ? null : _markCompleted,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isMarking
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Mark as Completed',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCompletedState() {
    return Container(
      key: const ValueKey('done'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accent.withValues(alpha: 0.08),
            AppTheme.accent.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lecture Completed!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your progress has been saved.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textGrey),
        ],
      ),
    );
  }
}
