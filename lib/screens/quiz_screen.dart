import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/app_routes.dart';
import '../utils/dummy_data.dart';
import '../models/course.dart';
import '../models/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int? _selectedOption;
  int _score = 0;
  bool _answered = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      final course = ModalRoute.of(context)!.settings.arguments as Course;
      _questions = dummyQuizQuestions.where((q) => q.courseId == course.id).toList();
    }
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctOptionIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      final course = ModalRoute.of(context)!.settings.arguments as Course;
      // Quiz finished — go to result screen
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.quizResult,
        arguments: {
          'score': _score,
          'total': _questions.length,
          'course': course,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz — ${course.title}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressBar(progress),
            const SizedBox(height: 24),
            _buildQuestionCard(question),
            const SizedBox(height: 24),
            ..._buildOptions(question),
            const Spacer(),
            if (_answered) _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentIndex + 1} of ${_questions.length}',
              style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
            ),
            Text(
              'Score: $_score',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFE5E7EB),
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuizQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        question.question,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.5,
        ),
      ),
    );
  }

  List<Widget> _buildOptions(QuizQuestion question) {
    return List.generate(question.options.length, (index) {
      Color bgColor = Colors.white;
      Color borderColor = const Color(0xFFE5E7EB);
      Color textColor = AppTheme.textDark;

      if (_answered) {
        if (index == question.correctOptionIndex) {
          bgColor = AppTheme.success.withValues(alpha: 0.12);
          borderColor = AppTheme.success;
          textColor = AppTheme.success;
        } else if (index == _selectedOption) {
          bgColor = AppTheme.error.withValues(alpha: 0.1);
          borderColor = AppTheme.error;
          textColor = AppTheme.error;
        }
      } else if (_selectedOption == index) {
        borderColor = AppTheme.primary;
      }

      return GestureDetector(
        onTap: () => _selectOption(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: borderColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_answered && index == question.correctOptionIndex)
                const Icon(Icons.check_circle, color: AppTheme.success, size: 22),
              if (_answered &&
                  index == _selectedOption &&
                  index != question.correctOptionIndex)
                const Icon(Icons.cancel, color: AppTheme.error, size: 22),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNextButton() {
    final isLast = _currentIndex == _questions.length - 1;
    return ElevatedButton(
      onPressed: _nextQuestion,
      child: Text(isLast ? 'See Results' : 'Next Question'),
    );
  }
}
