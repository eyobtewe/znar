import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/core.dart';
import '../presentation/bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
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
    // final localBloc = LocalSongsProvider.of(context);
    // localBloc.getDownloadedMusic(Theme.of(context).platform);
    bloc.fetchAll();

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: size.height * 0.2),
                child: Text(
                  // 'ዝናር',
                  'ZNAR',
                  style: TextStyle(
                    fontSize: 38,
                    fontFamilyFallback: f,
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
