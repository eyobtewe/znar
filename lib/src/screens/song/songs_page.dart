import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../search/search.dart';
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
      body: Stack(
        children: [
          buildBody(),
          ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: bloc.fetchSongs(page, 30),
      initialData: bloc.songs,
      builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              // const SliverAppBar(),
              buildSliverAppBar(context),

              const SliverFillRemaining(child: const CustomLoader()),
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
                SliverToBoxAdapter(
                  child: ListView.separated(
                    primary: false,
                    itemBuilder: (BuildContext ctx, int k) {
                      return SongTile(songs: bloc.songs, index: k);
                    },
                    separatorBuilder: (BuildContext ctx, int k) {
                      return Divider(height: 1);
                    },
                    itemCount: bloc.songs.length,
                    shrinkWrap: true,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 66),
                ),
                // SliverList(
                //   delegate: SliverChildBuilderDelegate(
                //     (BuildContext ctx, int i) {
                //       return SongTile(songs: bloc.songs, index: i);
                //     },
                //     childCount: bloc.songs?.length ?? 0,
                //   ),
                // ),
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
        // snapshot.isNotEmpty
        //     ? IconButton(
        //         icon: const Icon(Ionicons.play),
        //         onPressed: () {
        //           if (playerBloc.audioPlayer != null) {
        //             playerBloc.audioPlayer.stop();
        //           }
        //           playerBloc.audioInit(0, snapshot);
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (BuildContext ctx) =>
        //                   AudioPlayerScreen(songs: snapshot, i: 0),
        //             ),
        //           );
        //         },
        //       )
        //     : Container(),
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SongSearch(CustomAspectRatio.SONG));
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
      mini: true,
      child: Icon(Ionicons.play),
      onPressed: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(0, songs);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext ctx) =>
                AudioPlayerScreen(songs: songs, i: 0),
          ),
        );
      },
    );
  }
}
