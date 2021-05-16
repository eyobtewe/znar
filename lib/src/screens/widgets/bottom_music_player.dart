import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';

class BottomScreenPlayer extends StatelessWidget {
  const BottomScreenPlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return playerBloc.audioPlayer.builderPlayerState(
        builder: (BuildContext ctx, PlayerState playerState) {
      if (playerState == null || playerBloc.playerStatus == PlayerInit.SLEEP) {
        return Container(height: 0);
      } else {
        return buildBottom(context, playerBloc);
      }
    });
    // return StreamBuilder(
    //     stream: playerBloc.audioPlayer.playerState,
    //     builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
    //       if (!snapshot.hasData) {
    //         return Container(height: 0);
    //       } else {
    //         if (playerBloc.playerStatus == PlayerInit.SLEEP) {
    //           return Container(height: 0);
    //         } else {
    //           return buildBottom(context, playerBloc);
    //         }
    //       }
    //     });
  }

  // Widget buildDismissible(BuildContext context, PlayerBloc playerBloc) {
  //   return Dismissible(
  //     background: Container(
  //       padding: const EdgeInsets.all(5),
  //       color: PRIMARY_COLOR,
  //       alignment: Alignment.centerRight,
  //       child: CircleAvatar(
  //         child: const Icon(
  //           Ionicons.stop_circle,
  //           color: PRIMARY_COLOR,
  //           size: 32,
  //         ),
  //         backgroundColor: BACKGROUND,
  //       ),
  //     ),
  //     key: UniqueKey(),
  //     confirmDismiss: (DismissDirection d) {
  //       if (d == DismissDirection.endToStart) {
  //         return Future.delayed(Duration(milliseconds: 00), () => true);
  //       }
  //       return Future.value(false);
  //     },
  //     child: buildBottom(context, playerBloc),
  //     direction: DismissDirection.endToStart,
  //     onDismissed: (DismissDirection d) async {
  //       await playerBloc.stop();
  //     },
  //   );
  // }

  Widget buildBottom(BuildContext context, PlayerBloc playerBloc) {
    // final Metas songMetaData = playing.audio?.audio?.metas;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          playerBloc.audioPlayer.builderRealtimePlayingInfos(
            builder: (BuildContext ctx, RealtimePlayingInfos rInfo) {
              if (rInfo == null) {
                return LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(PRIMARY_COLOR),
                  backgroundColor: CANVAS_BLACK,
                  value: 0,
                );
              } else {
                return LinearProgressIndicator(
                  minHeight: 2,
                  valueColor: AlwaysStoppedAnimation(PRIMARY_COLOR),
                  backgroundColor: CANVAS_BLACK,
                  value: rInfo.duration.inSeconds != 0
                      ? (rInfo.currentPosition.inSeconds /
                          rInfo.duration.inSeconds)
                      : 0,
                );
              }
            },
          ),
          buildListTile(context, playerBloc),
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context, PlayerBloc playerBloc) {
    return playerBloc.audioPlayer.builderCurrent(
        builder: (BuildContext context, Playing playing) {
      final Metas songMetaData = playing.audio?.audio?.metas;
      return ListTile(
        // onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext ctx) => AudioPlayerScreen(
        //               isFromBottomBar: true,
        //             )));
        // },
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 48,
                height: 48,
                child: songMetaData?.extra['image'] != null
                    ? Image.memory(songMetaData?.extra['image'])
                    : songMetaData?.image?.type == ImageType.network
                        ? CachedPicture(image: songMetaData?.image?.path ?? '')
                        : CustomFileImage(img: songMetaData?.image?.path ?? ''),
              ),
            ),
            playerBloc.audioPlayer.builderIsPlaying(
              builder: (BuildContext ctx, bool isPlaying) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: BACKGROUND.withOpacity(0.65),
                  ),
                  child: IconButton(
                    color: PRIMARY_COLOR,
                    iconSize: 32,
                    icon: isPlaying
                        ? const Icon(Ionicons.pause_circle)
                        : const Icon(Ionicons.play_circle),
                    onPressed: () {
                      playerBloc.audioPlayer.playOrPause();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        title: Text(
          songMetaData?.title ?? '',
          maxLines: 2,
          style: TextStyle(
            fontFamilyFallback: f,
            color: GRAY,
            fontSize: ScreenUtil().setSp(12),
          ),
        ),
        subtitle: Text(
          songMetaData?.artist ?? '',
          maxLines: 1,
          style: TextStyle(
            color: DARK_GRAY,
            fontFamilyFallback: f,
            fontSize: ScreenUtil().setSp(10),
          ),
        ),
        dense: true,
        trailing: IconButton(
            icon: Icon(Ionicons.close_outline),
            color: PRIMARY_COLOR,
            onPressed: () async {
              await playerBloc.stop();
            }),
      );
    });
  }
}
