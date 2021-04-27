import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../external_src/flappy_search_bar/flappy_search_bar.dart';
import '../../external_src/flappy_search_bar/search_bar_style.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchHomeScreen extends StatefulWidget {
  final int filter;
  final bool isLocal;

  const SearchHomeScreen({Key key, this.filter, this.isLocal})
      : super(key: key);
  @override
  _SearchHomeScreenState createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends State<SearchHomeScreen> {
  final SearchBarController<dynamic> _searchBarController =
      SearchBarController();

  int _value;
  @override
  void initState() {
    super.initState();

    _value = widget.filter ?? 2;
  }

  ApiBloc bloc;
  Size size;
  PlayerBloc playerBloc;
  UiBloc uiBloc;

  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  SearchBar<dynamic> buildBody(BuildContext context) {
    return SearchBar<dynamic>(
      header: buildRow(),
      headerPadding: EdgeInsets.zero,
      onSearch: _onSearch,
      searchBarController: _searchBarController,
      searchBarStyle: searchBarStyle,
      icon: buildLeadingIcon(),
      minimumChars: 3,
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            fontFamilyFallback: f,
            color: GRAY,
          ),
      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(
            fontFamilyFallback: f,
          ),
      hintText: Language.locale(uiBloc.language, 'search_sth'),
      buildSuggestion: buildSuggestion,
      cancellationWidget: Icon(
        Icons.clear,
        color: IconTheme.of(context).color,
      ),
      emptyWidget: emptyWidget,
      loader: const CustomLoader(),
      mainAxisSpacing: 10,
      shrinkWrap: true,
      onItemFound: buildSuggestion,
    );
  }

  Widget buildLeadingIcon() {
    return IconButton(
      color: IconTheme.of(context).color,
      icon: const Icon(Icons.arrow_back, size: 26),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget buildSuggestion(dynamic item, int index) {
    return InkWell(
      onTap: () {
        switch (_value) {
          case 0:
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => ArtistDetailScreen(
                          artist: item,
                        )));
          case 1:
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => AlbumDetailScreen(
                          album: item,
                        )));
          case 2:
            {
              if (playerBloc.audioPlayer != null) {
                playerBloc.audioPlayer.stop();
              }
              playerBloc.audioInit(0, [item], widget?.isLocal ?? false, false);
              return Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => AudioPlayerScreen(
                            isFromBottomBar: false,
                            songs: [item],
                            i: 0,
                            isLocal: false,
                          )));
            }
          case 3:
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => CustomWebPage(
                          url: item.url,
                          title: item?.channel?.name ?? '',
                          musicVideo: item,
                        )));
          case 4:
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => PlaylistDetailScreen(
                          playlist: item,
                        )));
          default:
            return null;
        }
      },
      child: result(item),
    );
  }

  Widget buildRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
            choices.length,
            (int index) {
              return ChoiceChip(
                label: Text(
                  Language.locale(
                      uiBloc.language, choices[index].toLowerCase()),
                  style: const TextStyle(
                    color: PURE_WHITE,
                    fontFamilyFallback: f,
                  ),
                ),
                padding: EdgeInsets.zero,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                selectedColor: PRIMARY_COLOR,
                selected: _value == index,
                onSelected: (bool selected) {
                  setState(() {
                    _value = selected ? index : null;
                  });
                  _searchBarController.replayLastSearch();
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget result(dynamic item) {
    switch (_value) {
      case 0:
        return SearchArtistScreen(isLocal: false).createState().result(item);
      case 1:
        return SearchAlbumScreen(isLocal: false).createState().result(item);
      case 2:
        return SearchSongScreen(isLocal: false).createState().result(item);
      case 3:
        return SearchMusicVideoScreen().createState().result(item);
      case 4:
        return SearchPlaylistScreen().createState().result(item);
      default:
        return null;
    }
  }

  Future<List<dynamic>> _onSearch(String term) async {
    switch (_value) {
      case 0:
        return bloc.searchArtist(term);
      case 1:
        return bloc.searchAlbums(term);
      case 2:
        return bloc.searchSongs(term);
      case 3:
        return bloc.searchMusicVideos(term);
      case 4:
        return bloc.searchPlayLists(term);
      default:
        return null;
    }
  }
}

const List<String> choices = [
  'Artists',
  'Albums',
  'Songs',
  'Videos',
  'Charts',
];

final SearchBarStyle searchBarStyle = SearchBarStyle(
  borderRadius: BorderRadius.zero,
  padding: EdgeInsets.zero,
);

final Widget emptyWidget = Center(
  child: Text(
    "Sorry 0 results",
    style: const TextStyle(fontFamilyFallback: f),
  ),
);
