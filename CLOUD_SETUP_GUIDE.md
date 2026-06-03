# Grace Daily - Cloud Integration Guide

This guide explains how to set up the Firebase backend, Firestore database, and Cloud Functions to support the new cloud-sync features.

## 1. Firebase Project Setup
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project named **Grace Daily**.
3. Add an Android/iOS app and follow the instructions to download `google-services.json` and `GoogleService-Info.plist`.
4. Place these files in their respective directories (`android/app/` and `ios/Runner/`).

## 2. Firestore Collections
Create the following collections in **Cloud Firestore** (Production Mode or Test Mode):

### `verses`
- **Purpose**: Hosts the 365-day devotion library.
- **Fields**: `id` (int), `text`, `reference`, `title`, `reflection`, `quote`, `thoughtForTheDay`, `dailyIntention`, `prayerText`.

### `users`
- **Purpose**: Stores individual user progress.
- **Structure**: `users/{userId}/progress` and `users/{userId}/journal/{entryId}`.

### `stats`
- **Purpose**: Global app statistics.
- **Document**: `global` with field `totalPrayers` (int).

---

## 3. Cloud Functions (Node.js)
To implement the "Global Prayer Count" and automated notifications, deploy the following functions:

### Global Prayer Aggregator
Triggered whenever a user saves a journal entry with `isPrayed: true`.

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.aggregatePrayers = functions.firestore
    .document('users/{userId}/journal/{entryId}')
    .onCreate((snap, context) => {
        const entry = snap.data();
        if (entry.isPrayed) {
            const statsRef = admin.firestore().collection('stats').doc('global');
            return statsRef.update({
                totalPrayers: admin.firestore.FieldValue.increment(1)
            });
        }
        return null;
    });
```

### Daily Verse Push (Optional)
Send a remote push notification every morning using a scheduled function.

```javascript
exports.dailyReminderPush = functions.pubsub
    .schedule('0 8 * * *') // 8:00 AM daily
    .timeZone('America/New_York')
    .onRun((context) => {
        const payload = {
            notification: {
                title: '📖 Morning Grace',
                body: 'Your daily devotion is ready. Take a moment for yourself.',
            }
        };
        return admin.messaging().sendToTopic('daily_devotions', payload);
    });
```

---

## 4. Security Rules
Ensure users can only read/write their own data:

```
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own progress and journal
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Verses are read-only for everyone
    match /verses/{verseId} {
      allow read: if true;
      allow write: if false;
    }
    
    // Global stats are read-only for users
    match /stats/global {
      allow read: if true;
      allow write: if false;
    }
  }
}
```
