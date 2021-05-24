import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;
  final String playlistId;

  const PlaylistDetailScreen({this.playlist, this.playlistId});
  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  LocalSongsBloc localBloc;

  @override
  void initState() {
    super.initState();
  }

  ApiBloc bloc;
  List<dynamic> songs = [];
  PlayerBloc playerBloc;
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    localBloc = LocalSongsProvider.of(context);
    playerBloc = PlayerProvider.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: widget.playlistId != null
                ? FutureBuilder(
                    future: bloc.fetchPlaylistDetails(widget.playlistId),
                    builder: (BuildContext context,
                        AsyncSnapshot<Playlist> snapshot) {
                      if (!snapshot.hasData) {
                        return const CustomLoader();
                      } else {
                        return buildBody(snapshot.data);
                      }
                    },
                  )
                : buildBody(widget.playlist),
          ),
          ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(Playlist playlist) {
    return FutureBuilder(
      future: playlist.isLocal
          ? bloc.fetchLocalSongs(playlist)
          : bloc.fetchPlaylistSong(playlist.sId),
      initialData: bloc.playlistSongs[playlist.sId],
      builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  playlist.name ?? '',
                  style: const TextStyle(fontFamilyFallback: f),
                ),
              ),
              SliverFillRemaining(
                child: const CustomLoader(),
              )
            ],
          );
        } else if (snapshot.data.length == 0) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  playlist.name ?? '',
                  style: const TextStyle(fontFamilyFallback: f),
                ),
              ),
              buildSliverFillRemaining(context, bloc, playlist),
            ],
          );
        } else {
          songs = snapshot.data;

          return buildContentBody(playlist, context);
        }
      },
    );
  }

  Widget buildContentBody(Playlist playlist, BuildContext context) {
    return Scaffold(
      floatingActionButton: PlayAllFAB(songs: bloc.songs),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  playlist.name ?? '',
                  style: const TextStyle(fontFamilyFallback: f),
                ),
              ),
              buildSliverList(playlist),
              SliverToBoxAdapter(child: SizedBox(height: 66)),
            ],
          ),
          // DownloadProgress(),
        ],
      ),
    );
  }

  Widget buildSliverList(Playlist playlist) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext ctx, int i) {
          return playlist.isLocal
              ? Dismissible(
                  background: Container(
                    padding: const EdgeInsets.all(5),
                    color: RED.withOpacity(0.25),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete),
                  ),
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  child: SongTile(songs: songs, index: i, playlist: playlist),
                  onDismissed: (DismissDirection d) async {
                    await bloc.removeSongFromPlaylist(songs[i], playlist);
                    setState(() {});
                  },
                )
              : SongTile(songs: songs, index: i, playlist: playlist);
        },
        childCount: songs.length,
      ),
    );
  }

  Widget buildSliverFillRemaining(
      BuildContext context, ApiBloc bloc, Playlist playlist) {
    return SliverFillRemaining(
      child: !playlist.isLocal
          ? Center(
              child: Text('Coming Soon'),
            )
          : IconButton(
              icon: const Icon(Ionicons.add_circle_outline),
              onPressed: () async {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  isScrollControlled: true,
                  backgroundColor: CANVAS_BLACK,
                  // barrierColor: Theme.of(context).scaffoldBackgroundColor,
                  context: context,
                  builder: (BuildContext ctx) {
                    return DraggableScrollableSheet(
                      expand: false,
                      builder: (BuildContext ctx, ScrollController ctr) {
                        return buildSongsList(bloc);
                      },
                    );
                  },
                );
                // setState(() {});
              },
            ),
    );
  }

  Widget buildSongsList(ApiBloc bloc) {
    return Container(
      child: FutureBuilder(
        future: bloc.fetchSongs(1, 100),
        initialData: bloc.songs,
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container(child: const CustomLoader(), height: 100);
          } else {
            List<Song> songsList = snapshot.data;
            songsList.insert(0, null);

            return ListView.builder(
              itemCount: songsList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return index == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text('Slide a song to add it'),
                          ),
                          IconButton(
                            icon: Icon(Ionicons.trash),
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    : Dismissible(
                        child: SongTile(
                            songs: songsList, index: index, clickable: false),
                        background: Container(
                          padding: const EdgeInsets.all(5),
                          color: BLUE,
                          alignment: Alignment.centerRight,
                          child: const Icon(Ionicons.add),
                        ),
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection d) async {
                          await bloc.addSongToPlaylist(
                              songsList[index], widget.playlist);
                          setState(() {});
                          if (songsList.isEmpty) {
                            Navigator.pop(context);
                          }
                        },
                      );
              },
            );
          }
        },
      ),
    );
  }
}
