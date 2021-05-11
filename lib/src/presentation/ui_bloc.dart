import 'package:device_info/device_info.dart';
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
    // language = preferences.getString('lang');
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

    preferences.setString('lang', '$language');
  }
}
