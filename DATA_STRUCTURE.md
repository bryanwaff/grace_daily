# Grace Daily - Data Structure Documentation

## Overview
Grace Daily is a spiritual devotion app that delivers a 365-day journey of daily verses, reflections, prayers, and personal journaling. Below is the comprehensive data structure needed to run the application.

---

## 1. Core Data Models

### 1.1 Daily Devotion Model
Represents a single day's complete spiritual content.

```dart
class DailyDevotion {
  final int dayNumber;           // 1-365
  final DateTime date;           // Date of the devotion
  final String verse;            // Bible verse text
  final String verseReference;   // e.g., "Jeremiah 29:11"
  final String title;            // Devotion title (e.g., "Finding Stillness")
  final String meditationText;   // Main meditation content
  final String quote;            // Highlighted quote for the day
  final String thoughtForDay;    // Actionable thought/prayer
  final String audioTitle;       // Ambient soundscape name (e.g., "Cathedral Hymns")
  final DateTime createdAt;      // When this devotion was created
}
```

### 1.2 Daily Prayer Model
Represents the daily intention/prayer content.

```dart
class DailyPrayer {
  final int dayNumber;           // 1-365, matches devotion
  final DateTime date;
  final String intention;        // Daily intention title (e.g., "Finding Stillness")
  final String prayerText;       // Prayer content
  final String attribution;      // Who wrote it (e.g., "A Heart's Plea")
  final String soundscapeTitle;  // Audio name (e.g., "Cathedral Hymns")
}
```

### 1.3 User Journal Entry Model
User's personal reflections and prayer records.

```dart
class JournalEntry {
  final String id;               // Unique identifier
  final DateTime dateCreated;
  final int dayNumber;           // Associated devotion day
  final String reflection;       // User's written reflection
  final bool prayerMarked;       // Whether user marked as "prayed"
  final DateTime? markedAt;      // When prayer was marked complete
  final List<String> tags;       // Optional tags for organization
}
```

### 1.4 User Progress Model
Tracks user's completion and engagement with daily content.

```dart
class UserProgress {
  final String userId;
  final int currentDayNumber;    // Last completed day
  final DateTime lastAccessDate;
  final int totalDaysCompleted;
  final List<int> completedDayNumbers;  // Days with prayers marked
  final Map<int, JournalEntry> journalEntries;
}
```

---

## 2. Data Storage Architecture

### 2.1 Local Database (SQLite with sqflite)
Currently empty in the app, but needed for:
- Storing user journal entries
- Caching daily devotions
- Tracking user progress
- Recording prayer completion status

**Tables Needed:**
- `daily_devotions` - All 365 daily contents
- `daily_prayers` - Prayer content for each day
- `journal_entries` - User reflections
- `user_progress` - Completion tracking
- `user_settings` - App preferences

### 2.2 Remote Data Source (API/Backend)
For fetching:
- 365-day devotion content
- Daily prayer content
- User statistics ("5,620 others joined in this prayer today")
- Audio/media content references
- User account data

**Required Endpoints:**
```
GET /api/devotions/{dayNumber}
GET /api/prayers/{dayNumber}
GET /api/user/progress
POST /api/journal/entries
GET /api/statistics/daily-prayer
```

---

## 3. Static/Asset Data Currently Used

### 3.1 Images
```
assets/images/
├── bible.jpg          # Used in home, reflection, and prayer screens
```

### 3.2 Fonts
```
assets/fonts/
├── Newsreader-Regular.ttf    # For serif devotion text
├── Newsreader-Italic.ttf
├── Manrope-Regular.ttf       # For sans-serif UI elements
├── Manrope-Medium.ttf
└── Manrope-Bold.ttf
```

---

## 4. Current Hardcoded Content (Need to Be Replaced with Dynamic Data)

### 4.1 Home Screen (home_screen.dart)
- **Verse**: "For I know the plans I have for you..."
- **Reference**: Jeremiah 29:11
- Static content that needs to be pulled from database

### 4.2 Reflection Screen (reflection_screen.dart)
- **Verse**: "Be still, and know that I am God"
- **Reference**: Psalm 46:10
- **Title**: "The Gift of Quiet"
- **Content**: Meditation text and thought for the day
- Should be fetched from `DailyDevotion` model

### 4.3 Prayer Screen (prayer_screen.dart)
- **Intention**: "Finding Stillness"
- **Prayer Text**: "Lord, in the quiet of this moment..."
- **Attribution**: "A Heart's Plea"
- **Soundscape**: "Cathedral Hymns"
- **Counter**: "5,620 others joined in this prayer today"
- Should be fetched from `DailyPrayer` model and statistics API

---

## 5. Data Flow Architecture

```
┌─────────────────────────────────────────┐
│         User Interface (Screens)         │
│  Home → Reflection → Prayer → Success    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│    State Management (Provider/Riverpod)  │
│  - DevotionProvider                     │
│  - PrayerProvider                       │
│  - UserProgressProvider                 │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│   Repository Layer (Data Access)        │
│  - DevotionRepository                   │
│  - PrayerRepository                     │
│  - UserProgressRepository               │
│  - JournalRepository                    │
└──────────────┬──────────────────────────┘
               │
        ┌──────┴──────┐
        │             │
┌───────▼────┐  ┌────▼────────┐
│   Local DB │  │  Remote API  │
│  (SQLite)  │  │  (Backend)   │
└────────────┘  └──────────────┘
```

---

## 6. Data Format Examples

### 6.1 Sample Daily Devotion JSON (from API)
```json
{
  "dayNumber": 1,
  "date": "2025-01-01",
  "verse": "For I know the plans I have for you, declares the LORD...",
  "verseReference": "Jeremiah 29:11",
  "title": "Grace Begins Here",
  "meditationText": "In a world that demands our constant attention...",
  "quote": "Stillness is not the absence of energy...",
  "thoughtForDay": "Take one intentional pause today...",
  "audioTitle": "Cathedral Hymns",
  "imageUrl": "https://api.example.com/images/devotion-01.jpg"
}
```

### 6.2 Sample Journal Entry (Local DB)
```json
{
  "id": "entry_001",
  "dateCreated": "2025-01-15T14:30:00Z",
  "dayNumber": 15,
  "reflection": "Today I felt more present when I paused...",
  "prayerMarked": true,
  "markedAt": "2025-01-15T09:45:00Z",
  "tags": ["peace", "gratitude"]
}
```

---

## 7. Missing Dependencies (To Be Added)

### 7.1 Database Package
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.0
```

### 7.2 State Management
```yaml
dependencies:
  riverpod: ^2.4.0  # or provider: ^6.1.2 (already in pubspec)
```

### 7.3 HTTP/API Communication
```yaml
dependencies:
  http: ^1.1.0
  dio: ^5.3.0
```

### 7.4 Local Storage for User Preferences
```yaml
dependencies:
  shared_preferences: ^2.2.0
```

---

## 8. Data Initialization Flow

1. **App Launch** → Check if this is the first time user opens app
2. **Fetch Today's Devotion** → Download/retrieve Day 1's content
3. **Load User Progress** → Check if user previously completed days
4. **Cache Content** → Store today's content locally
5. **Display Home Screen** → Show verse of the day
6. **User Navigation** → Reflection → Prayer → Success flow
7. **Save Progress** → Mark day complete, save journal entry
8. **Load Next Day** → Increment dayNumber and repeat

---

## 9. Database Schema (SQLite)

### daily_devotions table
```sql
CREATE TABLE daily_devotions (
  id INTEGER PRIMARY KEY,
  dayNumber INTEGER UNIQUE NOT NULL,
  date TEXT NOT NULL,
  verse TEXT NOT NULL,
  verseReference TEXT NOT NULL,
  title TEXT NOT NULL,
  meditationText TEXT NOT NULL,
  quote TEXT NOT NULL,
  thoughtForDay TEXT NOT NULL,
  audioTitle TEXT,
  imageUrl TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT
);
```

### daily_prayers table
```sql
CREATE TABLE daily_prayers (
  id INTEGER PRIMARY KEY,
  dayNumber INTEGER UNIQUE NOT NULL,
  date TEXT NOT NULL,
  intention TEXT NOT NULL,
  prayerText TEXT NOT NULL,
  attribution TEXT,
  soundscapeTitle TEXT,
  createdAt TEXT NOT NULL
);
```

### journal_entries table
```sql
CREATE TABLE journal_entries (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  dayNumber INTEGER NOT NULL,
  dateCreated TEXT NOT NULL,
  reflection TEXT,
  prayerMarked INTEGER DEFAULT 0,
  markedAt TEXT,
  tags TEXT
);
```

### user_progress table
```sql
CREATE TABLE user_progress (
  userId TEXT PRIMARY KEY,
  currentDayNumber INTEGER DEFAULT 1,
  lastAccessDate TEXT,
  totalDaysCompleted INTEGER DEFAULT 0,
  completedDays TEXT,
  createdAt TEXT NOT NULL
);
```

---

## 10. Implementation Priority

### Phase 1 (MVP - Minimum Viable Product)
- [ ] Create models (DailyDevotion, DailyPrayer)
- [ ] Implement SQLite database with local devotion data (365 days)
- [ ] Create repositories for data access
- [ ] Implement state management with Provider

### Phase 2 (Enhanced Features)
- [ ] Add remote API integration
- [ ] Implement user authentication
- [ ] Add journal entry functionality
- [ ] Track user progress and completion

### Phase 3 (Advanced Features)
- [ ] Audio playback for soundscapes
- [ ] Cloud sync for journal entries
- [ ] User statistics and sharing
- [ ] Notifications for daily devotions

---

## Summary

**Grace Daily** requires:
1. **365 days of devotional content** (verse, reflection, prayer, media)
2. **User data persistence** (journal entries, progress tracking)
3. **Local & remote data sources** (SQLite + Backend API)
4. **State management** (Provider/Riverpod)
5. **Data models** for all domain entities
6. **Repository pattern** for data access abstraction
7. **Proper error handling** and offline support

This structure ensures the app can deliver personalized daily spiritual content while maintaining user engagement and progress tracking.

