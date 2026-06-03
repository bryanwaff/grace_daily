# Grace Daily - Architecture Overview

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      FLUTTER APP                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              GraceDailyApp (main.dart)              │  │
│  │  • MultiProvider setup                              │  │
│  │  • MaterialApp.router configuration                │  │
│  │  • Theme application                               │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
        ┌──────────────────────────────────────────┐
        │       STATE MANAGEMENT LAYER             │
        │           (Provider)                     │
        ├──────────────────────────────────────────┤
        │ DevotionProvider                         │
        │ ├─ currentVerse                         │
        │ ├─ allVerses[]                          │
        │ └─ toggleBookmark()                     │
        ├──────────────────────────────────────────┤
        │ JournalProvider                          │
        │ ├─ allEntries[]                         │
        │ ├─ entriesByVerse{}                     │
        │ ├─ saveEntry()                          │
        │ ├─ updateEntry()                        │
        │ └─ deleteEntry()                        │
        ├──────────────────────────────────────────┤
        │ UserProgressProvider                     │
        │ ├─ currentStreak                        │
        │ ├─ longestStreak                        │
        │ ├─ totalCompletions                     │
        │ └─ completeDevotionToday()              │
        └──────────────────────────────────────────┘
                           ↓
        ┌──────────────────────────────────────────┐
        │      DATA ACCESS LAYER                   │
        │   (GraceDailyDatabase)                   │
        ├──────────────────────────────────────────┤
        │ Verses Operations:                       │
        │ • getVerseById()                         │
        │ • getAllVerses()                         │
        │ • toggleBookmark()                       │
        ├──────────────────────────────────────────┤
        │ Journal Operations:                      │
        │ • insertJournalEntry()                   │
        │ • getJournalEntriesByVerseId()          │
        │ • deleteJournalEntry()                   │
        ├──────────────────────────────────────────┤
        │ Progress Operations:                     │
        │ • getUserProgress()                      │
        │ • updateUserProgress()                   │
        └──────────────────────────────────────────┘
                           ↓
        ┌──────────────────────────────────────────┐
        │      PERSISTENCE LAYER                   │
        │       (SQLite via sqflite)               │
        ├──────────────────────────────────────────┤
        │ Database: grace_daily.db                 │
        │ ├─ verses                                │
        │ ├─ journal_entries                       │
        │ └─ user_progress                         │
        └──────────────────────────────────────────┘
```

---

## 📱 Screen Architecture

```
┌────────────────────────────────────────────────────────┐
│ HOME SCREEN (HomeScreen)                               │
├────────────────────────────────────────────────────────┤
│ - Reads: DevotionProvider.currentVerse                 │
│ - Button: "Start Devotion" → /home/reflection          │
│ - Shows: Today's verse, reference, meditation preview  │
└────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────┐
│ REFLECTION SCREEN (ReflectionScreen)                   │
├────────────────────────────────────────────────────────┤
│ - Reads: DevotionProvider.currentVerse                 │
│ - Shows: Full devotion content, meditation, quote      │
│ - Button: "See Reflection" → /home/prayer              │
└────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────┐
│ PRAYER SCREEN (PrayerScreen)                           │
├────────────────────────────────────────────────────────┤
│ - Reads: DevotionProvider, JournalProvider             │
│ - Writes:                                              │
│   • JournalProvider.saveEntry() [onClick Save]         │
│   • UserProgressProvider.completeDevotionToday()       │
│ - TextFields: Personal reflection input                │
│ - Buttons:                                             │
│   • "Mark as Prayed"                                   │
│   • "Save to Journal" → saves to DB                    │
│   • "Complete Devotion" → /home/success                │
└────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────┐
│ SUCCESS SCREEN (PrayerCompleteScreen)                  │
├────────────────────────────────────────────────────────┤
│ - Shows: Congratulations, verse, encouragement         │
│ - Buttons:                                             │
│   • "Return Home" → /home                              │
│   • "View Progress" → /home/progress                   │
└────────────────────────────────────────────────────────┘
                          ↓
┌────────────────────────────────────────────────────────┐
│ PROGRESS SCREEN (ProgressScreen) ⭐ NEW               │
├────────────────────────────────────────────────────────┤
│ - Reads: UserProgressProvider, JournalProvider         │
│ - Displays:                                            │
│   • Current streak (with today indicator)              │
│   • Statistics: Completions, Longest Streak            │
│   • Recent journal entries (last 5)                    │
│ - Updated when user completes devotion                 │
└────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Diagram

### Initialization Flow
```
App Launch
  ↓
main() calls runApp(GraceDailyApp())
  ↓
GraceDailyApp builds MultiProvider
  ↓
┌─────────────────────────────────┐
│ Three providers initialize:      │
│                                 │
│ 1. DevotionProvider             │
│    → initializeDevotions()       │
│    → Opens DB, loads/creates     │
│       365 verses                 │
│                                 │
│ 2. JournalProvider              │
│    → loadAllEntries()            │
│    → Fetches all user entries    │
│                                 │
│ 3. UserProgressProvider         │
│    → initializeProgress()        │
│    → Loads user stats/streaks    │
└─────────────────────────────────┘
  ↓
HomeScreen renders with loaded data
  ↓
App ready for user interaction
```

### Completion Flow
```
Prayer Screen - User Action Sequence:
  1. User types reflection in TextField
  2. User marks prayer (checkbox)
  3. User clicks "Complete Devotion"
     ↓
  4. _completeDevotion() called
     ├─ Check if reflection text exists
     ├─ Call JournalProvider.saveEntry()
     │  └─ Database: INSERT INTO journal_entries
     ├─ Call UserProgressProvider.completeDevotionToday()
     │  ├─ Check if already completed today
     │  ├─ Update streak calculation
     │  ├─ Update completion map
     │  └─ Database: UPDATE user_progress
     └─ context.go('/home/success')
     
  5. Success screen shows
     ↓
  6. User navigates to Progress screen
     ├─ UserProgressProvider notifies listeners
     ├─ Progress screen rebuilds
     └─ Shows updated streak, completions, and new entry
```

### Widget Rebuilding
```
┌─────────────────────────────────────────────────┐
│ When data changes in Provider:                  │
├─────────────────────────────────────────────────┤
│                                                 │
│ Event: JournalProvider.saveEntry()              │
│   ↓                                             │
│ _db.insertJournalEntry()  [Database write]     │
│   ↓                                             │
│ _allEntries.insert(0, entry)  [Update state]   │
│   ↓                                             │
│ notifyListeners()  [Notify subscribers]         │
│   ↓                                             │
│ All Consumer<JournalProvider> widgets rebuild   │
│   ↓                                             │
│ UI updates automatically ✨                     │
└─────────────────────────────────────────────────┘
```

---

## 📊 Data Model Relationships

```
┌──────────────┐
│    Verse     │
├──────────────┤
│ id ━━━━━━┓  │
│ text     │  │
│ reference│  │
│ title    │  │
│ ...      │  │
│ bookmark │  │
└──────────┘  │
               │  one-to-many
               │
               ↓
┌─────────────────────────┐
│   JournalEntry          │
├─────────────────────────┤
│ id                    │ │
│ verseId ←─────────────┘ │
│ content                 │
│ createdAt               │
│ isPrayed                │
└─────────────────────────┘

┌──────────────────────┐
│   UserProgress       │
├──────────────────────┤
│ id (always 1)        │
│ currentStreak        │
│ longestStreak        │
│ totalCompletions     │
│ lastCompletionDate   │
│ joinDate             │
│ completionMap        │
│ (date→bool encoded)  │
└──────────────────────┘
```

---

## 🧩 Component Interaction Map

```
                        ┌────────────────────┐
                        │   AppRouter        │
                        │ (go_router config) │
                        └────────────────────┘
                               ↑
                               │
                 ┌─────────────┼─────────────┐
                 ↓             ↓             ↓
            ┌────────┐  ┌────────────┐  ┌─────────┐
            │HomeScreen      PrayerScreen    ProgressScreen
            │                   │
            │                   │ Writes to:
            └───────────────┬───┘
                    │
                    ↓
        ┌──────────────────────────┐
        │   Provider Layer         │
        ├──────────────────────────┤
        │ ┌──────────────────────┐ │
        │ │ DevotionProvider     │ │←─ Reads
        │ │ JournalProvider      │ │   (Consumer)
        │ │ UserProgressProvider │ │←─ Writes
        │ └──────────────────────┘ │   (context.read)
        └──────────────────────────┘
                    ↓
        ┌──────────────────────────┐
        │ GraceDailyDatabase       │
        │ (Service Layer)          │
        └──────────────────────────┘
                    ↓
        ┌──────────────────────────┐
        │ SQLite Database          │
        │ grace_daily.db           │
        └──────────────────────────┘
```

---

## 🔐 Data Integrity Flow

```
User Action (e.g., Complete Devotion)
  ↓
Provider receives call
  ├─ Validates data
  ├─ Updates local state
  ├─ Calls Database.update()
  ↓
Database.update() 
  ├─ Opens transaction
  ├─ Executes SQL query
  ├─ Commits on success
  ├─ Rolls back on error
  ↓
Response to Provider
  ├─ On Success: notifyListeners() → UI updates
  ├─ On Error: Set error message → UI shows error
  ↓
Data consistency guaranteed:
  ✓ Local state matches database
  ✓ UI reflects actual data
```

---

## 🎯 State Management Pattern

### Provider Pattern Used:
```dart
// In widget:
Consumer<DevotionProvider>(
  builder: (context, devotionProvider, child) {
    return Text(devotionProvider.currentVerse.text);
  },
)
```

### Data Flow:
```
Provider (Source of Truth)
    ↓
Consumer (Listener)
    ↓
Widget UI (Display)

When Provider changes:
    ↓
notifyListeners() called
    ↓
Consumer widgets rebuild
    ↓
UI displays new data
```

---

## 📈 Performance Considerations

### Optimized For:
- ✅ **Fast Initialization**: 365 verses loaded once, cached in memory
- ✅ **Efficient Database**: SQLite optimized for mobile
- ✅ **Minimal Rebuilds**: Only affected widgets rebuild
- ✅ **Memory Efficient**: Provider caches data, no memory leaks
- ✅ **Responsive UI**: Database ops don't block UI thread

### Scalability Path:
```
Current (365 verses in app)
    ↓
Growth (Add backend API)
    ↓
Providers fetch from API instead of DB
    ↓
DB caches for offline access
    ↓
Sync on background when online
```

---

## 🔌 Extension Points

### Adding New Features:

**New Screen?**
```
1. Create provider if needed
2. Create screen widget
3. Add route to AppRouter
4. Add nav button/link
```

**New Data Type?**
```
1. Create Model class
2. Create table schema
3. Create database methods
4. Create/extend Provider
5. Use in widgets
```

**New Persistence?**
```
1. Add table to GraceDailyDatabase._createTables()
2. Create CRUD methods
3. Update provider to read/write
4. Use notifyListeners()
```

---

## ✨ Summary

**Grace Daily Architecture** follows clean architecture principles:

```
Presentation Layer:  UI Screens (widgets)
    ↓
State Management:    Providers (business logic)
    ↓
Data Access:         Database Service
    ↓
Persistence:         SQLite
```

This separation of concerns makes the app:
- 🧪 Testable (mock providers)
- 📈 Scalable (add features easily)
- 🔧 Maintainable (clear responsibilities)
- 🚀 Performant (optimized at each layer)


