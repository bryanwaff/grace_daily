# 🙏 Grace Daily

**A beautiful, spiritually nourishing mobile app** for daily devotions, reflections, and prayers.

Grace Daily is a cross-platform mobile application built with Flutter, designed to provide users with a consistent, calming, and spiritually enriching daily routine. The app delivers a 365-day journey of devotions, scripture, and prayers, centered around the theme of "Grace"—now with **professional state management, local persistence, and engagement tracking**.

---

## ✨ Features

### 🏠 Core Daily Flow
- **Home Screen**: Verse of the day with beautiful imagery
- **Reflection Screen**: Deep devotional content with meditation
- **Prayer Screen**: Interactive prayer with personal reflection journaling
- **Success Screen**: Motivational completion celebration

### 🆕 Phase 1 Enhancements
- **📊 Progress Dashboard**: Track streaks, completions, and statistics
- **🔥 Streak Tracking**: Automatic consecutive day counting
- **📖 Journal System**: Save personal reflections with timestamps
- **💾 Local Persistence**: SQLite database for reliable data storage
- **📈 User Statistics**: Monthly completion rates, all-time records
- **4-Tab Navigation**: Today | Reflection | Prayer | Progress

### 🎨 Design
- Elegant Newsreader + Manrope typography
- Soothing olive green color palette
- Responsive layouts for all devices
- Accessible, high-contrast design
- Material Design 3 compliance

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.11.1+
- Dart 3.11.1+
- iOS 12+ or Android 5.0+

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd grace_daily

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### First Run
On first launch, the app will:
1. Create SQLite database
2. Load 365 devotional verses
3. Initialize user progress tracker
4. Set up notification system (ready for activation)

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MultiProvider setup
├── config/
│   ├── app_router.dart         # GoRouter navigation
│   └── constants.dart
├── core/
│   ├── models/                 # Data classes
│   │   ├── verse.dart
│   │   ├── journal_entry.dart
│   │   └── user_progress.dart
│   ├── providers/              # State management
│   │   ├── devotion_provider.dart
│   │   ├── journal_provider.dart
│   │   └── user_progress_provider.dart
│   ├── services/
│   │   └── grace_daily_database.dart  # SQLite
│   ├── widgets/
│   │   └── bottom_nav_bar.dart
│   └── utils/
│       └── image_strings.dart
├── screens/
│   ├── home/
│   ├── reflection/
│   ├── prayer/
│   ├── success/
│   └── progress/               # NEW: Stats dashboard
├── theme/
│   ├── app_theme.dart
│   ├── gdaily_colors.dart
│   └── gdaily_typography.dart
└── assets/
    ├── fonts/
    │   ├── Newsreader-*.ttf
    │   └── Manrope-*.ttf
    └── images/
```

---

## 🎯 How It Works

### Daily Devotion Flow
```
1. Home Screen        → View today's verse
2. Reflection        → Read full meditation
3. Prayer            → Pray & journal your thoughts
4. Success           → Celebrate completion
5. Progress Screen   → See your streak & statistics
```

### Data Architecture
```
UI Screens (Flutter)
    ↓
State Management (Provider)
    ↓
Database Service (SQLite)
    ↓
Local Persistence (grace_daily.db)
```

---

## 📚 Documentation

| Document | Content |
|----------|---------|
| **[ADVANCEMENT_COMPLETE.md](ADVANCEMENT_COMPLETE.md)** | Full summary of Phase 1 |
| **[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)** | How to use new features |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | System design & data flow |
| **[ROADMAP.md](ROADMAP.md)** | Planned features (Phase 2+) |

---

## 🔧 Technologies

### Core
- **Flutter**: UI framework
- **Dart**: Programming language
- **Provider**: State management
- **GoRouter**: Navigation

### Data & Persistence
- **sqflite**: Local SQLite database
- **intl**: Date formatting utilities

### Future-Ready
- **flutter_local_notifications**: For reminders
- Firebase integration ready
- Backend API integration path defined

---

## 📊 Database

### Three Main Tables
1. **verses** - 365 daily devotions
2. **journal_entries** - User reflections and prayers
3. **user_progress** - Streaks and completion tracking

All data stored locally on device for privacy and offline access.

---

## 🎨 Customization

### Change Theme Colors
Edit `lib/theme/gdaily_colors.dart`

### Modify Typography
Edit `lib/theme/gdaily_typography.dart`

### Add Custom Verses
Expand verse list in `devotion_provider.dart`

---

## 📱 Testing

Test the complete feature set:

```bash
# Install and run
flutter run

# Then:
1. Complete a daily devotion
2. Write a personal reflection
3. View your updated streak
4. Close and reopen app
5. Verify data persists
```

---

## 🚀 What's Next?

### Planned Features (Phase 2+)
- 🔔 **Daily Notifications**: Customizable reminders
- 📤 **Share Functionality**: Social media sharing
- 💾 **Bookmarks**: Save favorite verses
- 🌙 **Dark Mode**: Eye-friendly night reading
- ☁️ **Cloud Sync**: Cross-device synchronization
- 🗣️ **Voice Narration**: Audio devotions

See [ROADMAP.md](ROADMAP.md) for detailed feature timeline.

---

## 🤝 Contributing

We welcome contributions! Areas for help:
- Expanding verse library (target: 365 unique verses)
- UI/UX improvements
- Performance optimization
- Bug fixes and testing
- Documentation

---

## 📄 License

This project is private and not currently licensed for public use.

---

## 👥 Contact & Support

For questions, suggestions, or issues:
1. Check the documentation files
2. Review [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
3. See [ROADMAP.md](ROADMAP.md) for planned features

---

## 🙏 Acknowledgments

- Design system: Lumen Grace
- Fonts: Newsreader & Manrope from Google Fonts
- Inspiration: Daily spiritual reflection practices

---

**Grace Daily - A space for daily spiritual growth and reflection.**
