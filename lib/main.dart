import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/app_theme.dart';
import 'utils/app_routes.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/course_details_screen.dart';
import 'screens/lecture_list_screen.dart';
import 'screens/video_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const InterneeApp());
}

class InterneeApp extends StatelessWidget {
  const InterneeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internee.pk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // AuthWrapper decides whether to show Home or Login
      home: const AuthWrapper(),
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.courseDetails: (_) => const CourseDetailsScreen(),
        AppRoutes.lectures: (_) => const LectureListScreen(),
        AppRoutes.video: (_) => const VideoScreen(),
        AppRoutes.quiz: (_) => const QuizScreen(),
        AppRoutes.quizResult: (_) => const QuizResultScreen(),
      },
    );
  }
}

// Listens to Firebase auth state and routes accordingly
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Not logged in — show login
        return const LoginScreen();
      },
    );
  }
}
