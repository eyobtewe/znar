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
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  //

  runApp(App());
}
