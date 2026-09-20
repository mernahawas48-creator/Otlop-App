import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlopapp/core/storage/app_preferences.dart';
import 'package:otlopapp/core/utils/service_locator.dart';
import 'package:otlopapp/otlop_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await AppPreferences.init();

  locateDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const Otlopapp(),
    ),
  );
}
