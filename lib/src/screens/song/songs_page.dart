import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:znar/src/core/core.dart';

import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../search/search.dart';
import '../widgets/widgets.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key key}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  int page = 1;
  ScrollController scrollController;
  // LocalSongsBloc localBloc;
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
  bool isGrid = false;

  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    // localBloc = LocalSongsProvider.of(context);
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          buildBody(),
          const ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: bloc.fetchSongs(page, 30),
      initialData: bloc.songs,
      builder: (_, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              buildSliverAppBar(context),
              const SliverFillRemaining(child: CustomLoader()),
            ],
          );
        } else {
          return Scaffold(
            floatingActionButton: PlayAllFAB(songs: bloc.songs),
            body: CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                buildSliverAppBar(context),
                isGrid
                    ? SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (_, int k) {
                            return SongThumbnail(i: k, song: bloc.songs);
                          },
                          childCount: bloc.songs.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, int k) {
                            return SongTile(songs: bloc.songs, index: k);
                          },
                          childCount: bloc.songs.length,
                        ),
                      ),
                const SliverToBoxAdapter(child: BottomPlayerSpacer()),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // centerTitle: true,
      // title: Text(
      //   Language.locale(uiBloc.language, 'songs'),
      //   style: const TextStyle(
      //     fontWeight: FontWeight.w800,
      //     fontFamilyFallback: f,
      //   ),
      // ),
      leading: IconButton(
          onPressed: () {
            uiBloc.toggleLanguage();
            setState(() {});
          },
          icon: const Icon(Ionicons.language)),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isGrid = !isGrid;
            });
          },
          icon: Icon(isGrid ? Ionicons.list : Ionicons.grid),
        ),
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              showSearch(context: context, delegate: SongSearch(MEDIA.SONG));
              // Navigator.pushNamed(context, SEARCH_SONGS_PAGE_ROUTE);
            }),
      ],
    );
  }
}

class PlayAllFAB extends StatelessWidget {
  const PlayAllFAB({Key key, @required this.songs}) : super(key: key);

  final List<dynamic> songs;

  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    return FloatingActionButton(
      elevation: 0,
      mini: true,
      child: const Icon(
        Ionicons.play,
        color: cBackgroundColor,
      ),
      onPressed: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(0, songs);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) =>
        //         AudioPlayerScreen(songs: songs, i: 0),
        //   ),
        // );
      },
    );
  }
}
