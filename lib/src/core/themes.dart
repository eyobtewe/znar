import 'package:flutter/material.dart';

import '../helpers/custom_route.dart';
import 'colors.dart';

final ThemeData kDarkTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: BACKGROUND,
  cardColor: BACKGROUND,
  accentColor: PRIMARY_COLOR,
  appBarTheme: AppBarTheme(color: BACKGROUND),
  // pageTransitionsTheme: pageTransitionsTheme(),
);

final ThemeData kLightTheme = ThemeData(
  // pageTransitionsTheme: pageTransitionsTheme(),s
  primaryColor: BACKGROUND,
  fontFamily: 'Montserrat',
  accentColor: PRIMARY_COLOR,
  appBarTheme: AppBarTheme(
    color: BLUE,
    iconTheme: IconThemeData(color: BACKGROUND),
  ),
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
  'Wo', //*
  'Hi', //*
  'Ji', //*-
  'Ab', //*-
];
