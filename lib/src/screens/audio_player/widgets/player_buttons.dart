import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: <Widget>[

        //     buildPlaylistBtn(playerBloc, size),
        //     buildVolumeBtn(playerBloc, size),

        //   ],
        // ),
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
    return playerBloc.audioPlayer.builderRealtimePlayingInfos(
      builder: (BuildContext ctx, RealtimePlayingInfos r) {
        return IconButton(
          iconSize: ScreenUtil().setSp(28),
          icon: const Icon(Ionicons.shuffle),
          color: (r?.isShuffling == false) ? GRAY : PRIMARY_COLOR,
          onPressed: r == null
              ? null
              : () {
                  playerBloc.audioPlayer.toggleShuffle();
                },
        );
      },
    );
  }

  Widget buildNextBtn(PlayerBloc playerBloc, Size size) {
    return playerBloc.audioPlayer.builderCurrent(
      builder: (BuildContext ctx, Playing playing) {
        return IconButton(
          iconSize: ScreenUtil().setSp(28),
          color: GRAY,
          icon: const Icon(Ionicons.play_skip_forward_outline),
          onPressed: playing != null
              ? (playing.hasNext
                  ? () {
                      playerBloc.audioPlayer.pause();
                      playerBloc.audioPlayer.next();
                    }
                  : null)
              : null,
        );
      },
    );
  }

  PlayerBuilder buildPlayPauseBtn(PlayerBloc playerBloc, Size size) {
    return playerBloc.audioPlayer.builderPlayerState(
      builder: (BuildContext context, PlayerState _playerState) {
        return
            // (buffering && !playing)
            // ? Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       IconButton(
            //         color: GRAY,
            //         disabledColor: PRIMARY_COLOR,
            //         iconSize: ScreenUtil().setSp(50),
            //         icon: const Icon(Ionicons.pause_circle_outline),
            //         onPressed: null,
            //       ),
            //       SleekCircularSlider(
            //         appearance: CircularSliderAppearance(
            //           spinnerMode: true,
            //           size: 40,
            //           customColors: CustomSliderColors(
            //               trackColor: LINK,
            //               dotColor: PURE_WHITE,
            //               progressBarColors: [
            //                 PURPLE,
            //                 BLUE,
            //                 PRIMARY_COLOR,
            //               ]),
            //           customWidths: CustomSliderWidths(
            //               progressBarWidth: 3, trackWidth: 3),
            //         ),
            //       )
            //     ],
            //   )
            // :
            IconButton(
          color: GRAY,
          iconSize: ScreenUtil().setSp(50),
          icon: _playerState == PlayerState.play
              ? const Icon(Ionicons.pause_circle_outline)
              : const Icon(Ionicons.play_circle_outline),
          onPressed: () {
            playerBloc.audioPlayer.playOrPause();
          },
        );
      },
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
