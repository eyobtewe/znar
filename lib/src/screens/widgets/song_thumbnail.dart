import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import 'widgets.dart';

class SongThumbnail extends StatelessWidget {
  const SongThumbnail({
    Key key,
    this.i,
    this.song,
    this.isSearchResult,
  }) : super(key: key);

  final List<Song> song;
  final int i;
  final bool isSearchResult;

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return InkWell(
      onTap: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(i, song);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => AudioPlayerScreen(songs: song, i: i),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 150,
        width: 150,
        child: StreamBuilder<Playing>(
            stream: playerBloc.audioPlayer.current,
            builder: (_, AsyncSnapshot<Playing> snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  isSearchResult != null
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            // child: CachedPicture(
                            //   image: song[i].coverArt,
                            //   // isBackground: true,
                            //   // boxFit: BoxFit.contain,
                            // ),
                            child: CachedNetworkImage(
                              imageUrl: song[i].coverArt,
                              fit: BoxFit.cover,
                              imageBuilder:
                                  (_, ImageProvider<dynamic> imageProvider) {
                                return Image(image: imageProvider);
                                // return Container(
                                //     width: 150,
                                //     height: 120,
                                //     color: cCanvasBlack);
                              },
                              placeholder: (BuildContext context, String url) {
                                return Container(
                                    width: 150,
                                    height: 120,
                                    color: cCanvasBlack);
                              },
                            ),
                          ),
                        ),
                  MusicTitle(
                    title: song[i].title ?? '',
                    lines: 1,
                    fontSize: 14,
                    color:
                        snapshot?.data?.audio?.audio?.metas?.id == song[i].sId
                            ? cPrimaryColor
                            : cGray,
                  ),
                  const Divider(color: cTransparent, height: 5),
                  MusicTitle(
                    title: song[i].artistStatic.fullName,
                    // !=
                    //         song[i].artistStatic.firstName
                    //     ? song[i].artistStatic.stageName
                    //     : song[i].artistStatic.fullName,

                    lines: 1,
                    fontSize: 12,
                    color:
                        snapshot?.data?.audio?.audio?.metas?.id == song[i].sId
                            ? cPrimaryColor
                            : cDarkGray,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
