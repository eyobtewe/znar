import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';
import 'package:znar/src/infrastructure/services/download_manager.dart';
import 'package:znar/src/infrastructure/services/firebase_dynamic_link.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';

class SongTile extends StatelessWidget {
  final List<dynamic> songs;
  final int index;
  final Playlist playlist;
  final bool clickable;

  const SongTile(
      {this.songs, this.index, this.playlist, this.clickable = true});

  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final UiBloc uiBloc = UiProvider.of(context);

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
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 0),
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
              buildPopupMenuButton(uiBloc, context, playerBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPopupMenuButton(
      UiBloc uiBloc, BuildContext context, PlayerBloc playerBloc) {
    return PopupMenuButton(
      color: PURE_BLACK,
      padding: EdgeInsets.zero,
      icon: Icon(
        Ionicons.ellipsis_vertical_outline,
        color: GRAY,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (BuildContext ctx) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            height: 35,
            child: ListTile(
              dense: false,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              visualDensity: VisualDensity.compact,
              leading: Icon(Ionicons.play, color: GRAY),
              title: Text(
                Language.locale(uiBloc.language, 'play'),
                style: TextStyle(
                  fontFamilyFallback: f,
                ),
              ),
              onTap: () {
                _onTap(context, playerBloc);
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            height: 35,
            child: ListTile(
              dense: false,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              visualDensity: VisualDensity.compact,
              leading: Icon(Ionicons.download, color: GRAY),
              title: Text(
                Language.locale(uiBloc.language, 'download'),
                style: TextStyle(
                  fontFamilyFallback: f,
                ),
              ),
              onTap: () async {
                await DownloadsManager()
                    .downloadMusic(TargetPlatform.android, songs[index]);
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            height: 35,
            child: ListTile(
              dense: false,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              visualDensity: VisualDensity.compact,
              leading: Icon(Ionicons.share_social_outline, color: GRAY),
              title: Text(
                Language.locale(uiBloc.language, 'share'),
                style: TextStyle(
                  fontFamilyFallback: f,
                ),
              ),
              onTap: () async {
                final String link =
                    await kDynamicLinkService.createDynamicLink(songs[index]);

                Share.share(
                    '${songs[index].title} - ${songs[index].artistStatic.fullName} \n\n$link');
                Navigator.pop(context);
              },
            ),
          ),
        ];
      },
    );
  }

  void _onTap(BuildContext context, PlayerBloc playerBloc) {
    if (playerBloc.audioPlayer != null) {
      playerBloc.audioPlayer.stop();
    }

    playerBloc.audioInit(index, songs, songs[index].runtimeType == SongInfo);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext ctx) => AudioPlayerScreen(
    //       songs: songs,
    //       i: index,
    //       isLocal: songs[index].runtimeType == SongInfo,
    //     ),
    //   ),
    // );
  }

  Container buildSongTitle(Size size, PlayerBloc playerBloc) {
    return Container(
      width: size.width - 165,
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
