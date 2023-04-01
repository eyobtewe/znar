// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../presentation/bloc.dart';
import '../screens/screens.dart';
import '../screens/search/search.dart';

MaterialPageRoute _route(Widget screen) {
  return MaterialPageRoute(builder: (BuildContext context) {
    final UiBloc uiBloc = UiProvider.of(context);
    final LocalSongsBloc localSongsBloc = LocalSongsProvider.of(context);
    uiBloc.init();
    localSongsBloc.init();
    return screen;
  });
}

Route onGeneratedRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _route(const SplashScreen());
    case LOCAL_SONGS_PAGE_ROUTE:
    //   return _route(LocalScreen());
    case HOME_PAGE_ROUTE:
      String args = settings.arguments;
      return _route(Home(key: Key(args ?? 'INIT')));
    case MUSIC_VIDEOS_PAGE_ROUTE:
      return _route(const MusicVideoScreen());
    case SONGS_PAGE_ROUTE:
      return _route(const SongScreen());
    case PLAYLISTS_PAGE_ROUTE:
      return _route(const PlaylistsScreen());
    case ALBUMS_PAGE_ROUTE:
      return _route(const AlbumScreen());
    case SEARCH_MUSIC_VIDEOS_PAGE_ROUTE:

    case SEARCH_SONGS_PAGE_ROUTE:
      return _route(const SearchPage(trigger: true));
    case PROFILE_PAGE_ROUTE:
      return _route(const ProfileScreen());
    case DOWNLOADS_PAGE_ROUTE:
      return _route(const DownloadedSongsScreen());

    case SEARCH_LOCAL_SONGS_PAGE_ROUTE:

    case SEARCH_PLAYLISTS_PAGE_ROUTE:

    case SEARCH_ALBUMS_PAGE_ROUTE:

    case SEARCH_LOCAL_ALBUMS_PAGE_ROUTE:

    case SEARCH_ARTISTS_PAGE_ROUTE:

    case SEARCH_LOCAL_ARTISTS_PAGE_ROUTE:

    case SEARCH_HOME_PAGE_ROUTE:

    case ARTISTS_PAGE_ROUTE:
      return _route(const ArtistScreen());
    case ANNOUNCEMENTS_PAGE_ROUTE:
      return _route(const AnnouncementScreen());
    case SETTINGS_PAGE_ROUTE:
      return _route(const SettingScreen());
    default:
      return _route(const SplashScreen());
  }
}

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
const String DOWNLOADS_PAGE_ROUTE = '/downloads-page';

const String SEARCH_MUSIC_VIDEOS_PAGE_ROUTE = '/search-music-videos';
const String SEARCH_SONGS_PAGE_ROUTE = '/search-songs';
const String SEARCH_LOCAL_SONGS_PAGE_ROUTE = '/search-local-songs';
const String SEARCH_PLAYLISTS_PAGE_ROUTE = '/search-playlists';
const String SEARCH_ALBUMS_PAGE_ROUTE = '/search-albums';
const String SEARCH_LOCAL_ALBUMS_PAGE_ROUTE = '/search-local-albums';
const String SEARCH_ARTISTS_PAGE_ROUTE = '/search-artists';
const String SEARCH_LOCAL_ARTISTS_PAGE_ROUTE = '/search-local-artists';
const String SEARCH_HOME_PAGE_ROUTE = '/search-home';
