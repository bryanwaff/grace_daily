# Quick Start Guide - Grace Daily Data Structure

## Installation & Setup (5 minutes)

### Step 1: Get Dependencies
```bash
cd /home/waff/AndroidStudioProjects/grace_daily
flutter pub get
```

### Step 2: Update pubspec.yaml Check
Verify these dependencies are added:
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.0
  shared_preferences: ^2.2.0
  http: ^1.1.0
  provider: ^6.1.2  # Already present
```

---

## Integration (Step by Step)

### Step 1: Update app.dart
Replace your current `app.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grace_daily/config/app_router.dart';
import 'package:grace_daily/theme/app_theme.dart';
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

### Step 2: Populate Database with Data

Create a new file: `lib/data/datasources/data_seeder.dart`

```dart
import 'package:grace_daily/data/datasources/database_service.dart';
import 'package:grace_daily/data/models/models.dart';

class DataSeeder {
  static Future<void> seedInitialData() async {
    final dbService = DatabaseService();
    
    // Check if already seeded
    final count = await dbService.getAllDevotions();
    if (count.isNotEmpty) return;
    
    // Sample Devotion Day 1
    final devotions = [
      DailyDevotion(
        dayNumber: 1,
        date: DateTime(2025, 1, 1),
        verse: 'For I know the plans I have for you, declares the LORD, plans to prosper you and not to harm you, plans to give you hope and a future.',
        verseReference: 'Jeremiah 29:11',
        title: 'Grace Begins Here',
        meditationText: 'In a world that demands our constant attention, stillness feels almost rebellious. We are conditioned to equate productivity with worth, yet the most profound growth happens in quiet spaces.',
        quote: 'Stillness is not the absence of energy, but the absence of friction in it.',
        thoughtForDay: 'Take one intentional pause today. Notice what happens when you resist the urge to fill the silence.',
        audioTitle: 'Cathedral Hymns',
        createdAt: DateTime.now(),
      ),
      // Add 364 more devotions here...
      // For MVP, you can create a loop or import from JSON
    ];
    
    await dbService.insertDevotions(devotions);
  }
}
```

Call in main.dart:
```dart
import 'package:grace_daily/data/datasources/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataSeeder.seedInitialData();
  runApp(const GraceDailyApp());
}
```

### Step 3: Update HomeScreen

Replace content with provider data:

```dart
import 'package:provider/provider.dart';
import 'package:grace_daily/core/providers/providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load today's devotion and update progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DevotionProvider>().loadTodaysDevotion();
      context.read<UserProgressProvider>().updateLastAccessDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GdailyColors.neutralLight,
      body: SafeArea(
        child: Column(
          children: [
            // ... top bar code ...
            Expanded(
              child: Consumer<DevotionProvider>(
                builder: (context, devotionProvider, _) {
                  if (devotionProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (devotionProvider.currentDevotion == null) {
                    return const Center(child: Text('No devotion loaded'));
                  }
                  
                  final devotion = devotionProvider.currentDevotion!;
                  
                  return Stack(
                    // ... existing Stack UI ...
                    children: [
                      // ... background image ...
                      Positioned(
                        top: 160,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // ... VERSE OF THE DAY header ...
                                  Text(
                                    devotion.verse,
                                    style: GdailyTypography.lightTextTheme.headlineSmall?.copyWith(
                                      fontFamily: 'Newsreader',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    devotion.verseReference,
                                    style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                                      color: GdailyColors.primaryOlive,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => context.go('/home/reflection'),
                                    // ... button styling ...
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            BottomNavBar(currentRoute: 'home'),
          ],
        ),
      ),
    );
  }
}
```

### Step 4: Update ReflectionScreen

```dart
// In initState
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<DevotionProvider>().loadTodaysDevotion();
  });
}

// In build, use Consumer to get devotion
Consumer<DevotionProvider>(
  builder: (context, provider, _) {
    final devotion = provider.currentDevotion;
    return Text(devotion?.verse ?? 'Loading...');
  },
)
```

### Step 5: Update PrayerScreen

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<PrayerProvider>().loadTodaysPrayer();
  });
}

// When marking prayer as completed
ElevatedButton.icon(
  onPressed: () {
    setState(() => _marked = !_marked);
    if (_marked) {
      context.read<UserProgressProvider>().markDayCompleted(1);
    }
  },
  // ...
)

// When saving reflection
OutlinedButton(
  onPressed: () {
    context.read<JournalProvider>()
        .saveReflection(1, _reflectionController.text);
  },
  // ...
)
```

---

## Testing the Data Layer

### Test in Terminal
```bash
cd /home/waff/AndroidStudioProjects/grace_daily
flutter test
```

### Quick Manual Test
Add this to main.dart temporarily:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test database
  final db = DatabaseService();
  print('Database initialized');
  
  // Test model
  final devotion = DailyDevotion(
    dayNumber: 1,
    date: DateTime.now(),
    verse: "Test",
    verseReference: "Test 1:1",
    title: "Test",
    meditationText: "Test",
    quote: "Test",
    thoughtForDay: "Test",
    audioTitle: "Test",
    createdAt: DateTime.now(),
  );
  
  await db.insertDevotion(devotion);
  final loaded = await db.getDevotion(1);
  print('Saved and loaded: ${loaded?.title}');
  
  runApp(const GraceDailyApp());
}
```

---

## File Structure After Integration

```
lib/
├── app.dart                    ← UPDATED
├── main.dart                   ← UPDATED
├── data/
│   ├── datasources/
│   │   ├── database_service.dart
│   │   └── data_seeder.dart   ← NEW (create this)
│   ├── models/
│   │   ├── daily_devotion.dart
│   │   ├── daily_prayer.dart
│   │   ├── journal_entry.dart
│   │   ├── user_progress.dart
│   │   └── models.dart
│   └── repositories/
│       ├── devotion_repository.dart
│       ├── prayer_repository.dart
│       ├── journal_repository.dart
│       ├── user_progress_repository.dart
│       └── repositories.dart
├── core/
│   └── providers/
│       └── providers.dart
└── screens/
    ├── home/home_screen.dart      ← UPDATED
    ├── reflection/reflection_screen.dart  ← UPDATED
    ├── prayer/prayer_screen.dart   ← UPDATED
    └── success/prayer_complete_screen.dart ← UPDATED
```

---

## Common Operations

### Load Today's Devotion
```dart
await context.read<DevotionProvider>().loadTodaysDevotion();
final devotion = context.watch<DevotionProvider>().currentDevotion;
```

### Save User Reflection
```dart
await context.read<JournalProvider>().saveReflection(dayNumber, text);
```

### Mark Prayer Complete
```dart
await context.read<UserProgressProvider>().markDayCompleted(dayNumber);
```

### Get User Statistics
```dart
final stats = await context.read<UserProgressProvider>().getUserStatistics();
print('Completed: ${stats['totalCompleted']}/365');
```

---

## Troubleshooting

### Error: "DatabaseService not found"
Make sure to run `flutter pub get`

### Error: "Provider not found"
Ensure `MultiProvider` is in app.dart with all 4 providers

### No data displaying
Make sure `DataSeeder.seedInitialData()` was called in main()

### Build errors
Run: `flutter clean && flutter pub get && flutter pub upgrade`

---

## Next Phase

Once this is working:
1. ✅ Create 365 devotions and prayers
2. ✅ Test end-to-end flow
3. ✅ Add API integration for remote sync (optional)
4. ✅ Add notification support
5. ✅ Add sharing features

---

## Support Files

All created files are documented in:
- **DATA_STRUCTURE.md** - Architecture overview
- **IMPLEMENTATION_GUIDE.md** - Detailed integration guide
- **IMPLEMENTATION_SUMMARY.md** - Complete summary

Good luck! 🎉

