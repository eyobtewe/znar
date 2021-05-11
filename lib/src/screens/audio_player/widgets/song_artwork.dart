import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../../helpers/network_image.dart';
import '../../../presentation/bloc.dart';

class SongArtwork extends StatefulWidget {
  const SongArtwork({Key key, this.songArt}) : super(key: key);

  final String songArt;

  @override
  _SongArtworkState createState() => _SongArtworkState();
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

    // debugPrint(image);
    // debugPrint(widget.songArt);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.125),
      child:
          //  image == null
          //     ? buildSongCover(widget.songArt, size)
          //     :
          playerBloc.audioPlayer.builderCurrent(
              builder: (BuildContext ctx, Playing playing) {
        return buildSongCover(
            playing?.audio?.audio?.metas?.image?.path ?? widget.songArt ?? '',
            size);
      }),
    );
  }

  Widget buildSongCover(String img, Size size) {
    return Card(
      // elevation: 150,
      // shadowColor: PRIMARY_COLOR.withOpacity(0.25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: size.width * 0.75,
          // width: size.width * 0.75,
          // color: PURE_BLACK,
          child: CachedPicture(
            image: img,
            boxFit: BoxFit.cover,
            isBackground: true,
          ),
        ),
      ),
    );
  }
}
