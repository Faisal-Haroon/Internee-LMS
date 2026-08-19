import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/progress_service.dart';
import '../utils/app_theme.dart';
import '../utils/app_routes.dart';
import '../utils/dummy_data.dart';
import '../widgets/course_card.dart';
import '../models/course.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ProgressService _progressService = ProgressService();
  List<Course> _activeCourses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    List<Course> updatedCourses = [];
    for (var course in dummyCourses) {
      int count = await _progressService.getCompletedLecturesCountForCourse(
          course.id, dummyLectures);
      final score = await _progressService.getQuizScore(course.id);
      
      updatedCourses.add(course.copyWith(
        completedLectures: count,
        hasAttemptedQuiz: score != null,
      ));
    }
    if (mounted) {
      setState(() {
        _activeCourses = updatedCourses;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> pages = [
      _HomeTab(courses: _activeCourses, onRefresh: _loadProgress),
      _CoursesTab(courses: _activeCourses, onRefresh: _loadProgress),
      _ProfileTab(
        courses: _activeCourses,
        onNavigateToCourses: () => setState(() => _selectedIndex = 1),
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final List<Course> courses;
  final VoidCallback onRefresh;
  const _HomeTab({required this.courses, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final inProgress = courses
        .where((c) => c.completedLectures > 0 && c.progress < 1)
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 24),
            _buildStatsBanner(context),
            const SizedBox(height: 28),
            _buildSectionTitle(context, 'Continue Learning'),
            const SizedBox(height: 12),
            if (inProgress.isEmpty)
              const Text(
                'No courses in progress yet.',
                style: TextStyle(color: AppTheme.textGrey),
              )
            else
              ...inProgress.map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CourseCard(
                    course: course,
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.courseDetails,
                        arguments: course,
                      );
                      onRefresh();
                    },
                  ),
                ),
              ),
            const SizedBox(height: 28),
            _buildSectionTitle(context, 'All Courses'),
            const SizedBox(height: 12),
            ...courses.map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CourseCard(
                  course: course,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.courseDetails,
                      arguments: course,
                    );
                    onRefresh();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'user@example.com';
    final name = email.split('@')[0];
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    // Time-based greeting
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning! 👋';
    } else if (hour < 17) {
      greeting = 'Good afternoon! 👋';
    } else {
      greeting = 'Good evening! 👋';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Hi, $name!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primary,
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBanner(BuildContext context) {
    final completed = courses.where((c) => c.progress >= 1).length;
    final total = courses.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completed / $total Courses',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: total > 0 ? completed / total : 0,
                  backgroundColor: Colors.white30,
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 48),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
      ),
    );
  }
}

class _CoursesTab extends StatelessWidget {
  final List<Course> courses;
  final VoidCallback onRefresh;
  const _CoursesTab({required this.courses, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'All Courses',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CourseCard(
                    course: course,
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.courseDetails,
                        arguments: course,
                      );
                      onRefresh();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatefulWidget {
  final List<Course> courses;
  final VoidCallback onNavigateToCourses;
  const _ProfileTab({required this.courses, required this.onNavigateToCourses});

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  final User? user = FirebaseAuth.instance.currentUser;
  final ProgressService _progressService = ProgressService();

  void _showQuizHistory(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    List<Map<String, dynamic>> results = [];
    for (var course in widget.courses) {
      final score = await _progressService.getQuizScore(course.id);
      if (score != null) {
        results.add({'course': course, 'score': score});
      }
    }

    if (context.mounted) Navigator.pop(context); // close loader

    if (!context.mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quiz History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                if (results.isEmpty)
                  const Text('You haven\'t taken any quizzes yet.',
                      style: TextStyle(color: AppTheme.textGrey))
                else
                  ...results.map((r) {
                    final Course course = r['course'];
                    final int score = r['score'];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.check_circle, color: AppTheme.success),
                      title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Text('Score: $score', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = user?.email ?? 'user@example.com';
    final name = email.split('@')[0];
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppTheme.primary,
              child: Text(
                letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(color: AppTheme.textGrey),
            ),
            const SizedBox(height: 32),
            _buildStatRow(),
            const SizedBox(height: 32),
            _buildMenuItem(
              icon: Icons.book_outlined,
              title: 'My Courses',
              onTap: widget.onNavigateToCourses,
            ),
            _buildMenuItem(
              icon: Icons.quiz_outlined,
              title: 'Quiz History',
              onTap: () => _showQuizHistory(context),
            ),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              icon: const Icon(Icons.logout, color: AppTheme.error),
              label: const Text(
                'Logout',
                style: TextStyle(color: AppTheme.error),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppTheme.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow() {
    final completed = widget.courses.where((c) => c.progress >= 1).length;
    final inProgress =
        widget.courses.where((c) => c.progress > 0 && c.progress < 1).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statItem(completed.toString(), 'Completed'),
        _statItem(inProgress.toString(), 'In Progress'),
        _statItem(widget.courses.length.toString(), 'Total'),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textGrey)),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
