import 'package:flutter/material.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';
import 'package:otlopapp/otlop_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  runApp(const Otlopapp());
}
