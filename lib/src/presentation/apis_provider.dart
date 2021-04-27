import 'package:flutter/material.dart';

import 'apis_bloc.dart';

export 'apis_bloc.dart';

class ApiProvider extends InheritedWidget {
  final ApiBloc bloc;

  ApiProvider({Key key, Widget child})
      : bloc = ApiBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static ApiBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ApiProvider>()).bloc;
  }
}
