import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';
import 'src/core/core.dart';

_initializeFlutterDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(
  //   debug: true,
  //   // optional: set false to disable printing logs to console
  // );
  // await Firebase.initializeApp();
}

void main() {
  _initializeFlutterDownloader();
  //
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: BACKGROUND,
      systemNavigationBarDividerColor: BACKGROUND,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: BACKGROUND,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  //
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  //

  runApp(App());
}

// admob-app_id: ca-app-pub-3023996001087093~9440864491
// native: ca-app-pub-3023996001087093/2066589743
// banner: ca-app-pub-3023996001087093/2924268041
// interstitial: ca-app-pub-3023996001087093/1069929196
// rewarded: ca-app-pub-3023996001087093/9275722274

// keytool -list -v -alias key -keystore sign.jks
