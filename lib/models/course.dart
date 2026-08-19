class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String imageUrl;
  final int totalLectures;
  final int completedLectures;
  final bool hasAttemptedQuiz;
  final String category;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.imageUrl,
    required this.totalLectures,
    this.completedLectures = 0,
    this.hasAttemptedQuiz = false,
    required this.category,
  });

  Course copyWith({
    int? completedLectures,
    bool? hasAttemptedQuiz,
  }) {
    return Course(
      id: id,
      title: title,
      description: description,
      instructor: instructor,
      imageUrl: imageUrl,
      totalLectures: totalLectures,
      completedLectures: completedLectures ?? this.completedLectures,
      hasAttemptedQuiz: hasAttemptedQuiz ?? this.hasAttemptedQuiz,
      category: category,
    );
  }

  double get progress {
    if (totalLectures == 0) return 0;
    double lectureProgress = completedLectures / totalLectures;
    
    // If all lectures are watched but quiz isn't attempted, cap at 95%
    if (lectureProgress >= 1.0 && !hasAttemptedQuiz) {
      return 0.95; 
    }
    
    return lectureProgress;
  }

  // Convert from API JSON response
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructor: json['instructor'] ?? 'Internee.pk',
      imageUrl: json['image_url'] ?? '',
      totalLectures: json['total_lectures'] ?? 0,
      completedLectures: json['completed_lectures'] ?? 0,
      category: json['category'] ?? 'General',
    );
  }
}
