import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'src/app.dart';
import 'src/core/core.dart';

_initializeFlutterDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize();

  // await FlutterDownloader.initialize(
  //   debug: true,
  // );
  // await Firebase.initializeApp();
}

void main() {
  _initializeFlutterDownloader();

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

  runApp(App());
}
