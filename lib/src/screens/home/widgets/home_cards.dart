import 'package:flutter/material.dart';

import '../../screens.dart';
import '../../widgets/widgets.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({
    Key key,
    this.ar,
    this.data,
    this.i,
  }) : super(key: key);

  final MEDIA ar;
  final List data;
  final int i;

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    switch (ar) {
      case MEDIA.SONG:
        return
            // Container(
            // width: 150,
            // child:
            SongThumbnail(i: i, song: data
                //  ),
                );

      case MEDIA.ARTIST:
        return SizedBox(
          width: 135,
          child: ArtistThumbnail(artist: data[i]),
        );
      case MEDIA.PLAYLIST:
        return
            //  Container(
            //   child:
            PlaylistThumbnail(i: i, playlist: data[i]
                //  ),
                // width: 160,
                );
      // case MEDIA.CHANNEL:
      //   return Container(
      //     child: ChannelThumbnail(i: i, channel: data[i]),
      //   );
      case MEDIA.VIDEO:
        return
            //  Container(
            //   child:
            MusicVideoThumbnail(i: i, musicVideo: data[i]
                // ),
                // width: 180,
                );
      default:
        return Container();
    }
  }
}
