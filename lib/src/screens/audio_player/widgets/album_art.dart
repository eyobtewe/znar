import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../../core/core.dart';
import '../../../helpers/network_image.dart';
import '../../../presentation/bloc.dart';

class AlbumArt extends StatelessWidget {
  const AlbumArt({
    Key key,
  }) : super(key: key);

  // final RealtimePlayingInfos r;
  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    // final String image = playerBloc.audioPlayer.current?.valueWrapper?.value
    //     ?.audio?.audio?.metas?.image?.path;
    // final Uint8List byteImg = playerBloc.audioPlayer.current?.valueWrapper
    //     ?.value?.audio?.audio?.metas?.extra['image'];
    // final ImageType imageType = playerBloc.audioPlayer.current?.valueWrapper
    //     ?.value?.audio?.audio?.metas?.image?.type;

    final Size size = MediaQuery.of(context).size;

    return Container(
      height: size.width - 100,
      // child: buildImage(image, byteImg, imageType),
      width: size.width,
      child: buildSwiper(context, playerBloc),
    );
  }

  // Widget buildImage(String image, Uint8List byteImg, ImageType imageType) {
  //   return byteImg != null
  //       ? Image.memory(byteImg)
  //       : image != null
  //           ? ImageType.file == imageType
  //               ? ClipRRect(
  //                   child: CustomFileImage(img: image),
  //                   borderRadius: BorderRadius.circular(10),
  //                 )
  //               : ClipRRect(
  //                   child: CachedPicture(boxFit: BoxFit.cover, image: image),
  //                   borderRadius: BorderRadius.circular(10),
  //                 )
  //           : CustomFileImage(img: 'image');
  // }

  Swiper buildSwiper(BuildContext context, PlayerBloc playerBloc) {
    final List<Audio> playlist = playerBloc.audioPlayer.readingPlaylist.audios;
    int currentIndex = playerBloc.audioPlayer.readingPlaylist.currentIndex;
    return Swiper(
      itemCount: playlist.length,
      index: currentIndex,
      viewportFraction: 0.7,
      scale: 0.75,
      onIndexChanged: (int i) async {
        await playerBloc.audioPlayer.playlistPlayAtIndex(i);
      },
      autoplayDisableOnInteraction: false,
      itemBuilder: (BuildContext context, int index) =>
          buildInkWell(context, playlist, index),
    );
  }

  Widget buildInkWell(BuildContext context, List<Audio> playlist, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // width: size.width,
        color: GRAY,
        child: CachedPicture(
          image: playlist[index].metas.image.path,
          boxFit: BoxFit.cover,
          isBackground: true,
        ),
      ),
    );
  }
}
