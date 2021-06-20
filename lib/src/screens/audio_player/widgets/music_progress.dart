import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../../../external_src/audio_progress_bar/audio_player_progress_bar.dart';
import '../../../core/core.dart';
import '../../../presentation/bloc.dart';

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
        builder: (_, RealtimePlayingInfos r) {
      return Container(
        width: size.width * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ProgressBar(
          progress: r.currentPosition,
          total: r.duration,
          progressBarColor: PRIMARY_COLOR,
          thumbColor: PRIMARY_COLOR,
          timeLabelLocation: TimeLabelLocation.none,
          timeLabelTextStyle: TextStyle(color: GRAY, fontFamily: 'Kefa'),
          thumbRadius: 5,
          barHeight: 5,
          baseBarColor: GRAY,
          thumbGlowRadius: 15,
          onSeek: (Duration d) {
            playerBloc.audioPlayer.seek(d);
          },
        ),
      );
    });
  }
}
