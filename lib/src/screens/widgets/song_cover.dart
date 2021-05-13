import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../core/core.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';

class SongCover extends StatelessWidget {
  const SongCover({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);

    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.width - 100,
      width: size.width,
      child: playerBloc.audioPlayer.builderRealtimePlayingInfos(
          builder: (BuildContext ctx, RealtimePlayingInfos r) {
        return buildSwiper(r, playerBloc);
      }),
    );
  }

  Swiper buildSwiper(RealtimePlayingInfos r, PlayerBloc playerBloc) {
    return Swiper(
      itemCount: playerBloc.audioPlayer.readingPlaylist.audios.length,
      index: playerBloc.audioPlayer.readingPlaylist.currentIndex,
      viewportFraction: 0.7,
      scale: 0.75,
      onIndexChanged: (int i) async {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        await playerBloc.audioPlayer.playlistPlayAtIndex(i);
      },
      autoplay: false,
      autoplayDisableOnInteraction: false,
      itemBuilder: (BuildContext context, int index) => buildImage(
          context,
          playerBloc
              .audioPlayer.readingPlaylist.audios[index].metas.image.path),
    );
  }

  Widget buildImage(BuildContext context, String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: PURE_BLACK,
        child: CachedPicture(
          image: img,
          boxFit: BoxFit.cover,
          isBackground: true,
        ),
      ),
    );
  }
}
