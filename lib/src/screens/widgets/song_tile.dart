import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';

class SongTile extends StatelessWidget {
  final dynamic songs;
  final int index;
  final Playlist playlist;
  final bool clickable;

  const SongTile(
      {this.songs, this.index, this.playlist, this.clickable = true});

  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: !clickable
          ? null
          : () {
              _onTap(context, playerBloc);
            },
      child: Container(
        width: size.width,
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 60,
        child: Row(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedPicture(image: songs[index].coverArt ?? ''),
              ),
            ),
            VerticalDivider(color: TRANSPARENT),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSongTitle(size),
                // Divider(color: TRANSPARENT),
                Text(
                  songs[index].runtimeType == Song
                      ? songs[index].artistStatic?.stageName ?? ''
                      : songs[index].artist ?? '',
                  style: const TextStyle(color: GRAY, fontFamilyFallback: f),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // return ListTile(
    //   minLeadingWidth: 40,
    //   contentPadding:
    //       const EdgeInsets.only(right: 0, left: 10, bottom: 5, top: 5),
    //   leading: Container(
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(5),
    //       child: CachedPicture(image: songs[index].coverArt ?? ''),
    //     ),
    //   ),
    //   dense: false,
    //   visualDensity: VisualDensity.comfortable,
    //   title: buildSongTitle(),
    //   subtitle: Text(
    //     songs[index].runtimeType == Song
    //         ? songs[index].artistStatic?.stageName ?? ''
    //         : songs[index].artist ?? '',
    //     style: const TextStyle(color: GRAY, fontFamilyFallback: f),
    //   ),
    //   onTap: !clickable
    //       ? null
    //       : () {
    //           _onTap(context, playerBloc);
    //         },
    // );
  }

  void _onTap(BuildContext context, PlayerBloc playerBloc) {
    if (playerBloc.audioPlayer != null) {
      playerBloc.audioPlayer.stop();
    }

    playerBloc.audioInit(index, songs, songs[index].runtimeType == SongInfo);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) => AudioPlayerScreen(
          songs: songs,
          i: index,
          isLocal: songs[index].runtimeType == SongInfo,
        ),
      ),
    );
  }

  Container buildSongTitle(Size size) {
    return Container(
      width: size.width - 116,
      child: Text(
        songs[index].title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamilyFallback: f,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
