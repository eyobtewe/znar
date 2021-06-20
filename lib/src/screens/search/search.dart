import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  final CustomAspectRatio ar;
  final trigger;

  const SearchPage({Key key, this.ar, this.trigger = false}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.trigger) {
      showSearch(context: context, delegate: SongSearch(widget.ar));
    }
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Ionicons.search, color: PRIMARY_COLOR),
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
  final CustomAspectRatio ar;

  SongSearch(this.ar);

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    assert(theme != null);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        brightness: colorScheme.brightness,
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: GRAY),
        textTheme: theme.textTheme,
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
        icon: Icon(Ionicons.close_sharp),
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
    final uiBloc = UiProvider.of(context);
    final bloc = ApiProvider.of(context);
    return query != ''
        ? FutureBuilder(
            future: buildFutures(ar, bloc),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CustomLoader();
              } else {
                return ListView.builder(
                  itemBuilder: (_, int k) {
                    switch (ar) {
                      case CustomAspectRatio.VIDEO:
                        return MusicVideoTile(musicVideo: snapshot.data[k]);
                      case CustomAspectRatio.SONG:
                        return SongTile(songs: snapshot.data, index: k);
                      case CustomAspectRatio.PLAYLIST:
                        return PlaylistTile(playlist: snapshot.data[k]);
                      case CustomAspectRatio.ARTIST:
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
        : buildPlaceHolder(uiBloc);
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: titles
            .map((e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CANVAS_BLACK,
                  ),
                  // margin: EdgeInsets.all(15),
                  child: Tab(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: PRIMARY_COLOR,
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
    //       ar: CustomAspectRatio.PLAYLIST,
    //       title: Language.locale(uiBloc.language, 'popular_playlists'),
    //     ),
    //     buildDivider(),
    //     ThumbnailCards(
    //       ar: CustomAspectRatio.SONG,
    //       title: Language.locale(uiBloc.language, 'songs'),
    //     ),
    //   ],
    // );
  }

  dynamic buildResultTile(
      CustomAspectRatio ar, List<dynamic> data, int k) async {}

  Future buildFutures(CustomAspectRatio ar, ApiBloc bloc) async {
    switch (ar) {
      case CustomAspectRatio.ALBUM:
        return bloc.searchAlbums(query);
      case CustomAspectRatio.ARTIST:
        return bloc.searchArtist(query);
      case CustomAspectRatio.PLAYLIST:
        return bloc.searchPlayLists(query);
      case CustomAspectRatio.VIDEO:
        return bloc.searchMusicVideos(query);
      case CustomAspectRatio.SONG:
        return bloc.searchSongs(query);

      default:
    }
  }
}
