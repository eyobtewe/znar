import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  final MEDIA ar;
  final dynamic trigger;

  const SearchPage({Key key, this.ar, this.trigger = false}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.trigger) {
      showSearch(context: context, delegate: SongSearch(widget.ar));
    }
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Ionicons.search, color: cPrimaryColor),
            onPressed: () {
              showSearch(context: context, delegate: SongSearch(widget.ar));
            },
          ),
        ],
      ),
    );
  }
}

class SongSearch extends SearchDelegate<dynamic> {
  final MEDIA ar;

  SongSearch(this.ar);

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    assert(theme != null);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: colorScheme.brightness,
        ),
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: cGray),
        toolbarTextStyle: theme.textTheme.bodyText2,
        titleTextStyle: theme.textTheme.headline6,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Ionicons.close_sharp),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final bloc = ApiProvider.of(context);
    return query != ''
        ? FutureBuilder(
            future: buildFutures(ar, bloc),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CustomLoader();
              } else {
                return ListView.builder(
                  itemBuilder: (_, int k) {
                    switch (ar) {
                      case MEDIA.VIDEO:
                        return MusicVideoTile(musicVideo: snapshot.data[k]);
                      case MEDIA.SONG:
                        return SongTile(songs: snapshot.data, index: k);
                      case MEDIA.PLAYLIST:
                        return PlaylistTile(playlist: snapshot.data[k]);
                      case MEDIA.ARTIST:
                        return ArtistTile(artist: snapshot.data[k]);
                      default:
                        return PlaylistTile(playlist: snapshot.data[k]);
                    }
                  },
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                );
              }
            },
          )
        : Container();
    // : buildPlaceHolder(uiBloc);
  }

  Widget buildPlaceHolder(UiBloc uiBloc) {
    List<String> titles = [
      'Chill',
      'Sundays',
      'Happy',
      'Moody',
      'Tuesdays',
      'Club Nights'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: titles
            .map((e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cCanvasBlack,
                  ),
                  // margin: EdgeInsets.all(15),
                  child: Tab(
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: cPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
    // return ListView(
    //   physics: const BouncingScrollPhysics(),
    //   children: [
    //     buildDivider(),
    //     ThumbnailCards(
    //       ar: MEDIA.PLAYLIST,
    //       title: Language.locale(uiBloc.language, 'popular_playlists'),
    //     ),
    //     buildDivider(),
    //     ThumbnailCards(
    //       ar: MEDIA.SONG,
    //       title: Language.locale(uiBloc.language, 'songs'),
    //     ),
    //   ],
    // );
  }

  dynamic buildResultTile(MEDIA ar, List<dynamic> data, int k) async {}

  Future buildFutures(MEDIA ar, ApiBloc bloc) async {
    switch (ar) {
      case MEDIA.ALBUM:
        return bloc.searchAlbums(query);
      case MEDIA.ARTIST:
        return bloc.searchArtist(query);
      case MEDIA.PLAYLIST:
        return bloc.searchPlayLists(query);
      case MEDIA.VIDEO:
        return bloc.searchMusicVideos(query);
      case MEDIA.SONG:
        return bloc.searchSongs(query);

      default:
    }
  }
}
