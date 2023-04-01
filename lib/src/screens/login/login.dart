import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
    var divider = const Divider(color: Colors.transparent, height: 10);
    return Column(
      children: [
        const Spacer(),
        const Spacer(),
        const Spacer(),
        Container(
          decoration: const BoxDecoration(),
          child: const Text(
            'ZNAR',
            style: TextStyle(
              fontSize: 38,
              fontFamily: 'Didot',
              color: cPrimaryColor,
            ),
          ),
        ),
        const Spacer(),
        const Spacer(),
        const Spacer(),
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
        const Spacer(),
        const Spacer(),
        const Spacer(),
      ],
    );
  }

  Widget buildIcons(int i) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: colors[i],
            width: 2,
          ),
          borderRadius: BorderRadius.circular(100)),
      child: icons[i],
    );
  }

  Widget buildLoginBtns(int i) {
    List<String> title = ['Twitter', 'Facebook', 'Google', 'Apple'];
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cPrimaryColor,
            content: Text('Logged in with ${title[i]}'),
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
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: icons[i],
            ),
            VerticalDivider(color: colors[i], thickness: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Text(
                'Login with ${title[i]}',
                style: const TextStyle(
                  color: cDarkGray,
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
  const Color(0xff1DA1F2),
  const Color(0xff3b5998),
  const Color(0xffde5246),
  const Color(0xff707070),
];
List<IconButton> icons = [
  IconButton(
      onPressed: () {},
      icon: const Icon(Ionicons.logo_twitter),
      color: colors[0]),
  IconButton(
      onPressed: () {},
      icon: const Icon(Ionicons.logo_facebook),
      color: colors[1]),
  IconButton(
      onPressed: () {},
      icon: const Icon(Ionicons.logo_google),
      color: colors[2]),
  IconButton(
      onPressed: () {},
      icon: const Icon(Ionicons.logo_apple),
      color: colors[3]),
];
