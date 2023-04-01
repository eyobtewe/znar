import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../core/core.dart';
import '../../../presentation/bloc.dart';
import 'widgets.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Divider(color: cTransparent),
        const MusicProgress(),
        const Divider(color: cTransparent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Spacer(),
            buildRepeatBtn(playerBloc, size),
            const VerticalDivider(),
            buildPrevButton(playerBloc, size),
            buildPlayPauseBtn(playerBloc, size),
            buildNextBtn(playerBloc, size),
            const VerticalDivider(),
            buildShuffleBtn(playerBloc, size),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  PlayerBuilder buildRepeatBtn(PlayerBloc playerBloc, Size size) {
    return playerBloc.audioPlayer.builderLoopMode(
      builder: (_, LoopMode loopMode) {
        return loopMode != null
            ? IconButton(
                // iconSize: size.width * 0.08,
                iconSize: ScreenUtil().setSp(28),
                icon: const Icon(Ionicons.repeat),
                color: loopMode == LoopMode.single ? cPrimaryColor : cGray,
                onPressed: () {
                  if (LoopMode.playlist == loopMode) {}
                  playerBloc.audioPlayer.setLoopMode(
                    loopMode == LoopMode.playlist
                        ? LoopMode.single
                        : LoopMode.playlist,
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget buildShuffleBtn(PlayerBloc playerBloc, Size size) {
    // if (playerBloc?.audioPlayer?.realtimePlayingInfos?.valueWrapper?.value
    //         ?.playingPercent ==
    //     null) {
    return StreamBuilder(
        stream: playerBloc?.audioPlayer?.realtimePlayingInfos,
        builder: (_, AsyncSnapshot<RealtimePlayingInfos> r) {
          if (r?.data?.duration == Duration.zero) {
            return IconButton(
              color: cGray,
              iconSize: ScreenUtil().setSp(28),
              icon: const Icon(Ionicons.shuffle),
              onPressed: null,
            );
          } else {
            return IconButton(
              iconSize: ScreenUtil().setSp(28),
              icon: const Icon(Ionicons.shuffle),
              color: (r?.data?.isShuffling == false) ? cGray : cPrimaryColor,
              onPressed: () {
                playerBloc.audioPlayer.toggleShuffle();
              },
            );
          }
        });
    // } else {
    //   return playerBloc.audioPlayer.builderRealtimePlayingInfos(
    //     builder: (_, RealtimePlayingInfos r) {
    //       return IconButton(
    //         iconSize: ScreenUtil().setSp(28),
    //         icon: const Icon(Ionicons.shuffle),
    //         color: (r?.isShuffling == false) ? cGray : cPrimaryColor,
    //         onPressed:
    //             playerBloc?.audioPlayer?.isShuffling?.valueWrapper?.value ==
    //                     null
    //                 ? null
    //                 : () {
    //                     playerBloc.audioPlayer.toggleShuffle();
    //                   },
    //       );
    //     },
    //   );
    // }
  }

  Widget buildNextBtn(PlayerBloc playerBloc, Size size) {
    return IconButton(
      iconSize: ScreenUtil().setSp(28),
      color: cGray,
      icon: const Icon(Ionicons.play_skip_forward_outline),
      onPressed: playerBloc.audioPlayer.current.value?.hasNext == false
          ? null
          : () {
              playerBloc.audioPlayer.pause();
              playerBloc.audioPlayer.next();
            },
    );
  }

  PlayerBuilder buildPlayPauseBtn(PlayerBloc playerBloc, Size size) {
    return playerBloc.audioPlayer.builderPlayerState(
      builder: (BuildContext _, PlayerState playerState) {
        return (playerBloc?.audioPlayer?.realtimePlayingInfos?.value
                        ?.playingPercent ==
                    null ||
                playerBloc
                        ?.audioPlayer?.realtimePlayingInfos?.value?.duration ==
                    Duration.zero)
            ? buildBuffering()
            : IconButton(
                color: cPrimaryColor,
                iconSize: ScreenUtil().setSp(50),
                icon: playerState == PlayerState.play
                    ? const Icon(Ionicons.pause_circle_outline)
                    : const Icon(Ionicons.play_circle_outline),
                onPressed: () {
                  playerBloc.audioPlayer.playOrPause();
                },
              );
      },
    );
  }

  Stack buildBuffering() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          color: cGray,
          disabledColor: cPrimaryColor,
          iconSize: ScreenUtil().setSp(50),
          icon: const Icon(Ionicons.pause_circle_outline),
          onPressed: null,
        ),
        SleekCircularSlider(
          appearance: CircularSliderAppearance(
            spinnerMode: true,
            size: 40,
            customColors: CustomSliderColors(
                trackColor: cLinkColor,
                dotColor: cGray,
                progressBarColors: [
                  cPurple,
                  cBlue,
                  cPrimaryColor,
                ]),
            customWidths:
                CustomSliderWidths(progressBarWidth: 3, trackWidth: 3),
          ),
        )
      ],
    );
  }

  IconButton buildPrevButton(PlayerBloc playerBloc, Size size) {
    return IconButton(
      iconSize: ScreenUtil().setSp(28),
      color: cGray,
      icon: const Icon(Ionicons.play_skip_back_outline),
      onPressed: () {
        playerBloc.audioPlayer.previous();
      },
    );
  }
}
