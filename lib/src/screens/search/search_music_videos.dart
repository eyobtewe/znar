import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../external_src/flappy_search_bar/flappy_search_bar.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SearchMusicVideoScreen extends StatefulWidget {
  @override
  _SearchMusicVideoScreenState createState() => _SearchMusicVideoScreenState();
}

class _SearchMusicVideoScreenState extends State<SearchMusicVideoScreen> {
  final SearchBarController<MusicVideo> _searchBarController =
      SearchBarController();

  @override
  void initState() {
    super.initState();
  }

  ApiBloc bloc;

  UiBloc uiBloc;
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

  SearchBar<MusicVideo> buildBody(BuildContext context) {
    return SearchBar<MusicVideo>(
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
      hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(
            fontFamilyFallback: f,
            color: GRAY,
          ),
      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(
            fontFamilyFallback: f,
          ),
      hintText: Language.locale(uiBloc.language, 'search_video'),
      buildSuggestion: (MusicVideo musicVideo, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => CustomWebPage(
                          url: musicVideo.url,
                          title: musicVideo?.channel?.name ?? '',
                          musicVideo: musicVideo,
                        )));
          },
          child: result(musicVideo),
        );
      },
      cancellationWidget: const Icon(Icons.clear),
      emptyWidget: emptyWidget,
      loader: const CustomLoader(),
      mainAxisSpacing: 10,
      shrinkWrap: true,
      onItemFound: (MusicVideo musicVideo, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => CustomWebPage(
                          url: musicVideo.url,
                          title: musicVideo?.channel?.name ?? '',
                          musicVideo: musicVideo,
                        )));
          },
          child: result(musicVideo),
        );
      },
    );
  }

  Widget result(MusicVideo musicVideo) {
    return ListTile(
      leading: Container(
        constraints: BoxConstraints(
            minHeight: 32, minWidth: 57, maxHeight: 40, maxWidth: 71),
        child: CachedPicture(image: musicVideo.thumbnail ?? ''),
      ),
      title: Text(musicVideo.title ?? ''),
      subtitle: Text(
        musicVideo.artistStatic?.stageName ?? '',
        style: const TextStyle(color: GRAY),
      ),
      dense: true,
    );
  }

  Future<List<MusicVideo>> _onSearch(String term) async {
    return bloc.searchMusicVideos(term);
  }
}
