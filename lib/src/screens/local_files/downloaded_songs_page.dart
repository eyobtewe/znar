import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({Key key, this.isHome = false}) : super(key: key);
  final bool isHome;
  @override
  _DownloadedSongsScreenState createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  LocalSongsBloc localBloc;
  UiBloc uiBloc;
  PlayerBloc playerBloc;
  ScrollController myScrollController;
  Directory externalDirectory;

  @override
  void initState() {
    super.initState();

    myScrollController = ScrollController();
  }

  Widget build(BuildContext context) {
    localBloc = LocalSongsProvider.of(context);
    uiBloc = UiProvider.of(context);
    playerBloc = PlayerProvider.of(context);

    return Scaffold(
      appBar: widget.isHome ? null : buildAppBar(context),
      bottomNavigationBar: widget.isHome ? null : BottomScreenPlayer(),
      body: FutureBuilder(
        future: localBloc.getDownloadedMusic(Theme.of(context).platform),
        initialData: localBloc.downloadedSongs,
        builder: (BuildContext context,
            AsyncSnapshot<List<DownloadedSong>> snapshot) {
          if (!snapshot.hasData) {
            // if (snapshot.connectionState != ConnectionState.done) {
            return CustomLoader();
            // } else {
            //   return Center(child: Text('DONE'));
            // }
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                '0 ' + Language.locale(uiBloc.language, 'songs'),
                style: TextStyle(
                  fontFamilyFallback: f,
                ),
              ),
            );
          } else {
            return buildBody(localBloc.downloadedSongs);
          }
        },
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        Language.locale(uiBloc.language, 'downloaded_songs'),
        style: TextStyle(fontFamilyFallback: f),
      ),
      centerTitle: true,
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.delete),
      //     onPressed: () {
      //       localBloc.deleteDownloads([]);
      //       Fluttertoast.showToast(
      //         msg: 'All songs have been deleted',
      //         backgroundColor: PURE_WHITE,
      //         textColor: BACKGROUND,
      //       );

      //       setState(() {});
      //     },
      //   )
      // ],
    );
  }

  Widget buildBody(List<DownloadedSong> songs) {
    return Container(
      child: DraggableScrollbar.rrect(
          scrollThumbKey: PageStorageKey('value'),
          backgroundColor: Theme.of(context).canvasColor,
          scrollbarAnimationDuration: Duration.zero,
          heightScrollThumb: 30,
          controller: myScrollController,
          child: buildListView(songs)),
    );
  }

  Widget buildListView(List<DownloadedSong> songs) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 16),
      controller: myScrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return songs[index]?.sId == null
            ? Container()
            : Dismissible(
                child: buildSong(songs, index),
                background: Container(
                  padding: const EdgeInsets.all(5),
                  color: RED.withOpacity(0.25),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete),
                ),
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (DismissDirection d) {
                  if (d == DismissDirection.endToStart) {
                    localBloc.deleteDownloads([songs[index]]);
                    setState(() {});
                  }
                },
              );
      },
    );
  }

  Widget buildSong(List<DownloadedSong> songs, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 10),
      leading: CircleAvatar(
        backgroundImage: songs[index]?.image != null
            ? MemoryImage(songs[index].image)
            : AssetImage('assets/images/app-logo.jpg'),
        // child: songs[index].image != null ? Container() : Icon(FontAwesome.play_circle),
      ),
      dense: true,
      title: Container(
        width: 50,
        child: Text(
          songs[index]?.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamilyFallback: f),
        ),
      ),
      subtitle: Text(
        songs[index]?.artist ?? '',
        style: const TextStyle(color: GRAY, fontFamilyFallback: f),
      ),
      onTap: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(index, songs, false, true);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext ctx) => AudioPlayerScreen(
              // songs: songs,
              i: index,
              isLocal: false,
              isDownloaded: true,
            ),
          ),
        );
      },
    );
  }
}
