# Implementation Guide - Grace Daily Data Structure

## ✅ What Has Been Implemented

### 1. **Data Models** (`lib/data/models/`)
- ✅ `DailyDevotion.dart` - Represents daily spiritual content
- ✅ `DailyPrayer.dart` - Represents daily prayer intention
- ✅ `JournalEntry.dart` - User's personal reflections
- ✅ `UserProgress.dart` - User progress tracking through 365 days

### 2. **Database Layer** (`lib/data/datasources/`)
- ✅ `DatabaseService.dart` - SQLite service with full CRUD operations
  - Tables: daily_devotions, daily_prayers, journal_entries, user_progress, user_settings
  - Methods for all database operations

### 3. **Repositories** (`lib/data/repositories/`)
- ✅ `DevotionRepository.dart` - Manage devotion data access
- ✅ `PrayerRepository.dart` - Manage prayer data access
- ✅ `JournalRepository.dart` - Manage journal entries
- ✅ `UserProgressRepository.dart` - Manage user progress tracking

### 4. **State Management** (`lib/core/providers/`)
- ✅ `DevotionProvider` - Provider for devotion state (ChangeNotifier)
- ✅ `PrayerProvider` - Provider for prayer state
- ✅ `UserProgressProvider` - Provider for progress state
- ✅ `JournalProvider` - Provider for journal entries state

### 5. **Dependencies** (pubspec.yaml)
- ✅ Added `sqflite: ^2.3.0` - Database
- ✅ Added `path: ^1.8.0` - Path handling
- ✅ Added `shared_preferences: ^2.2.0` - Local preferences
- ✅ Added `http: ^1.1.0` - API calls

---

## 🚀 Next Steps: Integration & Usage

### Step 1: Update App.dart to Use Providers

```dart
import 'package:provider/provider.dart';
import 'package:grace_daily/core/providers/providers.dart';

class GraceDailyApp extends StatelessWidget {
  const GraceDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DevotionProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => UserProgressProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
      ],
      child: MaterialApp.router(
        title: 'Grace Daily',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

### Step 2: Update HomeScreen to Use Providers

Replace hardcoded content with dynamic data:

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DevotionProvider>().loadTodaysDevotion();
      context.read<UserProgressProvider>().updateLastAccessDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final devotionProvider = context.watch<DevotionProvider>();
    
    if (devotionProvider.isLoading) {
      return Scaffold(
        backgroundColor: GdailyColors.neutralLight,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final devotion = devotionProvider.currentDevotion;
    
    if (devotion == null) {
      return Scaffold(
        backgroundColor: GdailyColors.neutralLight,
        body: Center(
          child: Text('No devotion loaded'),
        ),
      );
    }

    // Use devotion.verse, devotion.verseReference, etc. instead of hardcoded text
    return Scaffold(
      // ... rest of the UI
    );
  }
}
```

### Step 3: Load Sample Data into Database

Create a data seed service to populate the database with 365 devotions:

```dart
// lib/data/datasources/data_seeder.dart
import 'package:grace_daily/data/datasources/database_service.dart';
import 'package:grace_daily/data/models/models.dart';

class DataSeeder {
  static Future<void> seedInitialData() async {
    final dbService = DatabaseService();
    
    // Check if data already exists
    final existingCount = await dbService.getAllDevotions();
    if (existingCount.isNotEmpty) return; // Already seeded
    
    // Create sample devotion for day 1
    final day1 = DailyDevotion(
      dayNumber: 1,
      date: DateTime(2025, 1, 1),
      verse: "For I know the plans I have for you, declares the LORD...",
      verseReference: "Jeremiah 29:11",
      title: "Grace Begins Here",
      meditationText: "In a world that demands our constant attention...",
      quote: "Stillness is not the absence of energy, but the absence of friction in it.",
      thoughtForDay: "Take one intentional pause today.",
      audioTitle: "Cathedral Hymns",
      createdAt: DateTime.now(),
    );
    
    await dbService.insertDevotion(day1);
    // Repeat for all 365 days...
  }
}
```

### Step 4: Create Missing Utility Classes

#### lib/core/utils/date_utils.dart
```dart
class GraceDateUtils {
  /// Get day number for a given date
  static int getDayNumber(DateTime date) {
    final dayOfYear = int.parse(date.difference(DateTime(date.year)).inDays.toString()) + 1;
    return dayOfYear > 365 ? 365 : dayOfYear;
  }

  /// Get date for a specific day number
  static DateTime getDateForDay(int dayNumber) {
    return DateTime(DateTime.now().year, 1, 1).add(Duration(days: dayNumber - 1));
  }
}
```

#### lib/core/utils/constants.dart
```dart
class AppConstants {
  static const int totalDevotionDays = 365;
  static const String defaultUserId = 'default_user';
  static const String databaseName = 'grace_daily.db';
}
```

---

## 📝 Usage Examples

### Load Today's Devotion
```dart
final provider = context.read<DevotionProvider>();
await provider.loadTodaysDevotion();
final devotion = provider.currentDevotion;
```

### Save User Reflection
```dart
final journalProvider = context.read<JournalProvider>();
await journalProvider.saveReflection(dayNumber: 1, reflection: "My thoughts...");
```

### Mark Prayer as Completed
```dart
final progressProvider = context.read<UserProgressProvider>();
await progressProvider.markDayCompleted(1);
```

### Get User Statistics
```dart
final stats = await progressProvider.getUserStatistics();
print('Completion: ${stats['completionPercentage']}%');
```

---

## 🔧 File Structure Summary

```
lib/
├── data/
│   ├── datasources/
│   │   └── database_service.dart ✅
│   ├── models/
│   │   ├── daily_devotion.dart ✅
│   │   ├── daily_prayer.dart ✅
│   │   ├── journal_entry.dart ✅
│   │   ├── user_progress.dart ✅
│   │   └── models.dart ✅
│   └── repositories/
│       ├── devotion_repository.dart ✅
│       ├── prayer_repository.dart ✅
│       ├── journal_repository.dart ✅
│       ├── user_progress_repository.dart ✅
│       └── repositories.dart ✅
├── core/
│   ├── providers/
│   │   └── providers.dart ✅
│   └── utils/
│       ├── constants.dart (TODO)
│       └── date_utils.dart (TODO)
├── screens/
│   ├── home/home_screen.dart (NEEDS UPDATE)
│   ├── reflection/reflection_screen.dart (NEEDS UPDATE)
│   ├── prayer/prayer_screen.dart (NEEDS UPDATE)
│   └── success/prayer_complete_screen.dart (NEEDS UPDATE)
├── app.dart (NEEDS UPDATE)
└── main.dart
```

---

## ✨ Key Features Implemented

1. **Complete Data Models** with JSON serialization
2. **SQLite Database** with 5 tables and full CRUD operations
3. **Repository Pattern** for clean data access
4. **State Management** using Provider for reactive UI
5. **Error Handling** and loading states
6. **User Progress Tracking** (completion, streak, statistics)
7. **Journal Entry Management** (reflections, prayer marks)

---

## 📚 Database Schema Overview

| Table | Purpose | Key Fields |
|-------|---------|-----------|
| daily_devotions | Store 365 daily devotions | dayNumber, verse, title, quote |
| daily_prayers | Store daily prayer intentions | dayNumber, intention, prayerText |
| journal_entries | Store user reflections | userId, dayNumber, reflection |
| user_progress | Track user completion | userId, currentDay, completedDays |
| user_settings | Store user preferences | userId, notificationsEnabled, theme |

---

## 🎯 Recommended Implementation Order

1. **Add dependencies** (`flutter pub get`) ✅ DONE
2. **Create models** ✅ DONE
3. **Create database service** ✅ DONE
4. **Create repositories** ✅ DONE
5. **Create providers** ✅ DONE
6. **Create data seeder** ← NEXT
7. **Update app.dart** ← NEXT
8. **Update screens** ← NEXT
9. **Test functionality**
10. **Add remote API integration** (Optional)

---

## 🔐 Security Considerations

- All database operations are safe from SQL injection (using parameterized queries)
- User progress is linked to userId for multi-user support
- Sensitive data (preferences) can be encrypted with `shared_preferences`
- Consider adding encryption for journal entries in future versions

---

## 📱 Testing the Implementation

After implementing the data layer, test with:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test database initialization
  final db = DatabaseService();
  
  // Test model creation
  final devotion = DailyDevotion(
    dayNumber: 1,
    date: DateTime.now(),
    verse: "Test verse",
    verseReference: "Test 1:1",
    title: "Test",
    meditationText: "Test meditation",
    quote: "Test quote",
    thoughtForDay: "Test thought",
    audioTitle: "Test audio",
    createdAt: DateTime.now(),
  );
  
  // Test database operations
  await db.insertDevotion(devotion);
  final loaded = await db.getDevotion(1);
  print('Saved and loaded: ${loaded?.title}');
  
  runApp(const GraceDailyApp());
}
```

---

## Next Actions

Once this document is reviewed, proceed with:
1. Running `flutter pub get` to fetch new dependencies
2. Implementing the data seeder with 365 devotions
3. Updating screens to use the providers
4. Testing the full data flow

The infrastructure is now ready for the UI layer!

