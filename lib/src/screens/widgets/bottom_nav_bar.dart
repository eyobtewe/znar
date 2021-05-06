import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:znar/src/core/core.dart';
import 'package:znar/src/screens/screens.dart';
import 'package:znar/src/screens/search/search.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key key,
    @required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.grid_outline),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.search_outline),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.musical_notes_outline),
          label: 'Playlists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.people),
          label: 'Artists',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Ionicons.person_outline),
        //   label: 'Profile',
        // ),
      ],
      currentIndex: currentIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, HOME_PAGE_ROUTE);
            break;
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
          // case 3:
          //   Navigator.pushReplacementNamed(context, PROFILE_PAGE_ROUTE);
          //   break;
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
