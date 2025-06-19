import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/Utils/injectiondependency.dart';
import 'package:newsee/core/db/db_config.dart';

void main() {
  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App
  // dependencyInjection();
  runApp(RouterApp()); // GoRouter Sample App
}

// git checkout -b karthicktechie-login_progressIndicator download-progress-indicator
