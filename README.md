# 📱 Internee.pk Learning App

<p align="center">
  <img src="assets/images/logo.png" alt="Internee.pk Logo" width="120"/>
</p>

<p align="center">
  <b>A modern Flutter-based Learning Management System (LMS) for Internee.pk</b><br/>
  Browse courses · Watch lectures · Attempt quizzes · Track your progress
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Status-Complete-10B981" />
</p>

---

## 🎯 About This Project

This app was built as an internship task for **Internee.pk** — a platform that provides hands-on internship and learning experiences for students and graduates. The app serves as a full-featured **Learning Management System (LMS)** where users can register, browse courses, watch video lectures, and test their knowledge through quizzes.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 **Authentication** | Email/Password Sign Up & Login via Firebase Auth |
| 📚 **Course Catalog** | 4 courses with thumbnail images and category tags |
| 🎬 **Video Lectures** | 7 lectures per course, streamed from YouTube |
| ✅ **Progress Tracking** | Per-user lecture completion saved locally |
| 📊 **Smart Progress Bar** | Reaches 100% only after quiz is attempted |
| 🧠 **Course Quizzes** | Multiple-choice quiz per course with result screen |
| 📋 **Quiz History** | View all past quiz scores from the Profile tab |
| 👤 **Live User Profile** | Shows real email/name from Firebase + stats |
| 🌙 **Internee.pk Theme** | Dark Navy + Vibrant Green brand palette |
| 📱 **Responsive UI** | Handles overflow, adapts to all screen sizes |

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| **Flutter** | UI Framework |
| **Dart** | Programming Language |
| **Firebase Auth** | User authentication |
| **YouTube Player iFrame** | In-app lecture streaming |
| **Shared Preferences** | Local progress persistence (per-user, by UID) |
| **Google Fonts** | Poppins typeface |

---

## 📁 Project Structure

```
internee_app/
├── lib/
│   ├── main.dart                  # App entry + Firebase init + auth routing
│   ├── models/
│   │   ├── course.dart            # Course model with smart progress logic
│   │   ├── lecture.dart           # Lecture model with courseId
│   │   └── quiz_question.dart     # Quiz question model with courseId
│   ├── screens/
│   │   ├── splash_screen.dart     # Animated splash with logo
│   │   ├── login_screen.dart      # Firebase login screen
│   │   ├── signup_screen.dart     # Firebase signup screen
│   │   ├── home_screen.dart       # Main screen (Home / Courses / Profile tabs)
│   │   ├── course_details_screen.dart  # Course overview + progress
│   │   ├── lecture_list_screen.dart    # Course-filtered lecture list
│   │   ├── video_screen.dart      # YouTube player + mark complete UI
│   │   ├── quiz_screen.dart       # Interactive quiz player
│   │   └── quiz_result_screen.dart     # Score & percentage result
│   ├── services/
│   │   ├── auth_service.dart      # Firebase auth wrapper
│   │   └── progress_service.dart  # Per-user progress & quiz score storage
│   ├── utils/
│   │   ├── app_theme.dart         # Internee.pk brand colors & theme
│   │   ├── app_routes.dart        # Named route definitions
│   │   └── dummy_data.dart        # Structured course/lecture/quiz data
│   └── widgets/
│       └── course_card.dart       # Reusable course card with progress
└── assets/
    └── images/                    # Course thumbnails + logo
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.11.4`
- [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
- A Firebase project with **Email/Password** authentication enabled

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/Faisal-Haroon/Internee-LMS.git
cd Internee-LMS
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Firebase Setup**

- Go to [Firebase Console](https://console.firebase.google.com/) and create a project
- Enable **Email/Password** under Authentication → Sign-in methods
- Download `google-services.json` and place it in `android/app/`
- Make sure `lib/firebase_options.dart` is generated via:
  ```bash
  flutterfire configure
  ```

**4. Run the app**
```bash
flutter run
```

---

## 📸 App Screens

| Splash | Login | Home |
|:---:|:---:|:---:|
| _Animated logo with brand gradient_ | _Centered logo, email/password form_ | _Progress banner + course cards_ |

| Course Details | Video Lecture | Quiz |
|:---:|:---:|:---:|
| _Progress bar, instructor info, actions_ | _YouTube player + premium complete UI_ | _Multiple choice with animated feedback_ |

---

## 🧠 Design Decisions

### Progress Logic
- Progress is calculated dynamically from completed lectures
- If all lectures are watched but quiz is not attempted → progress caps at **95%**
- Taking the quiz unlocks full **100%** completion

### Per-User Data Isolation
- All progress & quiz scores are keyed by `FirebaseAuth.currentUser.uid`
- Logging in as a different user starts with a fresh slate — no data leakage between accounts

### Architecture
- Stateful widgets for reactive UI updates (no Provider/Bloc needed at this scale)
- `ProgressService` wraps `SharedPreferences` with UID-scoped keys
- Structured `dummy_data.dart` is designed to be **easily replaced** with a real REST API

---

## 🔮 Future Improvements

- [ ] Connect to Internee.pk live REST API
- [ ] Certificate generation upon 100% course completion
- [ ] Dark mode toggle
- [ ] Downloadable lecture notes / resources
- [ ] Push notifications for course reminders
- [ ] Admin panel for managing courses

---

## 👤 Author

**Faisal Haroon**  
Internee @ Internee.pk  
GitHub: [@Faisal-Haroon](https://github.com/Faisal-Haroon)

---

## 📄 License

This project was built as an internship task for **Internee.pk**.  


---

