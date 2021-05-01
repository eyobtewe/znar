import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class LocalSongsScreen extends StatefulWidget {
  final String categoryTitle;

  const LocalSongsScreen({Key key, this.categoryTitle}) : super(key: key);
  @override
  _LocalSongsScreenState createState() => _LocalSongsScreenState();
}

class _LocalSongsScreenState extends State<LocalSongsScreen> {
  LocalSongsBloc bloc;
  UiBloc uiBloc;
  ScrollController myScrollController;

  @override
  void initState() {
    super.initState();

    myScrollController = ScrollController();
  }

  Widget build(BuildContext context) {
    bloc = LocalSongsProvider.of(context);
    uiBloc = UiProvider.of(context);

    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: BottomScreenPlayer(),
      body: FutureBuilder(
        future: bloc.buildFutures(widget.categoryTitle),
        initialData: bloc.buildInitialData(widget.categoryTitle),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CustomLoader();
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                '0 ' + 'songs',
                style: TextStyle(fontFamilyFallback: f),
              ),
            );
          } else {
            return buildBody(bloc.buildInitialData(widget.categoryTitle),
                widget.categoryTitle);
          }
        },
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            String _route = SEARCH_LOCAL_SONGS_PAGE_ROUTE;
            switch (widget.categoryTitle) {
              case 'Songs':
                _route = SEARCH_LOCAL_SONGS_PAGE_ROUTE;
                break;
              case 'Artists':
                _route = SEARCH_LOCAL_ARTISTS_PAGE_ROUTE;
                break;
              case 'Albums':
                _route = SEARCH_LOCAL_ALBUMS_PAGE_ROUTE;
                break;
              default:
                _route = SEARCH_LOCAL_SONGS_PAGE_ROUTE;
                break;
            }
            Navigator.pushNamed(context, _route);
          },
        ),
      ],
      title: Text(
        Language.locale(uiBloc.language, widget.categoryTitle.toLowerCase()),
        style: TextStyle(fontFamilyFallback: f),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody(dynamic snapshot, String categoryTitle) {
    return Container(
      child: DraggableScrollbar.rrect(
        scrollThumbKey: pageStorage[categoryTitle],
        backgroundColor: Theme.of(context).canvasColor,
        scrollbarAnimationDuration: Duration.zero,
        heightScrollThumb: 30,
        controller: myScrollController,
        child: (categoryTitle != tabs[1] && categoryTitle != tabs[2])
            ? buildListView(categoryTitle, snapshot)
            : buildGridView(categoryTitle, snapshot),
      ),
    );
  }

  Widget buildGridView(String categoryTitle, dynamic snapshot) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      controller: myScrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: categoryTitle == tabs[2] ? 0.6 : 1,
      ),
      itemCount: snapshot.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, int i) {
        switch (categoryTitle) {
          case 'Artists':
            return ArtistThumbnail(artist: snapshot[i]);
          case 'Albums':
            return AlbumThumbnail(album: snapshot[i]);
          default:
            return Container();
        }
      },
    );
  }

  Widget buildListView(String categoryTitle, List<SongInfo> snapshot) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: categoryTitle == tabs[0] ? 0 : 16,
      ),
      controller: myScrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return SongTile(songs: snapshot, index: index);
      },
    );
  }
}

final Map<String, PageStorageKey> pageStorage = {
  tabs[0]: PageStorageKey('songs'),
  tabs[1]: PageStorageKey('artists'),
  tabs[2]: PageStorageKey('albums'),
  tabs[3]: PageStorageKey('downloaded_songs'),
};

const tabs = <String>[
  'Songs',
  'Artists',
  'Albums',
  'downloaded_songs',
];