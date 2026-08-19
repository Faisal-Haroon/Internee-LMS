class Lecture {
  final String id;
  final String courseId;
  final String title;
  final String duration;
  final String videoUrl;
  final bool isCompleted;
  final int order;

  Lecture({
    required this.id,
    required this.courseId,
    required this.title,
    required this.duration,
    required this.videoUrl,
    this.isCompleted = false,
    required this.order,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '00:00',
      videoUrl: json['video_url'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      order: json['order'] ?? 0,
    );
  }
}
