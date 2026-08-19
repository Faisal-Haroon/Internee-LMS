import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_routes.dart';
import '../models/course.dart';
import '../services/progress_service.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  final ProgressService _progressService = ProgressService();
  bool _scoreSaved = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int score = args['score'];
    final int total = args['total'];
    final course = args['course'] as Course;
    
    // Calculate percentage
    final double percentage = total > 0 ? (score / total) * 100 : 0;

    // Save score only once
    if (!_scoreSaved) {
      _scoreSaved = true;
      _progressService.saveQuizScore(course.id, score);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildResultIcon(percentage),
              const SizedBox(height: 32),
              _buildTitle(percentage),
              const SizedBox(height: 8),
              Text(
                '$score out of $total correct',
                style: const TextStyle(color: AppTheme.textGrey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              _buildScoreCard(score, total, percentage),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.home,
                ),
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon(double percentage) {
    final bool passed = percentage >= 60;
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: passed
            ? AppTheme.success.withValues(alpha: 0.15)
            : AppTheme.error.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
        size: 64,
        color: passed ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  Widget _buildTitle(double percentage) {
    final bool passed = percentage >= 60;
    return Text(
      passed ? 'Great Job! 🎉' : 'Keep Practicing!',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: passed ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  Widget _buildScoreCard(int score, int total, double percentage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: const Color(0xFFE5E7EB),
            color: percentage >= 60 ? AppTheme.success : AppTheme.error,
            borderRadius: BorderRadius.circular(4),
            minHeight: 10,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem('$score', 'Correct', AppTheme.success),
              _statItem('${total - score}', 'Wrong', AppTheme.error),
              _statItem('$total', 'Total', AppTheme.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textGrey)),
      ],
    );
  }
}
