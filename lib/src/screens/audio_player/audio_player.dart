import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../infrastructure/services/download_manager.dart';
import '../../presentation/bloc.dart';
import '../home/explore.dart';
import '../widgets/widgets.dart';
import 'widgets/widgets.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<dynamic> songs;
  final int i;
  final bool isFromBottomBar;
  final bool isLocal;
  final bool isDownloaded;

  const AudioPlayerScreen(
      {this.songs,
      this.i,
      this.isFromBottomBar = false,
      this.isLocal = false,
      this.isDownloaded = false});
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  void initState() {
    super.initState();
  }

  PlayerBloc playerBloc;
  ApiBloc bloc;
  Size size;
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    bloc = ApiProvider.of(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,

      // floatingActionButton: HomeFAB(context: context),
      appBar: buildAppBar(),
      body: buildBody(),
      extendBody: true,
      // bottomSheet: Container(
      //   color: BACKGROUND,
      //   padding: EdgeInsets.only(bottom: 30),
      //   child: PlayerButtons(
      //     playing: playerBloc.audioPlayer?.current?.valueWrapper?.value,
      //     r: playerBloc.audioPlayer?.realtimePlayingInfos?.valueWrapper?.value,
      //   ),
      // ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: BACKGROUND.withOpacity(0),
      elevation: 0,
      // actions: (widget.isLocal || widget.isDownloaded)
      //     ? [Container()]
      //     : [
      //         IconButton(
      //           icon: Icon(Ionicons.download),
      //           onPressed: () async {
      //             DownloadsManager downloader = DownloadsManager();
      //             await downloader.downloadMusic(
      //                 TargetPlatform.iOS, widget.songs[widget.i]);
      //           },
      //         )
      //       ],
    );
  }

//   List<Widget> buildShareButton() {
//     return [
//       playerBloc.audioPlayer.builderCurrent(
//         builder: (BuildContext ctx, Playing playing) {
//           if (playing != null) {
//             if (playing.audio.audio.audioType != AudioType.network) {
//               return Container();
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.share),
//                 onPressed: () async {
//                   String tempTitle = playing.audio.audio.metas.title;
//                   String tempArtist = playing.audio.audio.metas.artist;
//                   Song tempSong = Song(
//                     sId: playing.audio.audio.metas.id,
//                     coverArt: playing.audio.audio.metas.image.path,
//                   );

//                   final String link =
//                       await bloc.dynamikLinkService.createDynamicLink(tempSong);
// ;

//                   Share.share(
//                       'Listen to $tempArtist\'s - $tempTitle  on IAAM streaming app \n$link');
//                 },
//               );
//             }
//           } else {
//             return Container();
//           }
//         },
//       ),
//     ];
//   }

  Widget buildBody() {
    // return playerBloc.audioPlayer.builderCurrent(
    //   builder: (BuildContext ctx, Playing playing) {
    //     if (playing == null) {
    //       return CustomLoader(isPlayer: true);
    //     }
    //     return playerBloc.audioPlayer.builderRealtimePlayingInfos(
    //       builder: (BuildContext ctx2, RealtimePlayingInfos r) {
    //         if (r.currentPosition.inSeconds == 0) {
    //           return CustomLoader(isPlayer: true);
    //         } else {
    return Center(
      child: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            AlbumArt(),
            Divider(color: TRANSPARENT),
            // MusicProgress(r: r),
            // _Time(r: r),
            SongDetails(),
            // Divider(color: TRANSPARENT),
            PlayerButtons(),
            Divider(color: TRANSPARENT),
            // buildContainer(bloc, widget.i),
          ],
        ),
      ),
    );
    //       }
    //     },
    //   );
    // },
    // );
  }

  Container buildContainer(ApiBloc bloc, int index) {
    return Container(
      height: 180,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        // key: PageStorageKey('songs$index'),
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        itemBuilder: (BuildContext context, int i) {
          // return playerBloc.audioPlayer.builderCurrent(
          //   builder: (BuildContext ctx, Playing playing) {
          debugPrint(playerBloc
              .audioPlayer.current.valueWrapper.value.audio.audio.metas.title);
          debugPrint(widget.songs[widget.i].title);
          return playerBloc.audioPlayer.current.valueWrapper.value.audio.audio
                      .metas.title ==
                  widget.songs[widget.i].title
              ? Container()
              : Container(
                  child: SongThumbnail(i: i, song: widget.songs),
                  width: 120,
                );
          // },
          // );
        },
        itemCount: bloc.buildInitialData(CustomAspectRatio.SONG).length,
      ),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({Key key, @required this.r}) : super(key: key);

  final RealtimePlayingInfos r;

  @override
  Widget build(BuildContext context) {
    String _cur = '';
    String _total = '';

    _cur = r.currentPosition
        .toString()
        .substring(r.duration.inMinutes < 10 ? 3 : 2, 7);
    _total =
        r.duration.toString().substring(r.duration.inMinutes < 10 ? 3 : 2, 7);

    return r != null
        ? Container(
            child: Text('$_cur  -  $_total'),
            alignment: Alignment.center,
            width: double.maxFinite,
          )
        : Container();
  }
}
