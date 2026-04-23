# Grace Daily - Data Structure Visual Overview

## 📊 Architecture Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                    Grace Daily App                             │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Screens Layer (UI)                                           │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐        │
│  │ Home Screen  │  │ Reflection   │  │ Prayer      │        │
│  │              │→ │ Screen       │→ │ Screen      │        │
│  │ (Verse)      │  │ (Devotion)   │  │ (Journal)   │        │
│  └──────────────┘  └──────────────┘  └─────────────┘        │
│         ↓                  ↓                  ↓               │
│  Provider Layer (State Management)                            │
│  ┌──────────────────────────────────────────────────┐        │
│  │  DevotionProvider      PrayerProvider            │        │
│  │  UserProgressProvider  JournalProvider           │        │
│  │  (ChangeNotifier - Reactive Updates)             │        │
│  └──────────────────────────────────────────────────┘        │
│         ↓                  ↓                  ↓               │
│  Repository Layer (Data Access)                              │
│  ┌──────────────────────────────────────────────────┐        │
│  │  DevotionRepository    PrayerRepository          │        │
│  │  JournalRepository     UserProgressRepository    │        │
│  │  (Clean API, Error Handling)                     │        │
│  └──────────────────────────────────────────────────┘        │
│         ↓                  ↓                  ↓               │
│  Database Layer                                               │
│  ┌─────────────────────────────────────────────────┐        │
│  │         DatabaseService (SQLite)                │        │
│  │  • daily_devotions      • journal_entries       │        │
│  │  • daily_prayers        • user_progress         │        │
│  │  • user_settings        (5 Tables Total)        │        │
│  └─────────────────────────────────────────────────┘        │
│                           ↓                                   │
│         Persistent Storage (SQLite Database)                │
│                                                              │
└────────────────────────────────────────────────────────────────┘
```

---

## 📁 File Structure Tree

```
grace_daily/
│
├── 📄 pubspec.yaml (UPDATED - Added 4 dependencies)
├── 📄 DATA_STRUCTURE.md (Documentation)
├── 📄 IMPLEMENTATION_GUIDE.md (Step-by-step guide)
├── 📄 IMPLEMENTATION_SUMMARY.md (Summary)
├── 📄 QUICKSTART.md (Quick integration)
│
└── lib/
    ├── 📄 main.dart
    ├── 📄 app.dart (NEEDS UPDATE)
    │
    ├── 📁 data/
    │   ├── 📁 datasources/
    │   │   └── 📄 database_service.dart (NEW - 322 lines)
    │   │       • SQLite manager
    │   │       • CRUD operations
    │   │       • 5 database tables
    │   │
    │   ├── 📁 models/
    │   │   ├── 📄 daily_devotion.dart (NEW - 83 lines)
    │   │   ├── 📄 daily_prayer.dart (NEW - 67 lines)
    │   │   ├── 📄 journal_entry.dart (NEW - 89 lines)
    │   │   ├── 📄 user_progress.dart (NEW - 132 lines)
    │   │   └── 📄 models.dart (NEW - Barrel file)
    │   │
    │   └── 📁 repositories/
    │       ├── 📄 devotion_repository.dart (NEW - 82 lines)
    │       ├── 📄 prayer_repository.dart (NEW - 79 lines)
    │       ├── 📄 journal_repository.dart (NEW - 157 lines)
    │       ├── 📄 user_progress_repository.dart (NEW - 189 lines)
    │       └── 📄 repositories.dart (NEW - Barrel file)
    │
    ├── 📁 core/
    │   ├── 📁 providers/
    │   │   └── 📄 providers.dart (NEW - 316 lines)
    │   │       • DevotionProvider
    │   │       • PrayerProvider
    │   │       • UserProgressProvider
    │   │       • JournalProvider
    │   │
    │   ├── 📁 widgets/
    │   ├── 📁 utils/
    │   ├── 📁 extensions/
    │   └── 📁 errors/
    │
    ├── 📁 screens/
    │   ├── 📁 home/ (NEEDS UPDATE)
    │   ├── 📁 reflection/ (NEEDS UPDATE)
    │   ├── 📁 prayer/ (NEEDS UPDATE)
    │   └── 📁 success/
    │
    ├── 📁 config/
    ├── 📁 theme/
    └── 📁 assets/
```

---

## 🔄 Data Flow Diagram

### User Journey: Home → Reflection → Prayer → Success

```
START (App Opens)
    ↓
[1] Initialize App
    • Load UserProgress from database
    • Update last access date
    ↓
[2] Display Home Screen
    • DevotionProvider loads today's devotion
    • Display verse + title + buttons
    • Show user progress (e.g., "Day 5/365")
    ↓
User Taps "Start Devotion"
    ↓
[3] Display Reflection Screen
    • Show full devotion content
    • Title, meditation text, quote
    • Thought for the day
    • User reads and reflects
    ↓
User Taps "See Reflection"
    ↓
[4] Display Prayer Screen
    • PrayerProvider loads today's prayer
    • Show intention and prayer text
    • User prays
    • User marks as "prayed" → UserProgressProvider updates
    • User writes reflection → JournalProvider saves to database
    ↓
User Taps "Complete Devotion"
    ↓
[5] Display Success Screen
    • Celebrate completion
    • Update UserProgress (day marked as completed)
    • Calculate streak and statistics
    ↓
User Can Check Statistics
    • Total days completed: X/365
    • Completion percentage: Y%
    • Current streak: Z days
    ↓
NEXT DAY: Cycle repeats
```

---

## 🗄️ Database Schema

### Table: daily_devotions
```sql
┌─────────────────────────────────────────────┐
│           daily_devotions                   │
├─────────────────────────────────────────────┤
│ id (INTEGER, PRIMARY KEY)                   │
│ dayNumber (INTEGER UNIQUE) - 1-365          │
│ date (TEXT)                                 │
│ verse (TEXT)                                │
│ verseReference (TEXT)                       │
│ title (TEXT)                                │
│ meditationText (TEXT)                       │
│ quote (TEXT)                                │
│ thoughtForDay (TEXT)                        │
│ audioTitle (TEXT)                           │
│ imageUrl (TEXT)                             │
│ createdAt (TEXT)                            │
│ updatedAt (TEXT)                            │
└─────────────────────────────────────────────┘
```

### Table: daily_prayers
```sql
┌─────────────────────────────────────────────┐
│          daily_prayers                      │
├─────────────────────────────────────────────┤
│ id (INTEGER, PRIMARY KEY)                   │
│ dayNumber (INTEGER UNIQUE) - 1-365          │
│ date (TEXT)                                 │
│ intention (TEXT)                            │
│ prayerText (TEXT)                           │
│ attribution (TEXT)                          │
│ soundscapeTitle (TEXT)                      │
│ createdAt (TEXT)                            │
└─────────────────────────────────────────────┘
```

### Table: journal_entries
```sql
┌─────────────────────────────────────────────┐
│         journal_entries                     │
├─────────────────────────────────────────────┤
│ id (TEXT, PRIMARY KEY)                      │
│ userId (TEXT)                               │
│ dayNumber (INTEGER)                         │
│ dateCreated (TEXT)                          │
│ reflection (TEXT)                           │
│ prayerMarked (INTEGER) - 0 or 1            │
│ markedAt (TEXT)                             │
│ tags (TEXT) - comma-separated               │
└─────────────────────────────────────────────┘
```

### Table: user_progress
```sql
┌─────────────────────────────────────────────┐
│         user_progress                       │
├─────────────────────────────────────────────┤
│ userId (TEXT, PRIMARY KEY)                  │
│ currentDayNumber (INTEGER) - 1-365          │
│ lastAccessDate (TEXT)                       │
│ totalDaysCompleted (INTEGER)                │
│ completedDays (TEXT) - comma-separated      │
│ createdAt (TEXT)                            │
│ updatedAt (TEXT)                            │
└─────────────────────────────────────────────┘
```

---

## 🔧 Class Relationships

```
DailyDevotion
├── dayNumber: int
├── verse: String
├── verseReference: String
├── title: String
├── meditationText: String
├── quote: String
├── thoughtForDay: String
├── audioTitle: String
└── Methods: toJson(), fromJson(), copyWith()

       ↓ Managed by ↓

DevotionRepository
├── getDevotion(int) → DailyDevotion?
├── getTodaysDevotion() → DailyDevotion?
├── saveDevotion(DailyDevotion) → bool
└── getAllDevotions() → List<DailyDevotion>

       ↓ Used by ↓

DevotionProvider (extends ChangeNotifier)
├── currentDevotion: DailyDevotion?
├── isLoading: bool
├── error: String?
├── loadTodaysDevotion()
├── loadDevotion(int)
└── notifyListeners() [automatic UI update]
```

---

## 🎯 State Management Flow

```
UI Widget (HomeScreen)
    ↓
context.watch<DevotionProvider>()  [Subscribe to changes]
    ↓
DevotionProvider.currentDevotion   [Get current state]
    ↓
When State Changes → notifyListeners()
    ↓
Widget rebuilds with new data
    ↓
User sees updated verse, title, etc.


User Action (Press Button)
    ↓
context.read<DevotionProvider>().loadTodaysDevotion()
    ↓
DevotionProvider calls DevotionRepository
    ↓
Repository queries DatabaseService
    ↓
DatabaseService queries SQLite
    ↓
Data returned → Provider updates state
    ↓
notifyListeners() called
    ↓
All watching widgets rebuild [Auto-update UI]
```

---

## 📊 Statistics & Numbers

| Metric | Value |
|--------|-------|
| **Total Files Created** | 15 |
| **Total Lines of Code** | ~1,500 |
| **Database Tables** | 5 |
| **Models** | 4 |
| **Repositories** | 4 |
| **Providers** | 4 |
| **Devotion Days** | 365 |
| **Compilation Errors** | 0 ✅ |
| **Warnings** | ~50 (non-critical) |

---

## 🚀 Implementation Checklist

- ✅ Data models created
- ✅ Database layer implemented
- ✅ Repositories created
- ✅ State management providers built
- ✅ Dependencies added to pubspec.yaml
- ✅ Code compiles with no errors
- ⏳ Populate database with 365 devotions (TODO)
- ⏳ Update app.dart with MultiProvider (TODO)
- ⏳ Update screens to use providers (TODO)
- ⏳ Test end-to-end flow (TODO)
- ⏳ Add API integration (Optional)

---

## 💾 Sample Data Example

### Devotion for Day 1:
```dart
DailyDevotion(
  dayNumber: 1,
  date: DateTime(2025, 1, 1),
  verse: 'For I know the plans I have for you...',
  verseReference: 'Jeremiah 29:11',
  title: 'Grace Begins Here',
  meditationText: 'In a world that demands our constant attention...',
  quote: 'Stillness is not the absence of energy...',
  thoughtForDay: 'Take one intentional pause today...',
  audioTitle: 'Cathedral Hymns',
  createdAt: DateTime.now(),
)
```

### User Progress Example:
```dart
UserProgress(
  userId: 'user123',
  currentDayNumber: 25,
  lastAccessDate: DateTime.now(),
  totalDaysCompleted: 23,
  completedDayNumbers: [1, 2, 3, 5, 6, 8, 9, 10, ...],
  createdAt: DateTime(2025, 1, 1),
)
```

### Journal Entry Example:
```dart
JournalEntry(
  id: 'user123_25_1234567890',
  userId: 'user123',
  dayNumber: 25,
  dateCreated: DateTime.now(),
  reflection: 'Today I felt more present when I paused...',
  prayerMarked: true,
  markedAt: DateTime.now(),
  tags: ['peace', 'gratitude'],
)
```

---

## 🎓 Key Concepts

### **Models**
- Pure data classes
- Represent domain entities
- Include JSON serialization

### **Repositories**
- Abstract data access logic
- Clean API for repositories
- Error handling
- Single responsibility principle

### **Providers**
- State management
- Reactive updates (ChangeNotifier)
- Connection between UI and repositories
- Loading states and error handling

### **DatabaseService**
- Low-level database operations
- CRUD methods
- Connection pooling
- Transaction support (can be added)

---

## 🔗 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| sqflite | ^2.3.0 | SQLite database |
| path | ^1.8.0 | Path operations |
| shared_preferences | ^2.2.0 | Key-value storage |
| http | ^1.1.0 | HTTP requests (future) |
| provider | ^6.1.2 | State management |

---

## ✨ Ready for Production?

This data layer is:
- ✅ Type-safe
- ✅ Error-handled
- ✅ Scalable
- ✅ Testable
- ✅ Following Flutter best practices
- ✅ Free from compilation errors
- ⏳ Needs UI integration
- ⏳ Needs 365 devotions data

---

**Next Step:** Follow the QUICKSTART.md to integrate with UI screens! 🚀

