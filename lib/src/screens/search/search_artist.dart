import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../external_src/flappy_search_bar/flappy_search_bar.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchArtistScreen extends StatefulWidget {
  final bool isLocal;

  const SearchArtistScreen({Key key, this.isLocal = false}) : super(key: key);

  @override
  _SearchArtistScreenState createState() => _SearchArtistScreenState();
}

class _SearchArtistScreenState extends State<SearchArtistScreen> {
  final SearchBarController<dynamic> _searchBarController =
      SearchBarController();

  ApiBloc bloc;

  LocalSongsBloc localSongsBloc;
  UiBloc uiBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    uiBloc = UiProvider.of(context);
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);
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
      hintText: Language.locale(uiBloc.language, 'search_artist'),
      buildSuggestion: (dynamic artist, int index) {
        return buildInkWell(context, artist);
      },
      cancellationWidget: const Icon(Icons.clear),
      emptyWidget: emptyWidget,
      loader: const CustomLoader(),
      mainAxisSpacing: 10,
      shrinkWrap: true,
      onItemFound: (dynamic artist, int index) {
        return buildInkWell(context, artist);
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

  InkWell buildInkWell(BuildContext context, artist) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArtistDetailScreen(artist: artist),
            ));
      },
      child: result(artist),
    );
  }

  Widget result(dynamic artist) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: widget?.isLocal ?? false
              ? FileImage(
                  File(artist.artistArtPath ?? ''),
                )
              : NetworkImage(artist.photo ?? '')),
      title: Text(widget?.isLocal ?? false
          ? artist.name ?? ''
          : artist.stageName ?? ''),
      dense: true,
    );
  }

  Future<List> _onSearch(String term) async {
    return widget.isLocal ?? false
        ? await localSongsBloc.searchArtists(term)
        : await bloc.searchArtist(term);
  }
}
