import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';

class SongTile extends StatelessWidget {
  final List<dynamic> songs;
  final int index;
  final Playlist playlist;
  final bool clickable;

  const SongTile(
      {this.songs, this.index, this.playlist, this.clickable = true});

  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);

    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return InkWell(
      onTap: !clickable
          ? null
          : () {
              _onTap(context, playerBloc);
            },
      child: Container(
        width: size.width,
        color: playerBloc.audioPlayer.current.valueWrapper?.value?.audio?.audio
                    ?.metas?.id ==
                songs[index].sId
            ? PURE_BLACK
            : BACKGROUND,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 60,
          child: Row(
            children: [
              Container(
                width: 60,
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
                  buildSongTitle(size, playerBloc),
                  Text(
                    songs[index].runtimeType == Song
                        ? songs[index].artistStatic?.fullName ?? ''
                        : songs[index].artist ?? '',
                    style: TextStyle(
                      color: playerBloc.audioPlayer.current.valueWrapper?.value
                                  ?.audio?.audio?.metas?.id ==
                              songs[index].sId
                          ? PRIMARY_COLOR
                          : GRAY,
                      fontFamilyFallback: f,
                      fontSize: ScreenUtil().setSp(10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Container buildSongTitle(Size size, PlayerBloc playerBloc) {
    return Container(
      width: size.width - 140,
      child: Text(
        songs[index].title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: playerBloc.audioPlayer.current.valueWrapper?.value?.audio
                      ?.audio?.metas?.id ==
                  songs[index].sId
              ? PRIMARY_COLOR
              : GRAY,
          fontFamilyFallback: f,
          fontSize: ScreenUtil().setSp(12),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
