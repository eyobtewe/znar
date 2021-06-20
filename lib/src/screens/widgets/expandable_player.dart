import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import 'widgets.dart';

class ExpandableBottomPlayer extends StatefulWidget {
  const ExpandableBottomPlayer({Key key}) : super(key: key);

  @override
  _ExpandableBottomPlayerState createState() => _ExpandableBottomPlayerState();
}

class _ExpandableBottomPlayerState extends State<ExpandableBottomPlayer> {
  MiniplayerController miniPlayerController;

  @override
  void initState() {
    miniPlayerController = MiniplayerController();

    super.initState();
  }

  PlayerBloc playerBloc;
  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    final Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: playerBloc.audioPlayer.playerState,
        builder: (_, AsyncSnapshot<PlayerState> snapshot) {
          return (!snapshot.hasData || snapshot.data == PlayerState.stop)
              ? Container()
              : Miniplayer(
                  controller: miniPlayerController,
                  curve: Curves.easeInOutCubic,
                  minHeight: 67,
                  maxHeight: size.height * 0.65,
                  builder: (double height, double percentage) {
                    return height == 67 ? buildSmallPlayer() : buildBigPlayer();
                  });
        });
  }

  Widget buildSmallPlayer() {
    return InkWell(
      child: BottomScreenPlayer(),
      onTap: () {
        miniPlayerController.animateToHeight(
          state: PanelState.MAX,
          // height: size.height * 0.7,
          duration: Duration(milliseconds: 300),
        );
      },
    );
  }

  Widget buildBigPlayer() {
    return Container(
      color: BACKGROUND,
      child: Center(
        child: StreamBuilder<Playing>(
            stream: playerBloc.audioPlayer.current,
            builder: (_, AsyncSnapshot<Playing> snapshot) {
              return ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  InkWell(
                    child: SongArtwork(
                      songArt: snapshot?.data?.audio?.audio?.metas?.image?.path,
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => AudioPlayerScreen(),
                      //   ),
                      // );
                    },
                  ),
                  Divider(color: TRANSPARENT),
                  SongDetails(),
                  PlayerButtons(),
                  // Divider(color: TRANSPARENT),
                  // Row(
                  //   children: [Spacer(), LyricsBtn(), Spacer()],
                  // ),
                ],
              );
            }),
      ),
    );
  }
}
