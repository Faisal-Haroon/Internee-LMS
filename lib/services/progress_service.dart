import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  static const String _completedLecturesKey = 'completed_lectures';
  static const String _quizScoresKey = 'quiz_scores';

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'guest';

  // Mark a lecture as completed
  Future<void> markLectureCompleted(String lectureId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_completedLecturesKey}_$_userId';
    final completed = prefs.getStringList(key) ?? [];
    
    if (!completed.contains(lectureId)) {
      completed.add(lectureId);
      await prefs.setStringList(key, completed);
    }
  }

  // Check if a lecture is completed
  Future<bool> isLectureCompleted(String lectureId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_completedLecturesKey}_$_userId';
    final completed = prefs.getStringList(key) ?? [];
    return completed.contains(lectureId);
  }

  // Get all completed lectures
  Future<List<String>> getCompletedLectures() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_completedLecturesKey}_$_userId';
    return prefs.getStringList(key) ?? [];
  }

  // Save quiz score
  Future<void> saveQuizScore(String courseId, int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_quizScoresKey}_${courseId}_$_userId', score);
  }

  // Get quiz score
  Future<int?> getQuizScore(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_quizScoresKey}_${courseId}_$_userId');
  }

  // Helper to count completed lectures for a specific course
  Future<int> getCompletedLecturesCountForCourse(String courseId, List<dynamic> allLectures) async {
    final completedIds = await getCompletedLectures();
    final courseLectures = allLectures.where((l) => l.courseId == courseId).toList();
    int count = 0;
    for (var l in courseLectures) {
      if (completedIds.contains(l.id)) count++;
    }
    return count;
  }
}
