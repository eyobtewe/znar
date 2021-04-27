import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool chip1 = true;
  bool chip2 = false;

  UiBloc uiBloc;
  int _value;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    uiBloc = UiProvider.of(context);
    checkLanguage();

    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomScreenPlayer(),
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HOME_PAGE_ROUTE, (Route<dynamic> route) => false);
              }),
          title: Text(
            Language.locale(uiBloc.language, 'setting'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamilyFallback: f,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.05, horizontal: size.width * 0.1),
          child: Column(
            children: <Widget>[
              // Wrap(
              //   direction: Axis.horizontal,
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: ChoiceChip(
              //         label: Text(
              //           'English',
              //           style: TextStyle(
              //             color: chip1 ? PURE_WHITE : BACKGROUND,
              //             fontWeight: chip1 ? FontWeight.bold : FontWeight.normal,
              //           ),
              //         ),
              //         selectedColor: PRIMARY_COLOR,
              //         selected: chip1,
              //         onSelected: (bool selected) {
              //           if (selected) {
              //             setState(() {
              //               chip1 = selected;
              //               chip2 = !selected;
              //             });
              //             changeLanguage();
              //           }
              //         },
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: ChoiceChip(
              //         label: Text(
              //           'አማርኛ',
              //           style: TextStyle(
              //             fontFamilyFallback: f,
              //             color: chip2 ? PURE_WHITE : BACKGROUND,
              //             fontWeight: chip2 ? FontWeight.bold : FontWeight.normal,
              //           ),
              //         ),
              //         selectedColor: PRIMARY_COLOR,
              //         selected: chip2,
              //         onSelected: (bool selected) {
              //           if (selected) {
              //             setState(() {
              //               chip1 = !selected;
              //               chip2 = selected;
              //             });
              //             changeLanguage();
              //           }
              //         },
              //       ),
              //     ),
              //   ],
              // )
              Wrap(
                children: List<Widget>.generate(
                  langs.length,
                  (int index) {
                    return ChoiceChip(
                      label: Text(
                        langs[index],
                        style: const TextStyle(
                          color: PURE_WHITE,
                          fontFamilyFallback: f,
                        ),
                      ),
                      // padding: EdgeInsets.zero,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      selectedColor: PRIMARY_COLOR,
                      selected: _value == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _value = selected ? index : null;
                        });
                        changeLanguage();
                      },
                    );
                  },
                ).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> langs = const ['English', 'አማርኛ'];

  void changeLanguage() async {
    if (_value == 0) {
      uiBloc.language = 'en';
    } else {
      uiBloc.language = 'am';
    }
    await uiBloc.preferences.setString('lang', '${uiBloc.language}');
  }

  void checkLanguage() {
    String l = uiBloc.language;
    if (l == 'en') {
      setState(() {
        _value = 0;
        chip1 = true;
        chip2 = !chip1;
      });
    } else {
      setState(() {
        _value = 1;
        chip1 = false;
        chip2 = !chip1;
      });
    }
  }
}
