# ⚡ Grace Daily - Quick Start Guide

## 🎯 5-Minute Setup

### Step 1: Get Dependencies
```bash
cd /home/waff/AndroidStudioProjects/grace_daily
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

### Step 3: Test It
1. Complete a devotion (Home → Reflection → Prayer → Success)
2. Write something in "Personal Reflections"
3. Click "Complete Devotion"
4. Go to Progress tab to see updated streak
5. Close and reopen app - data still there! ✨

---

## 🎮 Core User Paths

### Path 1: Complete Daily Devotion
```
HOME SCREEN
   ↓ "Start Devotion"
REFLECTION SCREEN
   ↓ "See Reflection"
PRAYER SCREEN
   ↓ Write reflection + Mark prayed
   ↓ "Complete Devotion"
SUCCESS SCREEN
   ↓ "Return Home" or "View Progress"
```

### Path 2: Check Your Progress
```
ANY SCREEN
   ↓ Bottom nav: tap "Progress"
PROGRESS SCREEN
   ↓ See streak, completions, recent entries
   ↓ Tap "Today" to go back
```

---

## 💾 What Gets Saved

When you complete a devotion:
- ✅ Journal entry (your reflection)
- ✅ Prayer status (marked as prayed)
- ✅ Streak counter (+1 or reset if missed)
- ✅ Total completions (+1)
- ✅ Completion map (tracks each day)
- ✅ Timestamp (when you finished)

**All data persists permanently.** Even if you close the app, close your phone, everything is saved locally on your device.

---

## 📍 Navigation Map

```
┌─────────────────────┐
│   HOME SCREEN       │
│  (Verse of Day)     │
└──────────┬──────────┘
           │
        Quick Nav:
  ┌───────┼───────┬───────┬─────────┐
  │       │       │       │         │
  ↓       ↓       ↓       ↓         ↓
Today  Reflection Prayer Progress  (back button)
  │       │       │       │         │
  └──→────┴───────┴───────┴─────────┘
```

**Bottom Navigation (tap to switch):**
- 📅 Today → Home screen
- 📖 Reflection → Devotion content
- 🙏 Prayer → Journal & prayer completion
- 📊 Progress → Stats & streak dashboard

---

## 📊 Progress Screen Explained

```
┌─────────────────────────────────────┐
│  🔥 CURRENT STREAK CARD            │
│  ─────────────────────────────────  │
│  Streak: 5 days                     │
│  Status: ✨ Great! Done today.      │
│                                     │
├─────────────────────────────────────┤
│  📊 STATISTICS GRID                │
│  ─────────────────────────────────  │
│  Completions: 42  │  Longest: 15    │
│  Days Since: 45   │  % This Month: 87%
│                                     │
├─────────────────────────────────────┤
│  📖 RECENT REFLECTIONS             │
│  ─────────────────────────────────  │
│  [Entry 1] - Today - Marked 🙏      │
│  [Entry 2] - Yesterday - Marked 🙏  │
│  [Entry 3] - 2 days ago             │
│  ... (last 5 shown)                 │
└─────────────────────────────────────┘
```

---

## 🛠️ Troubleshooting

### "App won't launch"
```bash
→ Run: flutter clean
→ Run: flutter pub get
→ Run: flutter run
```

### "Streak not showing"
```
→ Make sure you clicked "Complete Devotion"
→ Wait 2 seconds for database to save
→ Restart the app
→ Go to Progress tab
```

### "My data disappeared"
```
→ Check if database was deleted
→ Reinstall app (but this WILL clear data)
→ If data is critical, backup first
```

### "Notifications not working"
```
→ Feature available in Phase 2 (not yet active)
→ Check ROADMAP.md for timeline
```

---

## 💡 Pro Tips

### Tip 1: Maintain Your Streak
- Try to complete your devotion at the **same time every day**
- Mark it done even if you're busy - just takes 2 minutes!
- Streaks are GREAT motivation

### Tip 2: Meaningful Reflections
- Spend 2-3 minutes writing your thoughts
- Be honest about what resonates with you
- Read back old entries for encouragement

### Tip 3: Track Progress
- Check the Progress screen weekly
- Watch your monthly completion % grow
- Celebrate milestones (7 days, 30 days, 100 days!)

### Tip 4: Use Bookmarks (Coming Soon)
- Mark favorite verses to revisit later
- Create a personal collection of meaningful scripture
- Share bookmarks with friends

---

## 🔄 Data Refresh

### How Often Does Data Update?
- **Immediate**: Prayer scores, streaks (on completion)
- **Always**: Journal entries saved instantly
- **On Startup**: All data loaded from database
- **On Demand**: Pull-to-refresh available soon

### What If I Miss a Day?
- Your streak resets to 0
- Total completions still count
- Longest streak is preserved in history
- You can start a new streak today!

---

## 🎨 Personal Customization

### Change App Colors
Edit: `lib/theme/gdaily_colors.dart`
- Adjust primary olive color
- Modify secondary colors
- Change text colors

### Change Fonts
Edit: `lib/theme/gdaily_typography.dart`
- Adjust font sizes
- Change font weights
- Modify line heights

### Add Custom Verses
Edit: `lib/core/providers/devotion_provider.dart`
- Expand mockData list
- Add your own scripture
- Change verse rotation logic

---

## 📈 Feature Status

### ✅ Ready to Use (Phase 1)
- [x] Daily devotion view
- [x] Streak tracking
- [x] Journal entries
- [x] Progress dashboard
- [x] Data persistence
- [x] Navigation

### 🚧 Coming Soon (Phase 2)
- [ ] Daily notifications
- [ ] Share functionality
- [ ] Bookmarks screen
- [ ] Dark mode
- [ ] Voice narration

### 📋 Planned (Phase 3+)
- [ ] Community features
- [ ] Cloud sync
- [ ] Premium content
- [ ] Multiple Bible versions

See [ROADMAP.md](ROADMAP.md) for full timeline.

---

## 📞 Quick Reference

### Save a Journal Entry
1. Go to Prayer screen
2. Type in "Personal Reflections"
3. Click "Save to Journal"
4. ✅ Saved with timestamp!

### Check Your Streak
1. Tap "Progress" in bottom nav
2. Look at big "CURRENT STREAK" card
3. See if you completed today

### Complete Devotion Properly
1. Write reflection (optional but recommended)
2. Mark prayer ✓
3. Click "Complete Devotion" (NOT just back button)
4. ✅ Streak +1, Completion +1

### View Recent Entries
1. Go to Progress screen
2. Scroll to "Recent Reflections"
3. Tap entry to read full text

---

## 🎯 Key Screens Overview

### HOME Screen
- Shows today's verse
- Beautiful imagery
- Quick intro to devotion
- "Start Devotion" button

### REFLECTION Screen
- Full devotion text
- Meditation content
- Featured quote
- "See Reflection" button

### PRAYER Screen
- Prayer intention
- Interactive buttons
- Journal text field
- Save & complete buttons

### PROGRESS Screen (NEW!)
- Your streak
- All-time statistics
- Recent reflections
- Monthly completion rate

---

## 🆘 Getting Help

### Documentation Files
1. **IMPLEMENTATION_GUIDE.md** - Detailed usage guide
2. **ARCHITECTURE.md** - System design overview
3. **ROADMAP.md** - Future features
4. **ADVANCEMENT_COMPLETE.md** - Full feature summary

### Common Questions
See **IMPLEMENTATION_GUIDE.md** under "Troubleshooting" section

### Feature Requests
Check **ROADMAP.md** - your idea might be planned!

---

## ✨ Summary

You now have a **fully functional devotion app** with:
- 📖 Daily verses
- 📝 Personal journal
- 🔥 Streak tracking
- 📊 Progress dashboard
- 💾 Local data storage
- 🎨 Beautiful design

**Everything is ready to use.** Enjoy your daily Grace journey! 🙏

---

**Next Step:** Run `flutter run` and start your first devotion! 🚀

