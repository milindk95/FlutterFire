import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:the_super11/core/preferences.dart';

class FirebaseServices {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final _settingsIos = IOSInitializationSettings();

  /// Initial setup for notification
  _initialize() async {
    await Firebase.initializeApp();
    final initialSettings =
        InitializationSettings(android: _settingsAndroid, iOS: _settingsIos);
    await _plugin.initialize(initialSettings);
  }

  /// Setup firebase notification
  Future<void> setupNotification() async {
    await _initialize();
    final firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((message) {
      _showForegroundNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
      );
    });

    await firebaseMessaging.getToken().then((token) async {
      print('---------------------------------------------------------');
      print('Firebase token');
      print(token);
      await Preference.setFirebaseToken(token ?? '');
      print('---------------------------------------------------------');
    });
  }

  /// Handle foreground notification
  void _showForegroundNotification(
      {String title = '', String body = ''}) async {
    final androidDetails = AndroidNotificationDetails(
      'general_notification',
      'General Notification',
      'General notification for app',
      priority: Priority.defaultPriority,
      playSound: true,
      importance: Importance.defaultImportance,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    _plugin.show(0, title, body, notificationDetails);
  }

  /// Crashlytics setup
  void setupCrashlytics() {
    if (kReleaseMode)
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}
