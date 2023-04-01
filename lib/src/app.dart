import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/core.dart';
import 'presentation/bloc.dart';

// final FirebaseAnalytics kAnalytics = FirebaseAnalytics();
// final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: kAnalytics);

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocalSongsProvider(
      child: ApiProvider(
        child: UiProvider(
          child: PlayerProvider(
            child: ScreenUtilInit(
              designSize: ScreenUtil.defaultSize,
              builder: (BuildContext context, Widget child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                onGenerateRoute: onGeneratedRoute,
                theme: kDarkTheme,
                // navigatorObservers: [_observer],
                // darkTheme: kDarkTheme,
                // theme: kLightTheme,
                // themeMode: ThemeMode.dark,
                // home: ProfileScreen(),
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//  keytool -genkey -v -keystore sign.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key -storepass musica -keypass musica
// musica
