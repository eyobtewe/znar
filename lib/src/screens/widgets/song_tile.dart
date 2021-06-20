import 'dart:isolate';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';
import 'package:znar/src/infrastructure/services/download_manager.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../infrastructure/services/firebase_dynamic_link.dart';
import '../../presentation/bloc.dart';

class SongTile extends StatefulWidget {
  final List<dynamic> songs;
  final int index;
  final dynamic playlist;
  final bool clickable;

  const SongTile(
      {this.songs, this.index, this.playlist, this.clickable = true});

  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  List<dynamic> _tasks;

  ReceivePort _port = ReceivePort();

  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);
    final UiBloc uiBloc = UiProvider.of(context);

    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return Container(
      width: size.width,
      child: InkWell(
        onTap: !widget.clickable
            ? null
            : () {
                _onTap(playerBloc);
              },
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(5),
                  child: CachedPicture(
                      image: widget.songs[widget.index].coverArt ?? ''),
                ),
              ),
              VerticalDivider(color: TRANSPARENT),
              StreamBuilder<Playing>(
                  stream: playerBloc.audioPlayer.current,
                  builder: (_, AsyncSnapshot<Playing> snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
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
              buildPopupMenuButton(uiBloc, playerBloc),
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
                ? PRIMARY_COLOR
                : PRIMARY_COLOR.withAlpha(200)
            : songTitle
                ? GRAY
                : DARK_GRAY,
        fontFamilyFallback: f,
        fontSize: ScreenUtil().setSp(songTitle ? 12 : 10),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildPopupMenuButton(UiBloc uiBloc, PlayerBloc playerBloc) {
    final TargetPlatform platform = Theme.of(context).platform;

    return PopupMenuButton(
      color: CANVAS_BLACK,
      padding: EdgeInsets.zero,
      enableFeedback: true,
      iconSize: 16,
      icon: Icon(
        Ionicons.ellipsis_vertical_outline,
        color: GRAY,
        // size: 16,
      ),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(0),
      //     side: BorderSide(
      //       color: CANVAS_BLACK,
      //       width: 2,
      //     )),
      itemBuilder: (_) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            height: 25,
            padding: EdgeInsets.only(left: 15),
            child: ListTile(
              dense: false,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              leading: Icon(Ionicons.play, color: GRAY, size: 16),
              title: Text(
                Language.locale(uiBloc.language, 'play'),
                style: TextStyle(
                  fontFamilyFallback: f,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                _onTap(playerBloc);
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            height: 25,
            padding: EdgeInsets.zero,
            child: ListTile(
              dense: false,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              visualDensity: VisualDensity.compact,
              leading: Icon(Ionicons.download, color: GRAY, size: 16),
              title: Text(
                Language.locale(uiBloc.language, 'download'),
                //       style: TextStyle(fontFamilyFallback: f,fontSize: 14,),
              ),
              onTap: () async {
                await DownloadsManager()
                    .downloadMusic(platform, widget.songs[widget.index]);
                Navigator.pop(context);
              },
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            height: 25,
            padding: EdgeInsets.only(left: 15),
            child: ListTile(
              dense: false,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              horizontalTitleGap: 0,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              leading:
                  Icon(Ionicons.share_social_outline, color: GRAY, size: 16),
              title: Text(
                Language.locale(uiBloc.language, 'share'),
                style: TextStyle(
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
          ),
        ];
      },
    );
  }

  void _onTap(PlayerBloc playerBloc) {
    if (playerBloc.audioPlayer != null) {
      playerBloc.audioPlayer.stop();
    }

    playerBloc.audioInit(widget.index, widget.songs,
        widget.songs[widget.index].runtimeType != Song);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => AudioPlayerScreen(
    //       songs: songs,
    //       i: index,
    //       isLocal: songs[index].runtimeType == SongInfo,
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    // FlutterDownloader.initialize();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');

      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
