import 'package:flutter/material.dart';
import 'package:znar/src/screens/search/search.dart';

import '../presentation/bloc.dart';
import '../screens/screens.dart';

const String HOME_PAGE_ROUTE = '/home';
const String PROFILE_PAGE_ROUTE = '/profile';
const String LOCAL_SONGS_PAGE_ROUTE = '/local-songs';
const String SETTINGS_PAGE_ROUTE = '/setting';
const String MUSIC_VIDEOS_PAGE_ROUTE = '/music-videos-page';
const String SONGS_PAGE_ROUTE = '/songs-page';
const String PLAYLISTS_PAGE_ROUTE = '/playlists-page';
const String ALBUMS_PAGE_ROUTE = '/albums-page';
const String ARTISTS_PAGE_ROUTE = '/artists-page';
const String ANNOUNCEMENTS_PAGE_ROUTE = '/announcements-page';

const String SEARCH_MUSIC_VIDEOS_PAGE_ROUTE = '/search-music-videos';
const String SEARCH_SONGS_PAGE_ROUTE = '/search-songs';
const String SEARCH_LOCAL_SONGS_PAGE_ROUTE = '/search-local-songs';
const String SEARCH_PLAYLISTS_PAGE_ROUTE = '/search-playlists';
const String SEARCH_ALBUMS_PAGE_ROUTE = '/search-albums';
const String SEARCH_LOCAL_ALBUMS_PAGE_ROUTE = '/search-local-albums';
const String SEARCH_ARTISTS_PAGE_ROUTE = '/search-artists';
const String SEARCH_LOCAL_ARTISTS_PAGE_ROUTE = '/search-local-artists';
const String SEARCH_HOME_PAGE_ROUTE = '/search-home';

MaterialPageRoute _route(Widget _screen) {
  return MaterialPageRoute(builder: (BuildContext context) {
    final UiBloc uiBloc = UiProvider.of(context);
    final LocalSongsBloc localSongsBloc = LocalSongsProvider.of(context);
    uiBloc.init();
    localSongsBloc.init();
    return _screen;
  });
}

Route onGeneratedRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _route(SplashScreen());
    case LOCAL_SONGS_PAGE_ROUTE:
      return _route(LocalScreen());
    case HOME_PAGE_ROUTE:
      String args = settings.arguments;
      return _route(Home(key: Key(args ?? 'INIT')));
    case MUSIC_VIDEOS_PAGE_ROUTE:
      return _route(MusicVideoScreen());
    case SONGS_PAGE_ROUTE:
      return _route(SongScreen());
    case PLAYLISTS_PAGE_ROUTE:
      return _route(PlaylistsScreen());
    case ALBUMS_PAGE_ROUTE:
      return _route(AlbumScreen());
    case SEARCH_MUSIC_VIDEOS_PAGE_ROUTE:

    case SEARCH_SONGS_PAGE_ROUTE:
      return _route(SearchPage(trigger: true));
    case PROFILE_PAGE_ROUTE:
      return _route(ProfileScreen());

    case SEARCH_LOCAL_SONGS_PAGE_ROUTE:

    case SEARCH_PLAYLISTS_PAGE_ROUTE:

    case SEARCH_ALBUMS_PAGE_ROUTE:

    case SEARCH_LOCAL_ALBUMS_PAGE_ROUTE:

    case SEARCH_ARTISTS_PAGE_ROUTE:

    case SEARCH_LOCAL_ARTISTS_PAGE_ROUTE:

    case SEARCH_HOME_PAGE_ROUTE:

    case ARTISTS_PAGE_ROUTE:
      return _route(ArtistScreen());
    case ANNOUNCEMENTS_PAGE_ROUTE:
      return _route(AnnouncementScreen());
    case SETTINGS_PAGE_ROUTE:
      return _route(SettingScreen());
    default:
      return _route(SplashScreen());
  }
}
