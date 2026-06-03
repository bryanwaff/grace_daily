import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grace_daily/app.dart';
import 'package:grace_daily/firebase_options.dart';
import 'package:grace_daily/core/services/firebase_service.dart';
import 'package:grace_daily/core/services/notification_service.dart';

void main() async {
  // Ensure Flutter engine is initialized before initializing service
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Sign in anonymously to enable cloud features immediately
    await FirebaseService().signInAnonymously();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize notifications service (timezone and channel settings)
  await NotificationService.initNotifications();

  runApp(const GraceDailyApp());
}
