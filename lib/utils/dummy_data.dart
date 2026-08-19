import '../models/course.dart';
import '../models/lecture.dart';
import '../models/quiz_question.dart';

// Since there is no live API provided yet, we are using the detailed hardcoded
// data from the reference GitHub repository to populate the app fully.

final List<Course> dummyCourses = [
  Course(
    id: 'c1',
    title: 'Flutter Complete Bootcamp',
    description:
        'Learn Flutter from scratch and build beautiful cross-platform mobile apps. Covers Dart basics, widgets, state management, navigation, REST APIs, and animations.',
    instructor: 'The Net Ninja',
    imageUrl: 'assets/images/fluttercourse.png',
    totalLectures: 7,
    category: 'Mobile Development',
  ),
  Course(
    id: 'c2',
    title: 'Python for Beginners',
    description:
        'Master Python programming from zero to intermediate. Topics include variables, loops, functions, OOP, file handling, and real-world projects.',
    instructor: 'Programming with Mosh',
    imageUrl: 'assets/images/python4beginners.png',
    totalLectures: 7,
    category: 'Programming',
  ),
  Course(
    id: 'c3',
    title: 'React JS Full Course',
    description:
        'Build modern web apps with React 18. Learn components, hooks, state, context API, React Router, and connecting to REST APIs with real projects.',
    instructor: 'Traversy Media',
    imageUrl: 'assets/images/reactjs.png',
    totalLectures: 7,
    category: 'Web Development',
  ),
  Course(
    id: 'c4',
    title: 'Machine Learning with Python',
    description:
        'Dive into ML using Python and scikit-learn. Covers supervised & unsupervised learning, regression, classification, and model deployment.',
    instructor: 'Sentdex',
    imageUrl: 'assets/images/MLwithPy.png',
    totalLectures: 7,
    category: 'Machine Learning',
  ),
];

final List<Lecture> dummyLectures = [
  // Course 1: Flutter
  Lecture(id: 'c1_l1', courseId: 'c1', title: 'Introduction to Flutter & Setup', duration: '8:10', videoUrl: 'VPvVD8t02U8', order: 1),
  Lecture(id: 'c1_l2', courseId: 'c1', title: 'Dart Language Basics', duration: '9:45', videoUrl: 'Ej_Pcr4uC2Q', order: 2),
  Lecture(id: 'c1_l3', courseId: 'c1', title: 'Flutter Widgets Overview', duration: '7:30', videoUrl: 'b_sQ9bMltGU', order: 3),
  Lecture(id: 'c1_l4', courseId: 'c1', title: 'State Management Essentials', duration: '12:15', videoUrl: 'VPvVD8t02U8', order: 4),
  Lecture(id: 'c1_l5', courseId: 'c1', title: 'Navigation & Routing', duration: '10:05', videoUrl: 'Ej_Pcr4uC2Q', order: 5),
  Lecture(id: 'c1_l6', courseId: 'c1', title: 'REST API Integration', duration: '14:20', videoUrl: 'b_sQ9bMltGU', order: 6),
  Lecture(id: 'c1_l7', courseId: 'c1', title: 'Building the Final App', duration: '18:45', videoUrl: 'VPvVD8t02U8', order: 7),

  // Course 2: Python
  Lecture(id: 'c2_l1', courseId: 'c2', title: 'Python Installation & First Program', duration: '6:20', videoUrl: 'kqtD5dpn9C8', order: 1),
  Lecture(id: 'c2_l2', courseId: 'c2', title: 'Variables & Data Types', duration: '8:45', videoUrl: 'vBpjvRk078I', order: 2),
  Lecture(id: 'c2_l3', courseId: 'c2', title: 'Strings & String Methods', duration: '9:10', videoUrl: 'k9TUPpGqYTo', order: 3),
  Lecture(id: 'c2_l4', courseId: 'c2', title: 'Loops and Conditionals', duration: '11:30', videoUrl: 'kqtD5dpn9C8', order: 4),
  Lecture(id: 'c2_l5', courseId: 'c2', title: 'Functions and Modules', duration: '14:20', videoUrl: 'vBpjvRk078I', order: 5),
  Lecture(id: 'c2_l6', courseId: 'c2', title: 'Object Oriented Programming', duration: '15:10', videoUrl: 'k9TUPpGqYTo', order: 6),
  Lecture(id: 'c2_l7', courseId: 'c2', title: 'Python Project: Web Scraper', duration: '20:15', videoUrl: 'kqtD5dpn9C8', order: 7),

  // Course 3: React
  Lecture(id: 'c3_l1', courseId: 'c3', title: 'React Introduction & Setup', duration: '7:20', videoUrl: 'bMknfKXIFA8', order: 1),
  Lecture(id: 'c3_l2', courseId: 'c3', title: 'JSX & Components', duration: '8:45', videoUrl: 'RVFAyFWO4go', order: 2),
  Lecture(id: 'c3_l3', courseId: 'c3', title: 'Props & PropTypes', duration: '7:10', videoUrl: 'PHaECbrKgs0', order: 3),
  Lecture(id: 'c3_l4', courseId: 'c3', title: 'State & useState Hook', duration: '12:30', videoUrl: 'bMknfKXIFA8', order: 4),
  Lecture(id: 'c3_l5', courseId: 'c3', title: 'useEffect Hook in Depth', duration: '14:25', videoUrl: 'RVFAyFWO4go', order: 5),
  Lecture(id: 'c3_l6', courseId: 'c3', title: 'Context API for State Management', duration: '11:40', videoUrl: 'PHaECbrKgs0', order: 6),
  Lecture(id: 'c3_l7', courseId: 'c3', title: 'React Router Setup', duration: '16:05', videoUrl: 'bMknfKXIFA8', order: 7),

  // Course 4: Machine Learning
  Lecture(id: 'c4_l1', courseId: 'c4', title: 'What is Machine Learning?', duration: '7:20', videoUrl: 'ukzFI9rgwfU', order: 1),
  Lecture(id: 'c4_l2', courseId: 'c4', title: 'NumPy & Pandas Setup', duration: '9:45', videoUrl: 'vmEHCJofslg', order: 2),
  Lecture(id: 'c4_l3', courseId: 'c4', title: 'Data Preprocessing & Cleaning', duration: '10:30', videoUrl: 'KF6QZtTVGCg', order: 3),
  Lecture(id: 'c4_l4', courseId: 'c4', title: 'Linear Regression Explained', duration: '13:15', videoUrl: 'ukzFI9rgwfU', order: 4),
  Lecture(id: 'c4_l5', courseId: 'c4', title: 'Building a Classification Model', duration: '16:40', videoUrl: 'vmEHCJofslg', order: 5),
  Lecture(id: 'c4_l6', courseId: 'c4', title: 'Evaluating ML Models', duration: '11:20', videoUrl: 'KF6QZtTVGCg', order: 6),
  Lecture(id: 'c4_l7', courseId: 'c4', title: 'Deploying your ML Model', duration: '18:50', videoUrl: 'ukzFI9rgwfU', order: 7),
];

final List<QuizQuestion> dummyQuizQuestions = [
  // Course 1: Flutter
  QuizQuestion(id: 'c1_q1', courseId: 'c1', question: 'What language does Flutter use?', options: ['Java', 'Kotlin', 'Swift', 'Dart'], correctOptionIndex: 3),
  QuizQuestion(id: 'c1_q2', courseId: 'c1', question: 'Which widget rebuilds when state changes?', options: ['StatelessWidget', 'InheritedWidget', 'StatefulWidget', 'Container'], correctOptionIndex: 2),
  QuizQuestion(id: 'c1_q3', courseId: 'c1', question: 'What command runs a Flutter app?', options: ['flutter start', 'flutter launch', 'dart run', 'flutter run'], correctOptionIndex: 3),

  // Course 2: Python
  QuizQuestion(id: 'c2_q1', courseId: 'c2', question: 'What is the correct file extension for Python?', options: ['.python', '.pt', '.pyt', '.py'], correctOptionIndex: 3),
  QuizQuestion(id: 'c2_q2', courseId: 'c2', question: 'Which keyword defines a function in Python?', options: ['function', 'func', 'def', 'define'], correctOptionIndex: 2),
  QuizQuestion(id: 'c2_q3', courseId: 'c2', question: 'Which data type stores key-value pairs?', options: ['List', 'Tuple', 'Dictionary', 'Set'], correctOptionIndex: 2),

  // Course 3: React
  QuizQuestion(id: 'c3_q1', courseId: 'c3', question: 'React is developed and maintained by?', options: ['Google', 'Microsoft', 'Twitter', 'Facebook (Meta)'], correctOptionIndex: 3),
  QuizQuestion(id: 'c3_q2', courseId: 'c3', question: 'Which hook manages state in functional components?', options: ['useEffect', 'useContext', 'useState', 'useRef'], correctOptionIndex: 2),
  QuizQuestion(id: 'c3_q3', courseId: 'c3', question: 'How do you pass data from parent to child?', options: ['State', 'Context', 'Props', 'Redux'], correctOptionIndex: 2),

  // Course 4: ML
  QuizQuestion(id: 'c4_q1', courseId: 'c4', question: 'Which type of ML uses labeled training data?', options: ['Supervised Learning', 'Unsupervised Learning', 'Reinforcement Learning', 'Transfer Learning'], correctOptionIndex: 0),
  QuizQuestion(id: 'c4_q2', courseId: 'c4', question: 'Which Python library is most used for ML?', options: ['scikit-learn', 'React', 'Django', 'Bootstrap'], correctOptionIndex: 0),
  QuizQuestion(id: 'c4_q3', courseId: 'c4', question: 'Pandas library is used for?', options: ['Deep learning', 'Data manipulation and analysis', 'Web scraping', 'Image processing'], correctOptionIndex: 1),
];
