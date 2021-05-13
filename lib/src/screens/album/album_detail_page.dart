import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class AlbumDetailScreen extends StatefulWidget {
  final dynamic album;
  final String albumId;

  const AlbumDetailScreen({this.album, this.albumId});

  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  Size size;
  ApiBloc bloc;
  PlayerBloc playerBloc;
  LocalSongsBloc localSongsBloc;
  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    playerBloc = PlayerProvider.of(context);
    localSongsBloc = LocalSongsProvider.of(context);

    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return Scaffold(
      bottomNavigationBar: BottomScreenPlayer(),
      // floatingActionButton: HomeFAB(context: context),
      body: widget.albumId != null
          ? FutureBuilder(
              future: bloc.fetchAlbumDetails(widget.albumId),
              builder: (BuildContext context, AsyncSnapshot<Album> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: const CustomLoader());
                } else {
                  return buildBody(snapshot.data);
                }
              },
            )
          : buildBody(widget.album),
    );
  }

  Widget buildBody(dynamic album) {
    return FutureBuilder(
      future: album.runtimeType == Album
          ? bloc.fetchAlbumSongs(album.sId)
          : localSongsBloc.getSongsFromAlbum(album.id),
      initialData: album.runtimeType == Album
          ? bloc.albumsSongs[album.sId]
          : localSongsBloc.albumsSongs[album.id],
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const CustomScrollView(
            primary: true,
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              const SliverAppBar(),
              const SliverFillRemaining(child: const CustomLoader()),
            ],
          );
        } else {
          dynamic songs = snapshot.data;
          return Scaffold(
            floatingActionButton: PlayAllFAB(songs: songs),
            body: CustomScrollView(
              primary: true,
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                buildSliverAppBar(album, songs),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext ctx, int i) {
                      return SongTile(songs: songs, index: i);
                    },
                    childCount: songs.length,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  SliverAppBar buildSliverAppBar(dynamic album, dynamic songs) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      stretch: true,
      centerTitle: true,
      actions: [
        buildPlayBtn(songs),
        // album.runtimeType == Album
        //     ? IconButton(
        //         icon: Icon(Icons.share),
        //         onPressed: () async {
        //           final String link =
        //               await bloc.dynamikLinkService.createDynamicLink(album);
        //           kAnalytics.logShare(
        //               contentType: 'album',
        //               itemId: album.name,
        //               method: 'ShareAlbum');

        //           Share.share(
        //               'Checkout ${album.artistStatic.stageName}\'s album \n\n$link');
        //         },
        //       )
        //     : Container(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: buildTitle(album, songs),
        titlePadding: EdgeInsets.zero,
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.fadeTitle
        ],
        background: buildAppBarBackground(album),
      ),
      expandedHeight: size.width * 9 / 16,
    );
  }

  Container buildTitle(dynamic album, dynamic songs) {
    return Container(
      width: size.width,
      child: ListTile(
        leading: Container(width: 1, height: 1),
        // trailing: buildPlayBtn(songs),
        title: Text(
          album.runtimeType == Album ? album.name ?? '' : album.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamilyFallback: f),
        ),
        subtitle: Text(
          album.runtimeType == Album
              ? album.artistStatic?.stageName ?? ''
              : album.artist,
          style: const TextStyle(fontFamilyFallback: f),
        ),
        dense: true,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            TRANSPARENT,
          ],
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
        ),
      ),
    );
  }

  IconButton buildPlayBtn(songs) {
    return IconButton(
      icon: const Icon(
        Ionicons.play,
        size: 32,
      ),
      onPressed: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(0, songs, songs[0].runtimeType == SongInfo);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext ctx) => AudioPlayerScreen(
              songs: songs,
              i: 0,
              isLocal: songs[0].runtimeType == SongInfo,
            ),
          ),
        );
      },
    );
  }

  Widget buildAppBarBackground(dynamic album) {
    return album.runtimeType == Album
        ? CachedPicture(image: album.albumArt, isBackground: true)
        : CustomFileImage(img: album.albumArt);
  }
}
