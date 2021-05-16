import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import 'widgets.dart';

class SongThumbnail extends StatelessWidget {
  const SongThumbnail({
    this.i,
    this.song,
    this.isSearchResult,
  });

  final List<Song> song;
  final int i;
  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final PlayerBloc _playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return InkWell(
      onTap: () {
        if (_playerBloc.audioPlayer != null) {
          _playerBloc.audioPlayer.stop();
        }
        _playerBloc.audioInit(i, song);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext ctx) => AudioPlayerScreen(songs: song, i: i),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 150,
        width: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    decoration: BoxDecoration(),
                    margin: const EdgeInsets.only(bottom: 10),
                    // constraints: BoxConstraints(minHeight: 120),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedPicture(
                        image: song[i].coverArt,
                        // isBackground: true,
                        // boxFit: BoxFit.contain,
                      ),
                    ),
                  ),
            MusicTitle(
              title: song[i].title ?? '',
              lines: 1,
              fontSize: 12,
            ),
            Divider(color: TRANSPARENT, height: 5),
            MusicTitle(
                title: song[i].artistStatic.fullName,
                // !=
                //         song[i].artistStatic.firstName
                //     ? song[i].artistStatic.stageName
                //     : song[i].artistStatic.fullName,
                lines: 1,
                fontSize: 10,
                color: GRAY),
          ],
        ),
      ),
    );
  }
}
