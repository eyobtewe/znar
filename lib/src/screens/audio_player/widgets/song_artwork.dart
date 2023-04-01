import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../../helpers/network_image.dart';
import '../../../presentation/bloc.dart';

class SongArtwork extends StatefulWidget {
  const SongArtwork({Key key, this.songArt}) : super(key: key);

  final String songArt;

  @override
  State<SongArtwork> createState() => _SongArtworkState();
}

class _SongArtworkState extends State<SongArtwork> {
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
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.125),
      child:
          //  image == null
          //     ? buildSongCover(widget.songArt, size)
          //     :
          playerBloc.audioPlayer.builderCurrent(builder: (_, Playing playing) {
        return buildSongCover(
          playing?.audio?.audio?.metas?.image?.path ?? widget.songArt ?? '',
          size,
          memory: playerBloc
              .audioPlayer.current.value?.audio?.audio?.metas?.extra['image'],
        );
      }),
    );
  }

  Widget buildSongCover(String img, Size size, {Uint8List memory}) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: SizedBox(
            height: size.width * 0.5,
            // width: size.width * 0.5,
            child: memory == null
                ? CachedPicture(image: img, boxFit: BoxFit.cover)
                : Image(image: MemoryImage(memory), fit: BoxFit.cover)),
      ),
    );
  }
}
