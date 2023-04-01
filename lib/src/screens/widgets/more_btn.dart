import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../external_src/audio_progress_bar/progress_dialog.dart';
import '../../infrastructure/services/services.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/repository/repository.dart';
import '../../infrastructure/services/download_manager.dart';
import '../../presentation/bloc.dart';
import 'widgets.dart';

class MoreBtn extends StatefulWidget {
  const MoreBtn({
    Key key,
    @required this.songs,
    @required this.index,
    // @required this.playlist,
  }) : super(key: key);

  final List<Song> songs;
  final int index;
  // final Playlist playlist;

  @override
  State<MoreBtn> createState() => _MoreBtnState();
}

class _MoreBtnState extends State<MoreBtn> {
  List<Playlist> temp = [];
  bool isDownloaded = false;
  ProgressDialog progressDialog;
  LocalSongsBloc localSongsBloc;
  PlayerBloc playerBloc;
  // List<DownloadedSong> downloadedSongs = [];

  @override
  void initState() {
    super.initState();

    // getPlaylists();
  }

  // getDownloads() async {
  //   downloadedSongs = await DownloadsManager().getDownloaded(Theme.of(context).platform);
  // }

  void getPlaylists() async {
    final r = Repository();
    temp = await r.fetchLocalPlaylists();
  }

  TextStyle textStyle = const TextStyle(
    fontFamilyFallback: f,
    fontSize: 14,
    color: cGray,
  );
  @override
  Widget build(BuildContext context) {
    // getDownloads();
    // final ApiBloc bloc = ApiProvider.of(context);
    playerBloc = PlayerProvider.of(context);
    final UiBloc uiBloc = UiProvider.of(context);
    localSongsBloc = LocalSongsProvider.of(context);
    progressDialog = ProgressDialog(
      context,
      isDismissible: false,
    );

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
          style: textStyle,
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
          style: textStyle,
        ),
        onTap: () {
          _onTap(playerBloc);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildDownloadBtn(UiBloc uiBloc, BuildContext context) {
    if (localSongsBloc.downloadedSongs != null) {
      for (final element in localSongsBloc.downloadedSongs) {
        if (element != null &&
            (widget.songs[widget.index] != null) &&
            (element.sId == widget.songs[widget.index].sId)) {
          setState(() {
            isDownloaded = true;
          });
        }
      }
    }

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
          style: textStyle,
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
              child: IconButton(
                  onPressed: () async {
                    cancelDownload();
                  },
                  icon: const Icon(
                    Ionicons.close,
                  )),
              messageTextStyle: const TextStyle(
                color: cCanvasBlack,
                fontFamilyFallback: f,
              ),
            );
            await progressDialog.show();

            await DownloadsManager().downloadMusic(widget.songs[widget.index],
                onReceiveProgress: (int i, int j) {
              progressDialog.update(
                // message: 'Downloading',
                progressWidget: Row(
                  children: [
                    buildDownloadSpinner(i, j),
                    const VerticalDivider(color: cTransparent),
                    const Text('Downloading...'),
                    const VerticalDivider(color: cTransparent),
                    const VerticalDivider(color: cTransparent),
                    const VerticalDivider(color: cTransparent),
                    IconButton(
                      onPressed: () async {
                        cancelDownload();
                      },
                      icon: const Icon(Ionicons.close),
                      color: cPrimaryColor,
                    ),
                  ],
                ),
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

  Widget buildDownloadSpinner(int i, int j) {
    return SizedBox(
      height: 35,
      width: 35,
      child: SleekCircularSlider(
        min: 0,
        initialValue: i.toDouble(),
        max: j.toDouble(),
        appearance: CircularSliderAppearance(
          size: 0,
          customWidths: CustomSliderWidths(
            progressBarWidth: 4,
            trackWidth: 0,
          ),
          customColors: CustomSliderColors(
            progressBarColor: cPrimaryColor,
          ),
          startAngle: 180,
          angleRange: 180,
        ),
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

  Future<void> cancelDownload() async {
    localSongsBloc.killDownloader();
    await progressDialog.hide();
  }

  // Widget buildDownloadItem(UiBloc uiBloc, BuildContext context) {
  //   if (localSongsBloc.downloadedSongs.isNotEmpty) {
  //     localSongsBloc.downloadedSongs.forEach((element) {
  //       if (element.sId == widget.songs[widget.index].sId) {
  //         setState(() {
  //           isDownloaded = true;
  //         });
  //       }
  //     });
  //   }
  //   return PopupMenuItem(
  //     child: InkWell(
  //       onTap: () async {
  //         Navigator.pop(context);
  //         if (isDownloaded) {
  //           await showToast('Already downloaded');
  //         } else {
  //           progressDialog.style(
  //             textAlign: TextAlign.center,
  //             backgroundColor: cCanvasBlack,
  //             progressWidgetAlignment: Alignment.center,
  //             progressWidget: CustomLoader(),
  //             messageTextStyle: TextStyle(
  //               color: cGray,
  //               fontFamilyFallback: f,
  //             ),
  //           );
  //           await progressDialog.show();
  //           await localSongsBloc.downloadMusic(
  //             Theme.of(context).platform,
  //             widget.songs[widget.index],
  //             progress: (int i, int j) {
  //               progressDialog.update(
  //                 // maxProgress: (j ~/ 1024).toDouble(),
  //                 // progress: (i ~/ 1024).toDouble(),
  //                 message: 'Downloading',
  //                 progressWidget: buildDownloadSpinner(i, j),
  //               );
  //             },
  //           );
  //           await localSongsBloc.getDownloadedMusic(Theme.of(context).platform);
  //           await progressDialog.hide();
  //           setState(() {});
  //         }
  //       },
  //       child: Container(
  //         height: 35,
  //         child: Row(
  //           children: [
  //             Icon(isDownloaded ? Icons.check : Icons.file_download, size: 16),
  //             const VerticalDivider(color: cTransparent),
  //             Text(
  //               isDownloaded
  //                   ? Language.locale(uiBloc.language, 'downloaded')
  //                   : Language.locale(uiBloc.language, 'download'),
  //               style: const TextStyle(
  //                 fontFamilyFallback: f,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget buildCreatePlaylistItem(UiBloc uiBloc, BuildContext context) {
  //   return PopupMenuItem(
  //     height: 35,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.pop(context);
  //         return showDialog(
  //           context: context,
  //           builder: (_) => CreatePlaylist(
  //             song: widget.songs[widget.index],
  //           ),
  //         );
  //       },
  //       child: Container(
  //         height: 35,
  //         child: Row(
  //           children: [
  //             Icon(
  //               Ionicons.add_circle_outline,
  //               size: 16,
  //             ),
  //             const VerticalDivider(color: cTransparent),
  //             Text(
  //               Language.locale(uiBloc.language, 'create_playlist'),
  //               style: const TextStyle(
  //                 fontFamilyFallback: f,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget buildShareItem(ApiBloc bloc, BuildContext context, UiBloc uiBloc) {
  //   return PopupMenuItem(
  //     height: 35,
  //     child: InkWell(
  //       onTap: () async {
  //         final String _title = widget.songs[widget.index].title ?? '';
  //         final String _artist =
  //             widget.songs[widget.index].artistStatic?.stageName ?? '';
  //         final String link = await bloc.dynamikLinkService
  //             .createDynamicLink(widget.songs[widget.index]);
  //         Share.share(
  //             'Listen to $_artist - $_title on IAAM streaming app \n$link');
  //         Navigator.pop(context);
  //       },
  //       child: Container(
  //         height: 35,
  //         child: Row(
  //           children: [
  //             const Icon(Icons.share, size: 16),
  //             const VerticalDivider(color: cTransparent),
  //             Text(
  //               Language.locale(uiBloc.language, 'share'),
  //               style: const TextStyle(
  //                 fontFamilyFallback: f,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget buildAddToPlaylistItem(
  //     UiBloc uiBloc, BuildContext context, ApiBloc bloc) {
  //   return (widget.playlist != null || temp.isEmpty)
  //       ? null
  //       : PopupMenuItem(
  //           height: 35,
  //           child: InkWell(
  //             onTap: () {
  //               Navigator.pop(context);
  //               return buildShowModalBottomSheet(context, bloc, uiBloc);
  //             },
  //             child: Container(
  //               height: 35,
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.playlist_add,
  //                     size: 16,
  //                   ),
  //                   const VerticalDivider(color: cTransparent),
  //                   Text(Language.locale(uiBloc.language, 'add_to_playlist'),
  //                       style: const TextStyle(
  //                         fontFamilyFallback: f,
  //                         fontSize: 14,
  //                       )),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  // }
  // buildShowModalBottomSheet(BuildContext context, ApiBloc bloc, uiBloc) {
  //   return showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: cCanvasBlack,
  //     builder: (_) {
  //       return DraggableScrollableSheet(
  //         expand: false,
  //         builder: (_, ScrollController ctr) {
  //           return showPlaylists(bloc.localPlaylists, bloc, uiBloc);
  //         },
  //       );
  //     },
  //   );
  // }
  // Widget showPlaylists(List<Playlist> playlist, ApiBloc bloc, uiBloc) {
  //   return FutureBuilder(
  //     future: bloc.fetchLocalPlaylists(),
  //     initialData: bloc.localPlaylists,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Container(
  //           child: const CustomLoader(),
  //           height: 50,
  //         );
  //       } else {
  //         List<Playlist> playlistList = snapshot.data;
  //         playlistList.insert(0, null);
  //         return ListView.builder(
  //           itemCount: playlistList.length,
  //           shrinkWrap: true,
  //           itemBuilder: (_, int index) {
  //             return index == 0
  //                 ? Row(
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(15),
  //                         child: Text('Select a playlist'),
  //                       ),
  //                     ],
  //                   )
  //                 : PlaylistTile(
  //                     playlist: playlistList[index],
  //                     padded: 0,
  //                     onTap: () async {
  //                       int b = await bloc.addSongToPlaylist(
  //                           widget.songs[widget.index], playlistList[index]);
  //                       Navigator.pop(context);
  //                       ScaffoldMessengerState().showSnackBar(
  //                         SnackBar(
  //                           backgroundColor: cBlue,
  //                           content: Text(
  //                             b != null
  //                                 ? Language.locale(
  //                                     uiBloc.language, 'song_added')
  //                                 : Language.locale(
  //                                     uiBloc.language, 'failed_song_added'),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   );
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

}
