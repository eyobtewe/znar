import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../home/widgets/widgets.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  final CustomAspectRatio ar;

  const SearchPage({Key key, this.ar}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return query != '' ? buildFutureBuilder(bloc) : buildPlaceHolder(uiBloc);
  }

  ListView buildPlaceHolder(UiBloc uiBloc) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        buildDivider(),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.PLAYLIST,
          title: Language.locale(uiBloc.language, 'trending_playlists'),
        ),
        // buildDivider(),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.SONG,
          title: Language.locale(uiBloc.language, 'songs'),
        ),
      ],
    );
  }

  FutureBuilder<List<Song>> buildFutureBuilder(ApiBloc bloc) {
    return FutureBuilder(
      future: ar == CustomAspectRatio.SONG
          ? bloc.searchSongs(query)
          : bloc.searchPlayLists(query),
      builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return CustomLoader();
        } else {
          return ListView.builder(
            itemBuilder: (BuildContext ctx, int k) {
              return SongTile(songs: bloc.songs, index: k);
            },
            itemCount: snapshot.data.length,
            shrinkWrap: true,
          );
        }
      },
    );
  }
}
