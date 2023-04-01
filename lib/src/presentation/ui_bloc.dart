import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/services/download_manager.dart';

class UiBloc {
  String language = 'tg';
  DeviceInfoPlugin deviceData;
  // int version = 24;
  SharedPreferences preferences;
  final down = DownloadsManager();

  void init() async {
    preferences = await SharedPreferences.getInstance();
    try {
      language = preferences.getString('lang');
    } catch (e) {
      debugPrint(e);
    }
    //
    // if (Platform.isAndroid) {
    //   deviceData = DeviceInfoPlugin();
    //   await deviceData.androidInfo.then(
    //     (value) {
    //       version = value.version.sdkInt;
    //     },
    //   );
    // } else {
    //   version = 0;
    // }
  }

  void toggleLanguage() {
    if (language == 'en') {
      language = 'tg';
    } else {
      language = 'en';
    }
    debugPrint(language);

    preferences.setString('lang', language);
  }
}
