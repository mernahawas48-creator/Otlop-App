import 'dart:io';

import 'package:flutter_native_splash/cli_commands.dart';

void main() {
  createSplash(path: 'flutter_native_splash.yaml', flavor: null);
  final webIndex = File('web/index.html');
  webIndex.writeAsStringSync(
    '${webIndex.readAsLinesSync().map((line) => line.trimRight()).join('\n')}\n',
  );
  const root = 'android/app/src/main/res';
  Directory('$root/drawable-nodpi').createSync(recursive: true);
  File('assets/images/otlob_logo_image.png')
      .copySync('$root/drawable-nodpi/food_couriers_logo.png');
  // Explicit dp bounds enlarge the original logo without stretching its aspect ratio.
  File('$root/drawable/food_couriers_splash_icon.xml')
      .writeAsStringSync('''<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:width="288dp" android:height="132dp" android:gravity="center">
        <bitmap android:src="@drawable/food_couriers_logo" android:gravity="fill" android:filter="true" />
    </item>
</layer-list>
''');
  for (final folder in ['values-v31', 'values-night-v31']) {
    final file = File('$root/$folder/styles.xml');
    var text = file.readAsStringSync().replaceAll(
      '@drawable/android12splash',
      '@drawable/food_couriers_splash_icon',
    );
    text = text.replaceAll(
      '<item name="android:windowSplashScreenIconBackgroundColor">#FFFFFF</item>',
      '<item name="android:windowSplashScreenBrandingImage">@drawable/food_couriers_wordmark</item>',
    );
    file.writeAsStringSync(text);
  }
}
