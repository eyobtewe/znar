import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ionicons/ionicons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
    @required this.playlist,
  }) : super(key: key);

  final List<Song> songs;
  final int index;
  final Playlist playlist;

  @override
  _MoreBtnState createState() => _MoreBtnState();
}

class _MoreBtnState extends State<MoreBtn> {
  List<Playlist> temp = [];
  bool isDownloaded = false;
  ProgressDialog progressDialog;
  LocalSongsBloc localSongsBloc;
  // List<DownloadedSong> downloadedSongs = [];

  void initState() {
    super.initState();

    getPlaylists();
  }

  // getDownloads() async {
  //   downloadedSongs = await DownloadsManager().getDownloaded(Theme.of(context).platform);
  // }

  void getPlaylists() async {
    final r = Repository();
    temp = await r.fetchLocalPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    // getDownloads();
    final ApiBloc bloc = ApiProvider.of(context);
    final UiBloc uiBloc = UiProvider.of(context);
    localSongsBloc = LocalSongsProvider.of(context);
    progressDialog = ProgressDialog(
      context,
      isDismissible: false,
    );
    return PopupMenuButton(
      color: CANVAS_BLACK,
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, size: 16),
      itemBuilder: (BuildContext ctx) {
        return <PopupMenuEntry>[
          // buildShareItem(bloc, context, uiBloc),
          (widget.playlist != null || temp.isEmpty) ? null : PopupMenuDivider(),
          buildAddToPlaylistItem(uiBloc, context, bloc),
          PopupMenuDivider(),
          buildCreatePlaylistItem(uiBloc, context),
          PopupMenuDivider(),
          buildDownloadItem(uiBloc, context),
        ];
      },
    );
  }

  Widget buildDownloadItem(UiBloc uiBloc, BuildContext context) {
    if (localSongsBloc.downloadedSongs.isNotEmpty) {
      localSongsBloc.downloadedSongs.forEach((element) {
        if (element.sId == widget.songs[widget.index].sId) {
          setState(() {
            isDownloaded = true;
          });
        }
      });
    }
    return PopupMenuItem(
      child: InkWell(
        onTap: () async {
          Navigator.pop(context);
          if (isDownloaded) {
            await showToast('Already downloaded');
          } else {
            progressDialog.style(
              textAlign: TextAlign.center,
              backgroundColor: CANVAS_BLACK,
              progressWidgetAlignment: Alignment.center,
              progressWidget: CustomLoader(),
              messageTextStyle: TextStyle(
                color: GRAY,
                fontFamilyFallback: f,
              ),
            );
            await progressDialog.show();

            await localSongsBloc.downloadMusic(
              Theme.of(context).platform,
              widget.songs[widget.index],
              progress: (int i, int j) {
                progressDialog.update(
                  // maxProgress: (j ~/ 1024).toDouble(),
                  // progress: (i ~/ 1024).toDouble(),
                  message: 'Downloading',
                  progressWidget: buildDownloadSpinner(i, j),
                );
              },
            );

            await localSongsBloc.getDownloadedMusic(Theme.of(context).platform);
            await progressDialog.hide();
            setState(() {});
          }
        },
        child: Container(
          height: 35,
          child: Row(
            children: [
              Icon(isDownloaded ? Icons.check : Icons.file_download, size: 16),
              const VerticalDivider(color: TRANSPARENT),
              Text(
                isDownloaded
                    ? Language.locale(uiBloc.language, 'downloaded')
                    : Language.locale(uiBloc.language, 'download'),
                style: const TextStyle(
                  fontFamilyFallback: f,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDownloadSpinner(int i, int j) {
    return Center(
      child: Container(
        height: 30,
        width: 30,
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
            startAngle: 120,
            angleRange: 300,
          ),
        ),
      ),
    );
  }

  Widget buildCreatePlaylistItem(UiBloc uiBloc, BuildContext context) {
    return PopupMenuItem(
      height: 35,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          return showDialog(
            context: context,
            builder: (BuildContext ctx) => CreatePlaylist(
              song: widget.songs[widget.index],
            ),
          );
        },
        child: Container(
          height: 35,
          child: Row(
            children: [
              Icon(
                Ionicons.add_circle_outline,
                size: 16,
              ),
              const VerticalDivider(color: TRANSPARENT),
              Text(
                Language.locale(uiBloc.language, 'create_playlist'),
                style: const TextStyle(
                  fontFamilyFallback: f,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
  //             const VerticalDivider(color: TRANSPARENT),
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

  Widget buildAddToPlaylistItem(
      UiBloc uiBloc, BuildContext context, ApiBloc bloc) {
    return (widget.playlist != null || temp.isEmpty)
        ? null
        : PopupMenuItem(
            height: 35,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                return buildShowModalBottomSheet(context, bloc, uiBloc);
              },
              child: Container(
                height: 35,
                child: Row(
                  children: [
                    Icon(
                      Icons.playlist_add,
                      size: 16,
                    ),
                    const VerticalDivider(color: TRANSPARENT),
                    Text(Language.locale(uiBloc.language, 'add_to_playlist'),
                        style: const TextStyle(
                          fontFamilyFallback: f,
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
          );
  }

  buildShowModalBottomSheet(BuildContext context, ApiBloc bloc, uiBloc) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      isScrollControlled: true,
      backgroundColor: CANVAS_BLACK,
      builder: (BuildContext ctx) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext ctx, ScrollController ctr) {
            return showPlaylists(bloc.localPlaylists, bloc, uiBloc);
          },
        );
      },
    );
  }

  Widget showPlaylists(List<Playlist> playlist, ApiBloc bloc, uiBloc) {
    return FutureBuilder(
      future: bloc.fetchLocalPlaylists(),
      initialData: bloc.localPlaylists,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: const CustomLoader(),
            height: 50,
          );
        } else {
          List<Playlist> playlistList = snapshot.data;
          playlistList.insert(0, null);
          return ListView.builder(
            itemCount: playlistList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text('Select a playlist'),
                        ),
                      ],
                    )
                  : PlaylistTile(
                      playlist: playlistList[index],
                      padded: 0,
                      onTap: () async {
                        int b = await bloc.addSongToPlaylist(
                            widget.songs[widget.index], playlistList[index]);
                        Navigator.pop(context);
                        ScaffoldMessengerState().showSnackBar(
                          SnackBar(
                            backgroundColor: BLUE,
                            content: Text(
                              b != null
                                  ? Language.locale(
                                      uiBloc.language, 'song_added')
                                  : Language.locale(
                                      uiBloc.language, 'failed_song_added'),
                            ),
                          ),
                        );
                      },
                    );
            },
          );
        }
      },
    );
  }
}
