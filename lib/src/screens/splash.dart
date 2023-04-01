import 'package:flutter/material.dart';

import '../core/core.dart';
import '../presentation/bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bloc = ApiProvider.of(context);

    bloc.fetchAll();

    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
    });

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: size.height * 0.2),
            child: const Text(
              // 'ዝናር',
              'ZNAR',
              style: TextStyle(
                fontSize: 38,
                fontFamilyFallback: f,
                fontFamily: 'Didot',
                color: cPrimaryColor,
                // fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
