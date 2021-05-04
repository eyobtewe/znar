import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';

class BottomScreenPlayer extends StatelessWidget {
  const BottomScreenPlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);

    return StreamBuilder(
        stream: playerBloc.audioPlayer.playerState,
        builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
          if (!snapshot.hasData) {
            return Container(height: 0);
          } else {
            if (playerBloc.playerStatus == PlayerInit.SLEEP) {
              return Container(height: 0);
            } else {
              return buildDismissible(context, playerBloc);
            }
          }
        });
  }

  Widget buildDismissible(BuildContext context, PlayerBloc playerBloc) {
    return Dismissible(
      background: Container(
        padding: const EdgeInsets.all(5),
        color: PRIMARY_COLOR,
        alignment: Alignment.centerRight,
        child: CircleAvatar(
          child: const Icon(
            Ionicons.stop_circle,
            color: PRIMARY_COLOR,
            size: 32,
          ),
          backgroundColor: BACKGROUND,
        ),
      ),
      key: UniqueKey(),
      confirmDismiss: (DismissDirection d) {
        if (d == DismissDirection.endToStart) {
          return Future.delayed(Duration(milliseconds: 00), () => true);
        }
        return Future.value(false);
      },
      child: buildBottom(context, playerBloc),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection d) async {
        await playerBloc.stop();
      },
    );
  }

  Widget buildBottom(BuildContext context, PlayerBloc playerBloc) {
    // final Metas songMetaData = playing.audio?.audio?.metas;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildListTile(context, playerBloc),
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
                  // minHeight: 1,
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
        ],
      ),
    );
  }

  Widget buildListTile(BuildContext context, PlayerBloc playerBloc) {
    return playerBloc.audioPlayer.builderCurrent(
        builder: (BuildContext context, Playing playing) {
      final Metas songMetaData = playing.audio?.audio?.metas;
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext ctx) => AudioPlayerScreen(
                        isFromBottomBar: true,
                      )));
        },
        leading: Container(
          width: 48,
          color: BACKGROUND,
          child: songMetaData?.extra['image'] != null
              ? Image.memory(songMetaData?.extra['image'])
              : songMetaData?.image?.type == ImageType.network
                  ? CachedPicture(image: songMetaData?.image?.path ?? '')
                  : CustomFileImage(img: songMetaData?.image?.path ?? ''),
        ),
        title: Text(
          songMetaData?.title ?? '',
          maxLines: 2,
          style: const TextStyle(fontFamilyFallback: f),
        ),
        subtitle: Text(
          songMetaData?.artist ?? '',
          maxLines: 1,
          style: const TextStyle(color: GRAY, fontFamilyFallback: f),
        ),
        dense: true,
        trailing: playerBloc.audioPlayer.builderIsPlaying(
          builder: (BuildContext ctx, bool isPlaying) {
            return Container(
              decoration: BoxDecoration(
                color: BACKGROUND,
                borderRadius: BorderRadius.circular(50),
              ),
              child: IconButton(
                color: PRIMARY_COLOR,
                iconSize: 32,
                icon: isPlaying
                    ? const Icon(Ionicons.pause_circle_outline)
                    : const Icon(Ionicons.play_circle_outline),
                onPressed: () {
                  playerBloc.audioPlayer.playOrPause();
                },
              ),
            );
          },
        ),
      );
    });
  }
}
