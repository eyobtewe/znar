import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({Key key, this.isHome = false}) : super(key: key);
  final bool isHome;
  @override
  State<DownloadedSongsScreen> createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  LocalSongsBloc localBloc;
  UiBloc uiBloc;
  PlayerBloc playerBloc;
  ScrollController myScrollController;

  @override
  void initState() {
    super.initState();

    myScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    localBloc = LocalSongsProvider.of(context);
    uiBloc = UiProvider.of(context);
    playerBloc = PlayerProvider.of(context);

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              uiBloc.toggleLanguage();
              setState(() {});
            },
            icon: const Icon(Ionicons.language)),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: localBloc.getDownloadedMusic(),
            initialData: localBloc.downloadedSongs,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const CustomLoader();
                // }
              } else if (snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                    '0 ${Language.locale(uiBloc.language, 'songs')}',
                    style: const TextStyle(fontFamilyFallback: f),
                  ),
                );
              } else {
                return buildBody(localBloc.downloadedSongs);
              }
            },
          ),
          const ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(List<dynamic> songs) {
    return DraggableScrollbar.rrect(
      scrollThumbKey: const PageStorageKey('value'),
      backgroundColor: Theme.of(context).canvasColor,
      scrollbarAnimationDuration: Duration.zero,
      heightScrollThumb: 30,
      controller: myScrollController,
      child: buildListView(songs),
    );
  }

  Widget buildListView(List<dynamic> songs) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 16),
      controller: myScrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return songs[index]?.sId == null
            ? Container()
            : Dismissible(
                background: Container(
                  padding: const EdgeInsets.all(5),
                  color: cRed.withOpacity(0.25),
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
                child: buildSong(songs, index),
              );
      },
    );
  }

  Widget buildSong(List<dynamic> songs, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 0, left: 10),
      leading: CircleAvatar(
        backgroundImage: songs[index].image != null
            ? MemoryImage(songs[index].image)
            : const AssetImage('assets/images/znar_transparent.png'),
      ),
      dense: true,
      title: SizedBox(
        width: 50,
        child: Text(
          songs[index]?.title ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamilyFallback: f),
        ),
      ),
      subtitle: Text(
        songs[index]?.artist ?? '',
        style: const TextStyle(color: cGray, fontFamilyFallback: f),
      ),
      onTap: () {
        if (playerBloc.audioPlayer != null) {
          playerBloc.audioPlayer.stop();
        }
        playerBloc.audioInit(index, songs, false, true);
      },
    );
  }
}
