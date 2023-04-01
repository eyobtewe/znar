import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../presentation/bloc.dart';

class MusicProgress extends StatefulWidget {
  const MusicProgress({Key key, this.isBottombar = false}) : super(key: key);

  final bool isBottombar;

  @override
  State<MusicProgress> createState() => _MusicProgressState();
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ProgressBar(
          progress: r.currentPosition,
          timeLabelType: TimeLabelType.totalTime,
          total: r.duration,
          progressBarColor: cPrimaryColor,
          thumbColor: cPrimaryColor,
          timeLabelLocation: TimeLabelLocation.below,
          timeLabelTextStyle: const TextStyle(color: cGray, fontFamily: 'Kefa'),
          thumbRadius: 5,
          barHeight: 5,
          baseBarColor: cGray,
          thumbGlowRadius: 15,
          onSeek: (Duration d) {
            playerBloc.audioPlayer.seek(d);
          },
        ),
      );
    });
  }
}
