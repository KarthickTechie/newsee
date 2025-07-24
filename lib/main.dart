import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/Utils/injectiondependency.dart';
import 'package:newsee/Utils/key_utils.dart';
import 'package:newsee/core/db/db_config.dart';

void main() async {
  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App
  // dependencyInjection();
  // setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await ApiKeyProvider.initApiKey();
  runApp(RouterApp()); // GoRouter Sample App
}

// git checkout -b karthicktechie-login_progressIndicator download-progress-indicator
