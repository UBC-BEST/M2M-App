import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'app/startup/app_bootstrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final bootstrapper = AppBootstrapper();
  final launchState = await bootstrapper.load();

  runApp(MyApp(launchState: launchState));
}
