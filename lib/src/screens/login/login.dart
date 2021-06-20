import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';
import '../../core/core.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Center(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    var divider = Divider(color: Colors.transparent, height: 10);
    return Column(
      children: [
        Spacer(),
        Spacer(),
        Spacer(),
        Container(
          decoration: BoxDecoration(),
          child: Text(
            'ZNAR',
            style: TextStyle(
              fontSize: 38,
              fontFamily: 'Didot',
              color: PRIMARY_COLOR,
            ),
          ),
        ),
        Spacer(),
        Spacer(),
        Spacer(),
        Column(
          children: [
            buildLoginBtns(2),
            divider,
            buildLoginBtns(1),
            divider,
            buildLoginBtns(0),
            divider,
            buildLoginBtns(3),
          ],
        ),
        Spacer(),
        Spacer(),
        Spacer(),
      ],
    );
  }

  Widget buildIcons(int i) {
    return Container(
      child: icons[i],
      decoration: BoxDecoration(
          border: Border.all(
            color: colors[i],
            width: 2,
          ),
          borderRadius: BorderRadius.circular(100)),
    );
  }

  Widget buildLoginBtns(int i) {
    List<String> title = ['Twitter', 'Facebook', 'Google', 'Apple'];
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: PRIMARY_COLOR,
            content: Text('Logged in with ' + title[i]),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: size.width * 0.65,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: colors[i],
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: icons[i],
            ),
            VerticalDivider(color: colors[i], thickness: 2),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: Text(
                'Login with ${title[i]}',
                style: TextStyle(
                  color: DARK_GRAY,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'AvenirNext',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Color> colors = [
  Color(0xff1DA1F2),
  Color(0xff3b5998),
  Color(0xffde5246),
  Color(0xff707070),
];
List<IconButton> icons = [
  IconButton(
      onPressed: () {}, icon: Icon(Ionicons.logo_twitter), color: colors[0]),
  IconButton(
      onPressed: () {}, icon: Icon(Ionicons.logo_facebook), color: colors[1]),
  IconButton(
      onPressed: () {}, icon: Icon(Ionicons.logo_google), color: colors[2]),
  IconButton(
      onPressed: () {}, icon: Icon(Ionicons.logo_apple), color: colors[3]),
];
