import 'package:progress_dialog/progress_dialog.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';
import '../../infrastructure/services/download_manager.dart';
import 'more_btn.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../infrastructure/services/firebase_dynamic_link.dart';
import '../../presentation/bloc.dart';
import 'custom_loader.dart';

class SongTile extends StatefulWidget {
  final List<dynamic> songs;
  final int index;
  final dynamic playlist;
  final bool clickable;

  const SongTile(
      {Key key, this.songs, this.index, this.playlist, this.clickable = true})
      : super(key: key);

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  // List<dynamic> _tasks;
  ProgressDialog progressDialog;
  LocalSongsBloc localSongsBloc;
  UiBloc uiBloc;
  PlayerBloc playerBloc;
  bool isDownloaded = false;
  // ReceivePort _port = ReceivePort();
  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      isDismissible: false,
    );
    localSongsBloc = LocalSongsProvider.of(context);
    playerBloc = PlayerProvider.of(context);
    uiBloc = UiProvider.of(context);

    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return SizedBox(
      width: size.width,
      child: InkWell(
        onTap: !widget.clickable
            ? null
            : () {
                _onTap(playerBloc);
              },
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(5),
                  child: CachedPicture(
                      image: widget.songs[widget.index].coverArt ?? ''),
                ),
              ),
              const VerticalDivider(color: cTransparent),
              StreamBuilder<Playing>(
                  stream: playerBloc.audioPlayer.current,
                  builder: (_, AsyncSnapshot<Playing> snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width - 165,
                          child: buildTitle(
                              snapshot, widget.songs[widget.index].title, true),
                        ),
                        buildTitle(
                            snapshot,
                            widget.songs[widget.index].runtimeType == Song
                                ? widget.songs[widget.index].artistStatic
                                        ?.fullName ??
                                    ''
                                : widget.songs[widget.index].artist ?? '',
                            false),
                      ],
                    );
                  }),
              // buildPopupMenuButton(uiBloc, playerBloc),
              MoreBtn(songs: widget.songs, index: widget.index),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(
      AsyncSnapshot<Playing> snapshot, String title, bool songTitle) {
    return Text(
      title ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: snapshot?.data?.audio?.audio?.metas?.id ==
                widget.songs[widget.index].sId
            ? songTitle
                ? cPrimaryColor
                : cPrimaryColor.withAlpha(200)
            : songTitle
                ? cGray
                : cDarkGray,
        fontFamilyFallback: f,
        fontSize:
            // ScreenUtil().setSp(
            songTitle ? 14 : 12
        // )
        ,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildPopupMenuButton(UiBloc uiBloc, PlayerBloc playerBloc) {
    return PopupMenuButton(
      color: cCanvasBlack,
      padding: EdgeInsets.zero,
      enableFeedback: true,
      iconSize: 16,
      icon: const Icon(
        Ionicons.ellipsis_vertical_outline,
        color: cGray,
      ),
      itemBuilder: (_) {
        return <PopupMenuEntry>[
          buildPlayBtn(uiBloc, playerBloc),
          const PopupMenuDivider(),
          buildDownloadBtn(uiBloc, context),
          const PopupMenuDivider(),
          buildShareBtn(uiBloc),
        ];
      },
    );
  }

  Widget buildShareBtn(UiBloc uiBloc) {
    return PopupMenuItem(
      height: 25,
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        dense: false,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        leading:
            const Icon(Ionicons.share_social_outline, color: cGray, size: 16),
        title: Text(
          Language.locale(uiBloc.language, 'share'),
          style: const TextStyle(
            fontFamilyFallback: f,
            fontSize: 14,
          ),
        ),
        onTap: () async {
          final String link = await kDynamicLinkService
              .createDynamicLink(widget.songs[widget.index]);

          Share.share(
              '${widget.songs[widget.index].title} - ${widget.songs[widget.index].artistStatic.fullName} \n\n$link');
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildPlayBtn(UiBloc uiBloc, PlayerBloc playerBloc) {
    return PopupMenuItem(
      height: 25,
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        dense: false,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        leading: const Icon(Ionicons.play, color: cGray, size: 16),
        title: Text(
          Language.locale(uiBloc.language, 'play'),
          style: const TextStyle(
            fontFamilyFallback: f,
            fontSize: 14,
          ),
        ),
        onTap: () {
          _onTap(playerBloc);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildDownloadBtn(UiBloc uiBloc, BuildContext context) {
    // if (localSongsBloc.downloadedSongs.isNotEmpty) {
    //   localSongsBloc.downloadedSongs.forEach((element) {
    //     if (element = !null &&
    //         (widget.songs[widget.index] = !null) &&
    //         (element.sId == widget.songs[widget.index].sId)) {
    //       setState(() {
    //         isDownloaded = true;
    //       });
    //     }
    //   });
    // }

    return PopupMenuItem(
      height: 25,
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        dense: false,
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        visualDensity: VisualDensity.compact,
        leading: Icon(
          isDownloaded ? Ionicons.checkmark : Ionicons.download,
          color: cGray,
          size: 16,
        ),
        title: Text(
          Language.locale(uiBloc.language, 'download'),
          //       style: TextStyle(fontFamilyFallback: f,fontSize: 14,),
        ),
        onTap: () async {
          if (isDownloaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Already Downloaded',
                  style: TextStyle(color: cBackgroundColor),
                ),
                backgroundColor: cPrimaryColor,
              ),
            );
          } else {
            Navigator.pop(context);

            progressDialog.style(
              textAlign: TextAlign.center,
              backgroundColor: cCanvasBlack,
              progressWidgetAlignment: Alignment.center,
              progressWidget: const CustomLoader(),
              messageTextStyle: const TextStyle(
                color: cCanvasBlack,
                fontFamilyFallback: f,
              ),
            );
            await progressDialog.show();

            await DownloadsManager().downloadMusic(widget.songs[widget.index],
                onReceiveProgress: (int i, int j) {
              progressDialog.update(
                message: 'Downloading',
                progressWidget: Text('${(i * 100 / j).toStringAsFixed(0)}%'),
              );
            });

            await localSongsBloc.getDownloadedMusic();
            await progressDialog.hide();
            setState(() {});
          }
        },
      ),
    );
  }

  void _onTap(PlayerBloc playerBloc) {
    if (playerBloc.audioPlayer != null) {
      playerBloc.audioPlayer.stop();
    }

    playerBloc.audioInit(widget.index, widget.songs,
        widget.songs[widget.index].runtimeType != Song);
  }
}
