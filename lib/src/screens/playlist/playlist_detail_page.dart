import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';
import '../../infrastructure/services/services.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;
  final String playlistId;

  const PlaylistDetailScreen({Key key, this.playlist, this.playlistId})
      : super(key: key);
  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
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
  @override
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
          const ExpandableBottomPlayer(),
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
      builder: (_, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  playlist.name ?? '',
                  style: const TextStyle(fontFamilyFallback: f),
                ),
              ),
              const SliverFillRemaining(
                child: CustomLoader(),
              )
            ],
          );
        } else if (snapshot.data.isEmpty) {
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
                actions: [
                  IconButton(
                      onPressed: () async {
                        final String link = await kDynamicLinkService
                            .createDynamicLink(playlist);

                        Share.share('${playlist.name}  \n\n$link');
                      },
                      icon: const Icon(Ionicons.share_social_outline))
                ],
              ),
              buildSliverList(playlist),
              const SliverToBoxAdapter(child: BottomPlayerSpacer()),
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
        (_, int i) {
          return playlist.isLocal
              ? Dismissible(
                  background: Container(
                    padding: const EdgeInsets.all(5),
                    color: cRed.withOpacity(0.25),
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
          ? const Center(
              child: Text('Coming Soon'),
            )
          : IconButton(
              icon: const Icon(Ionicons.add_circle_outline),
              onPressed: () async {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  isScrollControlled: true,
                  backgroundColor: cCanvasBlack,
                  // barrierColor: Theme.of(context).scaffoldBackgroundColor,
                  context: context,
                  builder: (_) {
                    return DraggableScrollableSheet(
                      expand: false,
                      builder: (_, ScrollController ctr) {
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
    return FutureBuilder(
      future: bloc.fetchSongs(1, 100),
      initialData: bloc.songs,
      builder: (_, AsyncSnapshot<List<Song>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 100, child: CustomLoader());
        } else {
          List<Song> songsList = snapshot.data;
          songsList.insert(0, null);

          return ListView.builder(
            itemCount: songsList.length,
            shrinkWrap: true,
            itemBuilder: (_, int index) {
              return index == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Slide a song to add it'),
                        ),
                        IconButton(
                          icon: const Icon(Ionicons.trash),
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  : Dismissible(
                      background: Container(
                        padding: const EdgeInsets.all(5),
                        color: cBlue,
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
                      child: SongTile(
                          songs: songsList, index: index, clickable: false),
                    );
            },
          );
        }
      },
    );
  }
}
