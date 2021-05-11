import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../presentation/player_provider.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({Key key}) : super(key: key);

  // final Playing track;

  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    int i = playerBloc.audioPlayer.readingPlaylist.currentIndex;
    List<Audio> playlist = playerBloc.audioPlayer.readingPlaylist.audios;

    return playerBloc.audioPlayer.builderCurrent(
      builder: (BuildContext ctx, Playing playing) {
        return Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Text(
                playing?.audio?.audio?.metas?.title ??
                    playlist[i]?.metas?.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: GRAY,
                  fontFamilyFallback: f,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Text(
                playing?.audio?.audio?.metas?.artist ??
                    playlist[i]?.metas?.artist,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamilyFallback: f,
                  color: DARK_GRAY,
                  fontSize: ScreenUtil().setSp(14),
                ),
              ),
            ),
            playlist[i]?.metas?.album != null
                ? Container()
                : Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      playlist[i]?.metas?.album ?? '',
                      style: TextStyle(
                        color: GRAY,
                        fontFamilyFallback: f,
                        fontSize: ScreenUtil().setSp(12),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
