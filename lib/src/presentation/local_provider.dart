import 'package:flutter/material.dart';

import 'local_bloc.dart';

export 'local_bloc.dart';

class LocalSongsProvider extends InheritedWidget {
  final LocalSongsBloc bloc;

  LocalSongsProvider({Key key, Widget child})
      : bloc = LocalSongsBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LocalSongsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LocalSongsProvider>())
        .bloc;
  }
}
