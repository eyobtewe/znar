import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/song_cover.dart';
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
  PlayerBloc playerBloc;
  ApiBloc bloc;
  Size size;
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    bloc = ApiProvider.of(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: BACKGROUND.withOpacity(0),
      elevation: 0,
      actions: (widget.isLocal || widget.isDownloaded)
          ? null
          : [
              // IconButton(
              //   icon: Icon(Ionicons.share_social_outline),
              //   onPressed: () async {
              //     final String link = await kDynamicLinkService
              //         .createDynamicLink(widget.songs[widget.i]);

              //     Share.share(
              //         '${widget.songs[widget.i].title} - ${widget.songs[widget.i].artistStatic.fullName} \n\n$link');
              //   },
              // ),
            ],
    );
  }

  Widget buildBody() {
    return Center(
      child: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            // playerBloc.audioPlayer.builderCurrent(
            //     builder: (_, Playing playing) {
            //   debugPrint(
            // '\n\n\t\t\t\t\t ${playing.playlist.currentIndex} \n\n');
            // return
            SongCover(),
            // ;
            // }),
            // SongArtwork(songArt: widget.songs[widget.i].coverArt),
            Divider(color: TRANSPARENT),
            SongDetails(),
            PlayerButtons(),
            Divider(color: TRANSPARENT),
            // Row(
            //   children: [Spacer(), LyricsBtn(), Spacer()],
            // ),
            // Divider(color: TRANSPARENT),
            // buildContainer(),
          ],
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      height: 180,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int i) {
          return playerBloc.audioPlayer.builderCurrent(
              builder: (_, Playing playing) {
            return i == playing.playlist.currentIndex
                ? Container()
                : Container(
                    child: SongThumbnail(i: i, song: widget.songs),
                    width: 120,
                  );
          });
        },
        itemCount: bloc.buildInitialData(CustomAspectRatio.SONG).length - 1,
      ),
    );
  }
}
