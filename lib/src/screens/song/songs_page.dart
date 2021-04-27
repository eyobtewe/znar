import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app.dart';
import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class SongScreen extends StatefulWidget {
  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  int page = 1;
  ScrollController scrollController;
  LocalSongsBloc localBloc;
  // List<DownloadedSong> downloadedSongs;

  // getDownloads() async {
  //   downloadedSongs = await localBloc.getDownloadedMusic(Theme.of(context).platform);
  // }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_listener);
  }

  void _listener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      setState(() {
        page++;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();
    super.dispose();
  }

  PlayerBloc playerBloc;
  ApiBloc bloc;
  Size size;
  UiBloc uiBloc;

  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    localBloc = LocalSongsProvider.of(context);
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    ScreenUtil.init(context, allowFontScaling: true, designSize: size);
    return Scaffold(
      bottomNavigationBar: BottomScreenPlayer(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: bloc.fetchSongs(page, 30),
      initialData: bloc.songs,
      builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return const CustomScrollView(
            slivers: [
              const SliverAppBar(),
              const SliverFillRemaining(child: const CustomLoader()),
            ],
          );
        } else {
          return CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              buildSliverAppBar(bloc.songs, context),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext ctx, int i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SongTile(songs: bloc.songs, index: i),
                    );
                  },
                  childCount: bloc.songs?.length ?? 0,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget buildSliverAppBar(List<Song> snapshot, BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // elevation: 0,
      centerTitle: true,
      title: Text(
        Language.locale(uiBloc.language, 'songs'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: f,
        ),
      ),
      actions: [
        snapshot.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.playlist_play),
                onPressed: () {
                  if (playerBloc.audioPlayer != null) {
                    playerBloc.audioPlayer.stop();
                  }
                  playerBloc.audioInit(0, snapshot);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext ctx) =>
                          AudioPlayerScreen(songs: snapshot, i: 0),
                    ),
                  );
                },
              )
            : Container(),
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_SONGS_PAGE_ROUTE);
            }),
      ],
    );
  }
}
