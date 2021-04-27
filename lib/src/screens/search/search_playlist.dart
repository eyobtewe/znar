import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../external_src/flappy_search_bar/flappy_search_bar.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchPlaylistScreen extends StatefulWidget {
  @override
  _SearchPlaylistScreenState createState() => _SearchPlaylistScreenState();
}

class _SearchPlaylistScreenState extends State<SearchPlaylistScreen> {
  final SearchBarController<Playlist> _searchBarController =
      SearchBarController();

  ApiBloc bloc;

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
    bloc = ApiProvider.of(context);
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  SearchBar<Playlist> buildBody(BuildContext context) {
    return SearchBar<Playlist>(
      searchBarPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      onSearch: _onSearch,
      searchBarController: _searchBarController,
      searchBarStyle: searchBarStyle,
      icon: IconButton(
          color: IconTheme.of(context).color,
          icon: const Icon(Icons.arrow_back, size: 26),
          onPressed: () {
            Navigator.pop(context);
          }),
      minimumChars: 3,
      hintText: Language.locale(uiBloc.language, 'search_playlist'),
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            fontFamilyFallback: f,
            color: GRAY,
          ),
      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(
            fontFamilyFallback: f,
          ),
      buildSuggestion: (Playlist playlist, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailScreen(playlist: playlist),
                ));
          },
          child: result(playlist),
        );
      },
      cancellationWidget: const Icon(Icons.clear),
      emptyWidget: emptyWidget,
      loader: const CustomLoader(),
      mainAxisSpacing: 10,
      shrinkWrap: true,
      onItemFound: (Playlist playlist, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailScreen(playlist: playlist),
                ));
          },
          child: result(playlist),
        );
      },
    );
  }

  Widget result(Playlist playlist) {
    return ListTile(
      leading: Container(
        constraints: BoxConstraints(
            minHeight: 32, minWidth: 32, maxHeight: 40, maxWidth: 40),
        child: CachedPicture(image: playlist.featureImage ?? ''),
      ),
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(playlist.featureImage ?? ''),
      // ),
      title: Text(playlist.name),
      dense: true,
    );
  }

  Future<List<Playlist>> _onSearch(String term) async {
    return bloc.searchPlayLists(term);
  }
}
