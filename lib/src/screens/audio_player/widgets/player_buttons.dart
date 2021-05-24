import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../core/core.dart';
import '../../../presentation/bloc.dart';
import 'widgets.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Column(
      children: [
        Divider(color: TRANSPARENT),
        MusicProgress(),
        Divider(color: TRANSPARENT),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            buildRepeatBtn(playerBloc, size),
            VerticalDivider(),
            buildPrevButton(playerBloc, size),
            buildPlayPauseBtn(playerBloc, size),
            buildNextBtn(playerBloc, size),
            VerticalDivider(),
            buildShuffleBtn(playerBloc, size),
            Spacer(),
          ],
        ),
      ],
    );
  }

  PlayerBuilder buildRepeatBtn(PlayerBloc playerBloc, Size size) {
    return playerBloc.audioPlayer.builderLoopMode(
      builder: (BuildContext ctx, LoopMode loopMode) {
        return loopMode != null
            ? IconButton(
                // iconSize: size.width * 0.08,
                iconSize: ScreenUtil().setSp(28),
                icon: const Icon(Ionicons.repeat),
                color: loopMode == LoopMode.single ? PRIMARY_COLOR : GRAY,
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
    debugPrint(playerBloc
        ?.audioPlayer?.realtimePlayingInfos?.valueWrapper?.value?.playingPercent
        .toString());

    // if (playerBloc?.audioPlayer?.realtimePlayingInfos?.valueWrapper?.value
    //         ?.playingPercent ==
    //     null) {
    return StreamBuilder(
        stream: playerBloc?.audioPlayer?.realtimePlayingInfos,
        builder: (BuildContext context, AsyncSnapshot<RealtimePlayingInfos> r) {
          if (r?.data?.duration == Duration.zero) {
            return IconButton(
              color: GRAY,
              iconSize: ScreenUtil().setSp(28),
              icon: const Icon(Ionicons.shuffle),
              onPressed: null,
            );
          } else {
            return IconButton(
              iconSize: ScreenUtil().setSp(28),
              icon: const Icon(Ionicons.shuffle),
              color: (r?.data?.isShuffling == false) ? GRAY : PRIMARY_COLOR,
              onPressed: () {
                playerBloc.audioPlayer.toggleShuffle();
              },
            );
          }
        });
    // } else {
    //   return playerBloc.audioPlayer.builderRealtimePlayingInfos(
    //     builder: (BuildContext ctx, RealtimePlayingInfos r) {
    //       return IconButton(
    //         iconSize: ScreenUtil().setSp(28),
    //         icon: const Icon(Ionicons.shuffle),
    //         color: (r?.isShuffling == false) ? GRAY : PRIMARY_COLOR,
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
      color: GRAY,
      icon: const Icon(Ionicons.play_skip_forward_outline),
      onPressed:
          playerBloc.audioPlayer.current.valueWrapper?.value?.hasNext == false
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
        return (playerBloc?.audioPlayer?.realtimePlayingInfos?.valueWrapper
                        ?.value?.playingPercent ==
                    null ||
                playerBloc?.audioPlayer?.realtimePlayingInfos?.valueWrapper
                        ?.value?.duration ==
                    Duration.zero)
            ? buildBuffering()
            : IconButton(
                color: PRIMARY_COLOR,
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
          color: GRAY,
          disabledColor: PRIMARY_COLOR,
          iconSize: ScreenUtil().setSp(50),
          icon: const Icon(Ionicons.pause_circle_outline),
          onPressed: null,
        ),
        SleekCircularSlider(
          appearance: CircularSliderAppearance(
            spinnerMode: true,
            size: 40,
            customColors: CustomSliderColors(
                trackColor: LINK,
                dotColor: GRAY,
                progressBarColors: [
                  PURPLE,
                  BLUE,
                  PRIMARY_COLOR,
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
      color: GRAY,
      icon: const Icon(Ionicons.play_skip_back_outline),
      onPressed: () {
        playerBloc.audioPlayer.previous();
      },
    );
  }
}
