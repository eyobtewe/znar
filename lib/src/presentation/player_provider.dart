import 'package:flutter/material.dart';

import 'player_bloc.dart';

export 'player_bloc.dart';

class PlayerProvider extends InheritedWidget {
  final PlayerBloc bloc;

  PlayerProvider({Key key, Widget child})
      : bloc = PlayerBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static PlayerBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<PlayerProvider>()).bloc;
  }
}
