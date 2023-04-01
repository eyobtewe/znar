import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/ui_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key key, @required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final uBloc = UiProvider.of(context);

    TextStyle textStyle = const TextStyle(
      fontFamilyFallback: f,
      fontSize: 12,
      height: 1.5,
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: cCanvasBlack),
        ),
      ),
      child: BottomNavigationBar(
        selectedLabelStyle: textStyle,
        unselectedLabelStyle: textStyle,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.grid_outline),
            label: Language.locale(uBloc.language, 'discover'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Ionicons.videocam),
          //   label: Language.locale(uBloc.language, 'videos'),
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Ionicons.search_outline),
          //   label: Language.locale(uBloc.language, 'search'),
          // ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.musical_note_outline),
            label: Language.locale(uBloc.language, 'songs'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.people_outline),
            label: Language.locale(uBloc.language, 'artists'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Ionicons.download_outline),
            label: Language.locale(uBloc.language, 'library'),
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
            // case 1:
            //   showSearch(
            //       context: context,
            //       delegate: SongSearch(MEDIA.SONG));
            //   break;
            case 1:
              Navigator.pushReplacementNamed(context, SONGS_PAGE_ROUTE);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, ARTISTS_PAGE_ROUTE);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, DOWNLOADS_PAGE_ROUTE);
              break;
            default:
              Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
              break;
          }
        },
        fixedColor: cPrimaryColor,
        showUnselectedLabels: true,
        unselectedItemColor: cGray,
        backgroundColor: cBackgroundColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
