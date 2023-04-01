import 'package:flutter/material.dart';

import '../../core/core.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({Key key, @required this.context}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: cPrimaryColor.withOpacity(0.25),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, HOME_PAGE_ROUTE, (route) => false,
            arguments: 'NO-INIT');
      },
      child: const Icon(Icons.home),
    );
  }
}
