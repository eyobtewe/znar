import 'package:flutter/material.dart';

import 'ui_bloc.dart';

export 'ui_bloc.dart';

class UiProvider extends InheritedWidget {
  final UiBloc bloc;

  UiProvider({Key key, Widget child})
      : bloc = UiBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static UiBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<UiProvider>()).bloc;
  }
}
