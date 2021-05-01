import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../presentation/player_provider.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({Key key}) : super(key: key);

  // final Playing track;

  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    int i = playerBloc.audioPlayer.readingPlaylist.currentIndex;
    List<Audio> playlist = playerBloc.audioPlayer.readingPlaylist.audios;
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text(
            playlist[i]?.metas?.title ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamilyFallback: f,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Text(playlist[i]?.metas?.artist ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamilyFallback: f)),
        ),
        playlist[i]?.metas?.album != null
            ? Container()
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Text(
                  playlist[i]?.metas?.album ?? '',
                  style: TextStyle(color: GRAY, fontFamilyFallback: f),
                ),
              ),
      ],
    );
  }
}
