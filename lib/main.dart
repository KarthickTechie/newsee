import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/Utils/injectiondependency.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/firebase_options.dart';

void main() async {
  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App
  dependencyInjection();

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      channelDescription: 'Shows basic notifications',
      importance: NotificationImportance.Max,
    ),
  ]);
  // setupLocator();
  // runApp(RouterApp()); // GoRouter Sample App
  runApp(RouterApp()); // GoRouter Sample App
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 999,
      channelKey: 'basic_channel',
      title: message.notification?.title ?? message.data["title"],
      body: message.notification?.body ?? message.data["body"],
      payload: message.data.map(
        (key, value) => MapEntry(key, value?.toString()),
      ),
    ),
  );
}

// git checkout -b karthicktechie-login_progressIndicator download-progress-indicator
