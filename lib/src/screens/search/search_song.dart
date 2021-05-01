import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../external_src/flappy_search_bar/flappy_search_bar.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchSongScreen extends StatefulWidget {
  final bool isLocal;

  const SearchSongScreen({Key key, this.isLocal = false}) : super(key: key);
  @override
  _SearchSongScreenState createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  final SearchBarController<dynamic> _searchBarController =
      SearchBarController();

  ApiBloc bloc;
  LocalSongsBloc localSongsBloc;
  PlayerBloc playerBloc;
  UiBloc uiBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);
    playerBloc = PlayerProvider.of(context);
    uiBloc = UiProvider.of(context);
    if (widget.isLocal ?? false) {
      localSongsBloc = LocalSongsProvider.of(context);
    } else {
      bloc = ApiProvider.of(context);
    }
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  SearchBar<dynamic> buildBody(BuildContext context) {
    return SearchBar<dynamic>(
      onSearch: _onSearch,
      searchBarController: _searchBarController,
      searchBarStyle: searchBarStyle,
      icon: buildIconButton(context),
      minimumChars: widget.isLocal ? 1 : 3,
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            fontFamilyFallback: f,
            color: GRAY,
          ),
      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(
            fontFamilyFallback: f,
          ),
      hintText: Language.locale(uiBloc.language, 'search_song'),
      buildSuggestion: (dynamic song, int index) {
        return buildInkWell(index, song, context);
      },
      cancellationWidget: const Icon(Icons.clear),
      emptyWidget: emptyWidget,
      loader: const CustomLoader(),
      mainAxisSpacing: 10,
      shrinkWrap: true,
      onItemFound: (dynamic song, int index) {
        return buildInkWell(index, song, context);
      },
    );
  }

  IconButton buildIconButton(BuildContext context) {
    return IconButton(
        color: IconTheme.of(context).color,
        icon: const Icon(Icons.arrow_back, size: 26),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  InkWell buildInkWell(int index, dynamic song, BuildContext context) {
    return InkWell(
      onTap: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(
            index, [song], song.runtimeType == SongInfo, false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AudioPlayerScreen(
              songs: [song],
              i: 0,
              isLocal: song.runtimeType == SongInfo,
            ),
          ),
        );
      },
      child: result(song),
    );
  }

  Widget result(dynamic song) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: widget?.isLocal ?? false
            ? NetworkImage(song.albumArtwork ?? '')
            : FileImage(
                File(song.coverArt),
              ),
      ),
      title: Text(song.title),
      subtitle: Text(
        widget?.isLocal ?? false
            ? song.artist
            : song.artistStatic?.stageName ?? '',
        style: const TextStyle(color: GRAY),
      ),
      dense: true,
    );
  }

  Future<List> _onSearch(String term) async {
    return widget.isLocal ?? false
        ? await localSongsBloc.searchSongs(term)
        : await bloc.searchSongs(term);
  }
}
