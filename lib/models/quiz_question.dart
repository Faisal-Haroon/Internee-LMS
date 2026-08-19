class QuizQuestion {
  final String id;
  final String courseId;
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.id,
    required this.courseId,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correct_option_index'] ?? 0,
    );
  }
}
