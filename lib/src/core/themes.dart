import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/custom_route.dart';
import 'colors.dart';

final ThemeData kDarkTheme = ThemeData(
  fontFamily: 'AvenirNext',
  scaffoldBackgroundColor: cBackgroundColor,
  cardColor: cBackgroundColor,
  appBarTheme: const AppBarTheme(
    color: cBackgroundColor,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  pageTransitionsTheme: pageTransitionsTheme(),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: cPrimaryColor),
);

final ThemeData kLightTheme = ThemeData(
  pageTransitionsTheme: pageTransitionsTheme(),
  primaryColor: cBackgroundColor,
  fontFamily: 'AvenirNext',
  appBarTheme: const AppBarTheme(
      color: cBlue, iconTheme: IconThemeData(color: cBackgroundColor)),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: cPrimaryColor),
);

PageTransitionsTheme pageTransitionsTheme() {
  return PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    },
  );
}

const List<String> f = [
  'nyala',
  'Kefa',
];
