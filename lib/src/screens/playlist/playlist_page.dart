import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../search/search.dart';
import '../widgets/widgets.dart';

class PlaylistsScreen extends StatefulWidget {
  final bool isHome;

  const PlaylistsScreen({Key key, this.isHome = false}) : super(key: key);
  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  Size size;
  ApiBloc bloc;
  @override
  void initState() {
    super.initState();
  }

  UiBloc uiBloc;
  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        // bottomNavigationBar: BottomNavBar(currentIndex: 2),
        appBar: widget.isHome ? null : buildAppBar(),
        body: Stack(
          children: [
            buildBody(),
            const ExpandableBottomPlayer(),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FutureBuilder(
          future: bloc.fetchOnlinePlayList(1, 20),
          initialData: bloc.onlinePlaylists,
          builder: (_, AsyncSnapshot<List<Playlist>> snapshot) {
            if (!snapshot.hasData) {
              return const CustomLoader();
            } else {
              return buildOnlinePlaylist(bloc.onlinePlaylists);
            }
          },
        ),
        // FutureBuilder(
        //   future: bloc.fetchLocalPlaylists(),
        //   initialData: bloc.localPlaylists,
        //   builder:
        //       (_, AsyncSnapshot<List<Playlist>> snapshot) {
        //     if (!snapshot.hasData) {
        //       return const CustomLoader();
        //     } else {
        //       return buildLocalPlaylist(snapshot.data);
        //     }
        //   },
        // ),
      ],
    );
  }

  Widget buildAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: SongSearch(MEDIA.PLAYLIST));
            }),
      ],
      centerTitle: false,
      // title: Text(
      //   Language.locale(uiBloc.language, 'playlists'),
      //   style: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     // fontSize: ScreenUtil().setSp(28),
      //     fontFamilyFallback: f,
      //   ),
      // ),
      // bottom: TabBar(
      //   labelPadding: const EdgeInsets.all(10),
      //   indicatorSize: TabBarIndicatorSize.label,
      //   tabs: [
      //     Text(
      //       Language.locale(uiBloc.language, 'online_playlists'),
      //       style: TextStyle(
      //         fontWeight: FontWeight.w600,
      //         fontSize: ScreenUtil().setSp(16),
      //         fontFamilyFallback: f,
      //       ),
      //     ),
      //     // Text(
      //     //   Language.locale(uiBloc.language, 'local_playlists'),
      //     //   style: TextStyle(
      //     //     fontWeight: FontWeight.w600,
      //     //     fontSize: ScreenUtil().setSp(16),
      //     //     fontFamilyFallback: f,
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }

  Widget buildContainer(ApiBloc bloc, List<Song> songs) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        // key: PageStorageKey('$ar'),
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        itemBuilder: (_, int i) {
          return HomeCards(
            ar: MEDIA.SONG,
            data: songs,
            i: i,
          );
        },
        itemCount: songs.length > 4 ? 4 : songs.length,
      ),
    );
  }

  Widget buildOnlinePlaylist(List<Playlist> playlists) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int k) {
              return SizedBox(
                // height: 200,
                width: size.width,
                child: FutureBuilder(
                    future: bloc.fetchPlaylistSong(playlists[k].sId),
                    initialData: bloc.playlistSongs[playlists[k].sId],
                    builder: (_, AsyncSnapshot<List<Song>> snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return Column(
                          children: [
                            const Divider(color: cTransparent),
                            buildPlaylistTitle(playlists[k],
                                bloc.playlistSongs[playlists[k].sId]),
                            const Divider(color: cTransparent),
                            buildContainer(
                                bloc, bloc.playlistSongs[playlists[k].sId]),
                          ],
                        );
                      }
                    }),
              );
            },
            childCount: playlists.length,
          ),
        ),
      ],
    );
    // return GridView.builder(
    //   physics: const BouncingScrollPhysics(),
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 3,
    //     childAspectRatio: 0.6,
    //   ),
    //   itemCount: playlists.length,
    //   shrinkWrap: true,
    //   primary: false,
    //   itemBuilder: (_, int i) =>
    //       PlaylistThumbnail(playlist: playlists[i]),
    // );
  }

  Container buildPlaylistTitle(Playlist playlist, List<Song> songs) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            playlist.name,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: ScreenUtil().setSp(18),
              fontFamilyFallback: f,
            ),
          ),
          songs.length < 5
              ? Container()
              // : IconButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) =>
              //               PlaylistDetailScreen(playlist: playlist),
              //         ),
              //       );
              //     },
              //     icon: Icon(
              //       Icons.chevron_right_rounded,
              //       size: 28,
              //       color: cPrimaryColor,
              //     ),
              //   ),
              : ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PlaylistDetailScreen(playlist: playlist),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    // elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(cBackgroundColor),
                    // visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: const BorderSide(
                            color: cCanvasBlack,
                            width: 2,
                          )),
                    ),
                  ),
                  child: Text(
                    Language.locale(uiBloc.language, 'more'),
                    style: const TextStyle(
                      color: cPrimaryColor,
                      fontFamilyFallback: f,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Widget buildLocalPlaylist(List<Playlist> playlists) {
  //   return Scaffold(
  //     floatingActionButton: widget.isHome
  //         ? null
  //         : FloatingActionButton(
  //             backgroundColor: cCanvasBlack,
  //             child: const Icon(Ionicons.add_circle),
  //             onPressed: () async {
  //               await showDialog(
  //                 context: context,
  //                 builder: (_) => CreatePlaylist(),
  //               );
  //               setState(() {});
  //             },
  //           ),
  //     body: ListView.separated(
  //       separatorBuilder: (_, int i) => Divider(),
  //       physics: const BouncingScrollPhysics(),
  //       itemCount: playlists.length,
  //       shrinkWrap: true,
  //       primary: false,
  //       itemBuilder: (_, int i) =>
  //           buildDismissible(playlists, i),
  //     ),
  //   );
  // }

  // Dismissible buildDismissible(List<Playlist> playlists, int i) {
  //   return Dismissible(
  //     background: Container(
  //       padding: const EdgeInsets.all(5),
  //       color: cRed.withOpacity(0.25),
  //       alignment: Alignment.centerRight,
  //       child: const Icon(Icons.delete),
  //     ),
  //     key: UniqueKey(),
  //     direction: DismissDirection.endToStart,
  //     onDismissed: (DismissDirection d) async {
  //       await bloc.removePlaylist(playlists[i]);
  //       Fluttertoast.showToast(
  //         msg: Language.locale(uiBloc.language, 'playlist_deleted'),
  //         backgroundColor: PURE_WHITE,
  //         textColor: cBackgroundColor,
  //       );
  //       setState(() {});
  //     },
  //     child: PlaylistTile(playlist: playlists[i]),
  //   );
  // }
}
