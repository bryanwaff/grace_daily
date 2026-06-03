# Grace Daily - Feature Roadmap

## 🎯 Phase 1: ✅ COMPLETE - Foundation & Core Features
- ✅ State Management with Provider
- ✅ Local SQLite Persistence
- ✅ Data Models (Verse, JournalEntry, UserProgress)
- ✅ Streak Tracking System
- ✅ Journal Entry System
- ✅ Progress Dashboard Screen
- ✅ Prayer Completion with DB Save
- ✅ Enhanced Navigation

---

## 🚀 Phase 2: Notifications & Engagement (1-2 weeks)

### 2.1 Daily Reminder Notifications
**Effort:** 4-6 hours | **Impact:** ⭐⭐⭐⭐⭐

Dependency already added: `flutter_local_notifications: ^17.0.0`

**Implementation Plan:**
```dart
// Create file: lib/core/services/notification_service.dart
class NotificationService {
  static Future<void> initNotifications() async {
    // Initialize plugin
  }
  
  static Future<void> scheduleDailyReminder(TimeOfDay time) async {
    // Schedule daily notification at user's preferred time
  }
  
  static Future<void> cancelNotifications() async {
    // For settings control
  }
}
```

**Features to Add:**
- [ ] Settings screen for notification time
- [ ] Toggle notifications on/off
- [ ] Streak milestone notifications (7, 14, 30, 60, 100 days)
- [ ] "Complete devotion" action in notification
- [ ] Celebration sound/haptic feedback

**Database Update:**
```dart
// Add to user_progress table:
- notificationTime (e.g., "08:00")
- notificationsEnabled (boolean)
```

---

### 2.2 Share Functionality
**Effort:** 2-3 hours | **Impact:** ⭐⭐⭐

**Implementation:**
```dart
// Create file: lib/core/services/share_service.dart
class ShareService {
  static Future<void> shareVerse(Verse verse) async {
    final text = '''
"${verse.text}"

${verse.reference}

Read more on Grace Daily ✨
    ''';
    await Share.share(text);
  }
  
  static Future<void> shareEntry(JournalEntry entry, Verse verse) async {
    // Share reflection + verse together
  }
}
```

**UI Implementation:**
- [ ] Share button on Home screen (top right)
- [ ] Share button on Reflection screen
- [ ] Share button on completion with stats
- Template: `Verse + "Posted from Grace Daily" + Share button`

**Code Snippet to Add to HomeScreen:**
```dart
// In the verse card, add to top right:
IconButton(
  icon: const Icon(Icons.share_rounded),
  onPressed: () => ShareService.shareVerse(_currentVerse),
)
```

---

## ⭐ Phase 3: Content & Favorites (2-3 weeks)

### 3.1 Bookmarks/Favorites Screen
**Effort:** 6-8 hours | **Impact:** ⭐⭐⭐⭐

**New File:** `lib/screens/bookmarks/bookmarks_screen.dart`

**Features:**
- [ ] New route: `/home/bookmarks`
- [ ] List all bookmarked verses
- [ ] Filter by month/themes
- [ ] Search functionality
- [ ] Quick share from bookmarks
- [ ] Remove bookmark action

**Database Already Supports This:**
```dart
// Just leverage existing:
final bookmarkedVerses = await devotionProvider.getBookmarkedVerses();
```

---

### 3.2 Full 365-Day Verse Library
**Effort:** 4-6 hours (content prep depends on you) | **Impact:** ⭐⭐⭐

**Option A: JSON Asset (Recommended for MVP)**
```
assets/
└── verses/
    └── verses_365.json
```

**JSON Structure:**
```json
{
  "verses": [
    {
      "id": 1,
      "text": "...",
      "reference": "...",
      ...
    },
    // 364 more verses
  ]
}
```

**Option B: Firebase Firestore (Advanced)**
- Host verses in cloud
- Sync on startup
- Cache locally

**Implementation:**
```dart
// In DevotionProvider:
Future<void> loadVersesFromAsset() async {
  final jsonString = await rootBundle.loadString('assets/verses/verses_365.json');
  final json = jsonDecode(jsonString);
  // Parse and insert into DB
}
```

---

## 🎨 Phase 4: UI/UX Polish (1-2 weeks)

### 4.1 Dark Mode
**Effort:** 6-8 hours | **Impact:** ⭐⭐⭐⭐

**Already Have:**
- Dark color palette in `GdailyColors`
- Dark Typography ready

**Implementation:**
```dart
// In app.dart:
return MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,  // ← Add this
  themeMode: ThemeMode.system,    // ← Follow system preference
  // ...
);
```

**Checklist:**
- [ ] Define dark colors for all custom elements
- [ ] Test all screens in dark mode
- [ ] Add dark TextTheme to GdailyTypography
- [ ] Test animations in dark mode
- [ ] Ensure contrast meets WCAG standards

---

### 4.2 Animations & Transitions
**Effort:** 8-10 hours | **Impact:** ⭐⭐⭐

**Recommended animations:**
- [ ] Fade-in on page loads
- [ ] Slide transitions between screens
- [ ] Scale animations on buttons
- [ ] Pulse animation on streak counter
- [ ] Celebration confetti on daily completion

**Package:** `flutter/animation` (built-in)

**Example:**
```dart
// Pulse animation on streak number
AnimatedScale(
  scale: _pulsing ? 1.1 : 1.0,
  duration: const Duration(milliseconds: 600),
  child: Text(currentStreak.toString()),
)
```

---

### 4.3 Enhanced Navigation
**Effort:** 4-6 hours | **Impact:** ⭐⭐

**New Features:**
- [ ] Navigation drawer (optional)
- [ ] Breadcrumb navigation
- [ ] Back button customization
- [ ] Deep linking for external shares
- [ ] Page transitions between screens

---

## 🔌 Phase 5: Backend Integration (3-4 weeks)

### 5.1 User Accounts & Sync
**Effort:** 12-16 hours | **Impact:** ⭐⭐⭐⭐⭐

**Services to Use:**
- Firebase Auth (email/Google/Apple sign-in)
- Firebase Firestore (cloud sync)
- Or: Custom REST API

**Data to Sync:**
- User progress (streaks, completions)
- Journal entries
- Bookmarks
- Settings

**Implementation Path:**
```
1. Add Firebase dependencies
2. Create AuthService
3. Create CloudSyncService
4. Sync on app launch
5. Queue updates when offline
6. Sync when back online
```

---

### 5.2 Community Features
**Effort:** 8-12 hours | **Impact:** ⭐⭐⭐

**Features:**
- [ ] View prayer count updates (real-time from backend)
- [ ] Share progress on social media
- [ ] Group devotions (family/church)
- [ ] Leaderboards (anonymous)
- [ ] Community comments on reflections

---

### 5.3 Bible API Integration
**Effort:** 6-8 hours | **Impact:** ⭐⭐⭐

**Options:**
- Free: Bible API (bible-api.com)
- Paid: RapidAPI Bible services
- Self-hosted: OpenBible data

**Benefits:**
- Fresh content daily
- Multiple Bible versions
- Linkable Bible references
- Search functionality

---

## 📊 Phase 6: Analytics & Insights (2-3 weeks)

### 6.1 Advanced Progress Dashboard
**Effort:** 6-8 hours | **Impact:** ⭐⭐⭐

**New Visualizations:**
- [ ] Heatmap (like GitHub contributions)
- [ ] Monthly bar chart
- [ ] Streak history graph
- [ ] Time-of-day completion stats
- [ ] Most-read verses

**Packages:**
- `fl_chart: ^0.65.0` (Beautiful charts)
- `table_calendar: ^3.0.0` (Calendar heatmap)

---

### 6.2 Insights & Milestones
**Effort:** 4-6 hours | **Impact:** ⭐⭐

**Features:**
- [ ] "Your stats this month"
- [ ] Milestone celebrations (first 30 days, etc.)
- [ ] Streaks comparison
- [ ] Reading time estimates
- [ ] Favorite themes/books

---

## 🎁 Phase 7: Premium Features (4-6 weeks)

### 7.1 Premium Subscription Model
**Effort:** 12-16 hours | **Impact:** ⭐⭐⭐

**Premium Features:**
- [ ] Ad-free experience
- [ ] Custom themes
- [ ] Offline downloaded content
- [ ] Voice narration
- [ ] Extended verse library
- [ ] No streak limit storage

**Implementation:**
```dart
// Add to pubspec.yaml:
in_app_purchase: ^0.13.0

// Create: lib/core/services/subscription_service.dart
class SubscriptionService {
  Future<void> purchaseSubscription() async { }
  Future<bool> isPremium() async { }
  Future<void> restorePurchases() async { }
}
```

---

### 7.2 Voice Narration
**Effort:** 8-10 hours | **Impact:** ⭐⭐⭐

**Package:** `text_to_speech: ^0.2.3`

**Features:**
- [ ] Auto-play narration of verses
- [ ] Adjustable reading speed
- [ ] Different narrator voices
- [ ] Background listening while doing other tasks

---

## 🧪 Quality Assurance Phase (1-2 weeks)

### Testing & Bug Fixes
- [ ] Unit tests for providers
- [ ] Widget tests for screens
- [ ] Integration tests for DB operations
- [ ] Manual testing on real devices
- [ ] Performance profiling
- [ ] Accessibility audit (a11y)

---

## 📱 Platform-Specific (As Needed)

### iOS Specifics
- [ ] App Store compliance
- [ ] iOS keyboard handling
- [ ] Safe area management
- [ ] Haptic feedback

### Android Specifics
- [ ] Material Design compliance
- [ ] Notification channels
- [ ] Back gesture handling
- [ ] Storage permissions

---

## 🌍 Internationalization (i18n) - Optional

**Effort:** 8-12 hours | **Impact:** ⭐⭐

**Package:** `intl: ^0.19.0` (already added!)

**Supported Languages to Add:**
- [ ] Spanish
- [ ] French
- [ ] German
- [ ] Portuguese
- [ ] Mandarin

---

## 🎯 Quick Win Checklist

### This Week (4-6 hours):
- [ ] Fix pubspec.yaml (run `flutter pub get`)
- [ ] Test the app end-to-end
- [ ] Add 10-15 more mock verses to the list
- [ ] Create Settings screen stub

### Next Week (8-10 hours):
- [ ] Implement Daily Reminder Notifications
- [ ] Add Share functionality
- [ ] Create Bookmarks screen
- [ ] Improve mock verse content

### Week 3 (12-15 hours):
- [ ] Implement Dark Mode
- [ ] Add simple animations
- [ ] Create full 365-verse JSON file
- [ ] Deploy test build to TestFlight/Play Console

---

## 💡 Implementation Priority Matrix

```
HIGH IMPACT + LOW EFFORT (Do These First):
├─ Notifications (Phase 2.1)
├─ Share functionality (Phase 2.2)
├─ Bookmarks screen (Phase 3.1)
└─ Dark mode (Phase 4.1)

HIGH IMPACT + MEDIUM EFFORT (Do These Second):
├─ Full 365 verses (Phase 3.2)
├─ Animations (Phase 4.2)
├─ Progress analytics (Phase 6)
└─ Voice narration (Phase 7.2)

MEDIUM IMPACT + MEDIUM EFFORT:
├─ Backend sync (Phase 5.1)
├─ Community features (Phase 5.2)
└─ Subscription model (Phase 7.1)

LOW IMPACT + HIGH EFFORT (Do Last):
├─ Multilingual support
├─ Advanced backend optimization
└─ Extensive integration testing
```

---

## 📋 Recommended 3-Month Roadmap

### Month 1: Engagement & Polish
- Week 1: Notifications + Share
- Week 2: Bookmarks + Dark Mode
- Week 3: Enhanced verses + Animations
- Week 4: Beta testing & bug fixes

### Month 2: Analytics & Content
- Week 1: Progress dashboard improvements
- Week 2: Advanced insights & milestones
- Week 3: Full 365-verse library expansion
- Week 4: Testing & refinement

### Month 3: Growth & Monetization
- Week 1: Backend infrastructure setup
- Week 2: User authentication
- Week 3: Premium features foundation
- Week 4: App store optimization & launch prep

---

## 🚀 Ready to Build More?

Each phase has specific implementation examples. Pick one, and let me know if you need:
- Code templates
- Architecture guidance
- Testing strategies
- Design feedback

**Most recommended next step:** Phase 2.1 (Notifications) - Takes ~6 hours and provides huge engagement boost! 🔔


