import 'package:flutter/material.dart';

import '../../screens.dart';
import '../../widgets/widgets.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({
    this.ar,
    this.data,
    this.i,
  });

  final CustomAspectRatio ar;
  final List data;
  final int i;

  @override
  Widget build(BuildContext context) {
    switch (ar) {
      case CustomAspectRatio.SONG:
        return Container(
          child: SongThumbnail(i: i, song: data),
          // width: 130,
        );
      // case CustomAspectRatio.ALBUM:
      //   return Container(
      //     child: AlbumThumbnail(album: data[i]),
      //     width: 130,
      //   );
      case CustomAspectRatio.ARTIST:
        return Container(
          child: ArtistThumbnail(artist: data[i]),
          width: 100,
        );
      case CustomAspectRatio.PLAYLIST:
        return Container(
          child: PlaylistThumbnail(i: i, playlist: data[i]),
          // width: 160,
        );
      // case CustomAspectRatio.CHANNEL:
      //   return Container(
      //     child: ChannelThumbnail(i: i, channel: data[i]),
      //   );
      // case CustomAspectRatio.VIDEO:
      //   return Container(
      //     child: MusicVideoThumbnail(i: i, musicVideo: data[i]),
      //     width: 180,
      //   );
      default:
        return Container();
    }
  }
}
