import 'package:flutter/material.dart';

import 'apis_bloc.dart';

export 'apis_bloc.dart';

class ApiProvider extends InheritedWidget {
  final ApiBloc bloc;

  ApiProvider({Key key, Widget child})
      : bloc = ApiBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(oldWidget) => true;

  static ApiBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ApiProvider>()).bloc;
  }
}
