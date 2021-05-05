import 'package:flutter/material.dart';

import 'core/core.dart';
import 'presentation/bloc.dart';

// final FirebaseAnalytics kAnalytics = FirebaseAnalytics();
// final FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: kAnalytics);

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return LocalSongsProvider(
      child: ApiProvider(
        child: UiProvider(
          child: PlayerProvider(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: onGeneratedRoute,
              // navigatorObservers: [_observer],
              darkTheme: kDarkTheme,
              theme: kLightTheme,
              themeMode: ThemeMode.dark,
              // home: SearchPage(),
            ),
          ),
        ),
      ),
    );
  }
}

//  keytool -genkey -v -keystore sign.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key -storepass musica -keypass musica
// musica
