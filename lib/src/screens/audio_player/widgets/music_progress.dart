import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_lyric/lyric_util.dart';
// import 'package:flutter_lyric/lyric_widget.dart';

import '../../../../external_src/audio_progress_bar/audio_player_progress_bar.dart';
import '../../../core/core.dart';
import '../../../presentation/bloc.dart';
import '../../screens.dart';

class MusicProgress extends StatefulWidget {
  const MusicProgress({Key key, this.isBottombar = false}) : super(key: key);

  final bool isBottombar;

  @override
  _MusicProgressState createState() => _MusicProgressState();
}

class _MusicProgressState extends State<MusicProgress> {
  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final Size size = MediaQuery.of(context).size;

    return playerBloc.audioPlayer.builderRealtimePlayingInfos(
        builder: (BuildContext ctx, RealtimePlayingInfos r) {
      return Container(
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ProgressBar(
          progress: r.currentPosition,
          total: r.duration,
          bufferedBarColor: BLUE,
          progressBarColor: PRIMARY_COLOR,
          thumbColor: PRIMARY_COLOR,
          timeLabelLocation: TimeLabelLocation.sides,
          timeLabelTextStyle: TextStyle(color: GRAY, fontFamily: 'Kefa'),
          thumbRadius: 5,
          barHeight: 5,
          baseBarColor: GRAY,
          thumbGlowRadius: 20,
          onSeek: (Duration d) {
            playerBloc.audioPlayer.seek(d);
          },
        ),
      );
    });
  }
}
