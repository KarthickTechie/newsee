import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/LivelinessApp/liveliness_app.dart';
import 'package:newsee/AppSamples/RouterApp/routerapp.dart';
import 'package:newsee/Utils/injectiondependency.dart';
import 'package:newsee/core/db/db_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runApp(MyApp()) // Default MyApp()
  // runApp(Counter()); // load CounterApp
  // runApp(App()); // timerApp
  // runApp(ToolBarSample()); // Toolbar App
  //runApp(LoginApp()); // Login Form App
  // dependencyInjection();
  // setupLocator();
  runApp(RouterApp()); // GoRouter Sample App
  // final cameras = await availableCameras();
  // runApp(LivelinessApp(cameras: cameras));
}

// git checkout -b karthicktechie-login_progressIndicator download-progress-indicator
