import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/ui_provider.dart';
import '../screens.dart';
import '../search/search.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key key, @required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final uBloc = UiProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    TextStyle _textStyle = TextStyle(
      fontFamilyFallback: f,
      fontSize: ScreenUtil().setSp(10),
    );

    return BottomNavigationBar(
      selectedLabelStyle: _textStyle,
      unselectedLabelStyle: _textStyle,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.grid_outline),
          label: Language.locale(uBloc.language, 'discover'),
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Ionicons.videocam),
        //   label: Language.locale(uBloc.language, 'videos'),
        // ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.search_outline),
          label: Language.locale(uBloc.language, 'search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.musical_notes_outline),
          label: Language.locale(uBloc.language, 'playlists_nav'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.people),
          label: Language.locale(uBloc.language, 'artists'),
        ),
      ],
      currentIndex: currentIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
            break;
          // case 1:
          //   Navigator.pushReplacementNamed(context, MUSIC_VIDEOS_PAGE_ROUTE);
          //   break;
          case 1:
            showSearch(
                context: context, delegate: SongSearch(CustomAspectRatio.SONG));
            break;
          case 2:
            Navigator.pushReplacementNamed(context, PLAYLISTS_PAGE_ROUTE);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, ARTISTS_PAGE_ROUTE);
            break;
          default:
            Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
            break;
        }
      },
      fixedColor: PRIMARY_COLOR,
      showUnselectedLabels: true,
      unselectedItemColor: GRAY,
      backgroundColor: BACKGROUND,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }
}
