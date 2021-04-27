import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../external_src/flappy_search_bar/flappy_search_bar.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchAlbumScreen extends StatefulWidget {
  final bool isLocal;

  const SearchAlbumScreen({Key key, this.isLocal = false}) : super(key: key);
  @override
  _SearchAlbumScreenState createState() => _SearchAlbumScreenState();
}

class _SearchAlbumScreenState extends State<SearchAlbumScreen> {
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
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);
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
      minimumChars: widget.isLocal ?? false ? 1 : 3,
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            fontFamilyFallback: f,
            color: GRAY,
          ),
      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(
            fontFamilyFallback: f,
          ),
      hintText: Language.locale(uiBloc.language, 'search_album'),
      buildSuggestion: (dynamic album, int index) {
        return buildInkWell(context, album);
      },
      cancellationWidget: const Icon(Icons.clear),
      emptyWidget: emptyWidget,
      loader: const CustomLoader(),
      mainAxisSpacing: 10,
      shrinkWrap: true,
      onItemFound: (dynamic album, int index) {
        return buildInkWell(context, album);
      },
    );
  }

  InkWell buildInkWell(BuildContext context, album) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AlbumDetailScreen(album: album),
            ));
      },
      child: result(album),
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

  Widget result(dynamic album) {
    return ListTile(
      leading: Container(
        constraints: BoxConstraints(
            minHeight: 32, minWidth: 32, maxHeight: 40, maxWidth: 40),
        child: widget?.isLocal ?? false
            ? CustomFileImage(img: album.albumArt ?? '')
            : CachedPicture(image: album.albumArt ?? ''),
      ),
      title: Text(
        widget?.isLocal ?? false ? album.title ?? '' : album.name ?? '',
      ),
      subtitle: Text(
        widget?.isLocal ?? false
            ? album.artist ?? ''
            : album.artistStatic?.stageName ?? '',
        style: const TextStyle(color: GRAY, fontFamilyFallback: f),
      ),
      dense: true,
    );
  }

  Future<List> _onSearch(String term) async {
    return widget?.isLocal ?? false
        ? await localSongsBloc.searchAlbums(term)
        : await bloc.searchAlbums(term);
  }
}
