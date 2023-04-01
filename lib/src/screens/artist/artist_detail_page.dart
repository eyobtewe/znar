import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class ArtistDetailScreen extends StatefulWidget {
  final dynamic artist;
  final String artistId;

  const ArtistDetailScreen({Key key, this.artist, this.artistId})
      : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  Size size;
  ApiBloc bloc;
  LocalSongsBloc localSongsBloc;
  UiBloc uiBloc;
  PlayerBloc playerBloc;

  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    localSongsBloc = LocalSongsProvider.of(context);
    size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          body: Container(
            child: widget.artistId != null
                ? FutureBuilder(
                    future: bloc.fetchArtistDetails(widget.artistId),
                    builder: (_, AsyncSnapshot<Artist> snapshot) {
                      if (!snapshot.hasData) {
                        return const CustomLoader();
                      } else {
                        return buildBody(snapshot.data);
                      }
                    },
                  )
                : buildBody(widget.artist),
          ),
        ),
        const ExpandableBottomPlayer(),
      ],
    );
  }

  Widget buildBody(artist) {
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          elevation: 0,
          stretch: true,
          flexibleSpace: artist.runtimeType == Artist
              ? CachedPicture(image: artist.coverImage, isBackground: true)
              : CustomFileImage(img: artist.artistArtPath),
          expandedHeight: size.width * 9 / 16,
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            artist.runtimeType == Artist
                                ? artist.fullName ?? ''
                                : artist.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontFamilyFallback: f,
                              fontSize: ScreenUtil().setSp(20),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     '1.1K Followers',
                        //     style: TextStyle(
                        //       fontFamilyFallback: f,
                        //       color: cDarkGray,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    // buildFollowBtn(),
                  ],
                ),
              ),
              buildAlbums(artist),
              buildMusicVideos(artist),
              buildSongs(artist),
              const BottomPlayerSpacer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFollowBtn() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isClicked = !isClicked;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            isClicked ? cPrimaryColor : cBackgroundColor),
        elevation: MaterialStateProperty.all(0),
        // visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: cPrimaryColor, width: 1),
          ),
        ),
      ),
      child: Text(
        Language.locale(uiBloc.language, isClicked ? 'following' : 'follow'),
        style: TextStyle(
          color: !isClicked ? cPrimaryColor : cBackgroundColor,
          fontFamilyFallback: f,
        ),
      ),
    );
  }

  Widget buildMusicVideos(Artist artist) {
    return FutureBuilder(
      future: bloc.fetchArtistMusicVideos(artist.sId, ''),
      initialData: bloc.artistMusicVideos[artist.sId],
      builder: (_, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return bloc.artistMusicVideos[artist.sId].isEmpty
              ? Container()
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (_, int index) {
                    return HomeCards(
                      ar: MEDIA.VIDEO,
                      data: bloc.artistMusicVideos[artist.sId],
                      i: index,
                    );
                  },
                  itemCount: bloc.artistMusicVideos[artist.sId].length,
                  shrinkWrap: true,
                  primary: false,
                );
        }
      },
    );
  }

  Widget buildSongs(dynamic artist) {
    return FutureBuilder(
      future:
          //  artist.runtimeType == Artist
          //     ?
          bloc.fetchArtistSongs(artist.sId),
      // : localSongsBloc.getSongsFromArtist(artist.id),
      initialData:
          // artist.runtimeType == Artist
          // ?
          //
          bloc.artistSongs[artist.sId],
      // : localSongsBloc.artistSongs[artist.id],
      builder: (_, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const CustomLoader();
        } else {
          dynamic songs = snapshot.data;
          return ListView.separated(
            itemCount: songs.length,
            shrinkWrap: true,
            primary: false,
            separatorBuilder: (_, int k) {
              return const Divider(height: 1, color: cTransparent);
            },
            itemBuilder: (_, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  index == 0
                      ? buildTitle(
                          '${songs.length > 1 ? songs.length : ''} ${Language.locale(uiBloc.language, 'songs')}',
                          songs)
                      : Container(),
                  SongTile(index: index, songs: songs),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget buildAlbums(dynamic artist) {
    return FutureBuilder(
      future:

          //  artist.runtimeType == Artist
          // ?
          bloc.fetchArtistAlbums(artist.sId),
      // : localSongsBloc.getAlbumsFromArtist(artist.name),
      initialData:
          //  artist.runtimeType == Artist
          // ?
          bloc.artistAlbums[artist.sId],
      // : localSongsBloc.artistAlbums[artist.name],
      builder: (_, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          dynamic album = snapshot.data;
          return album.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(
                        Language.locale(uiBloc.language, 'albums'), null),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: album.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, int index) {
                          return SizedBox(
                            height: 120,
                            width: 150,
                            child: AlbumThumbnail(
                                album: album[index], isFromArtist: true),
                          );
                        },
                      ),
                    ),
                  ],
                );
        }
      },
    );
  }

  // Widget buildArtistProfile(dynamic artist) {
  //   return ListTile(
  //     // trailing: Container(
  //     //   height: 36,
  //     //   width: 36,
  //     //   child: ClipRRect(
  //     //     borderRadius: BorderRadius.circular(50),
  //     //     child: artist.runtimeType == Artist
  //     //         ? CachedPicture(image: artist.photo)
  //     //         : CustomFileImage(img: artist.artistArtPath),
  //     //   ),
  //     // ),
  //     title: Text(
  //       artist.runtimeType == Artist ? artist.fullName ?? '' : artist.name,
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //       textAlign: TextAlign.center,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.w800,
  //         fontFamilyFallback: f,
  //       ),
  //     ),
  //     dense: true,
  //   );
  // }

  Container buildTitle(String title, List<Song> songs) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: ScreenUtil().setSp(18),
              // fontFamilyFallback: f,
              fontFamily: f.single,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Ionicons.play),
            color: cPrimaryColor,
            onPressed: () {
              if (playerBloc.audioPlayer != null) {
                playerBloc.audioPlayer.stop();
              }

              playerBloc.audioInit(0, songs);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) =>
              //         AudioPlayerScreen(songs: songs, i: 0),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}

class BottomPlayerSpacer extends StatelessWidget {
  const BottomPlayerSpacer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = PlayerProvider.of(context);

    return StreamBuilder(
      stream: playerBloc.audioPlayer.playerState,
      builder: (_, AsyncSnapshot<PlayerState> snapshot) {
        return (!snapshot.hasData || snapshot.data == PlayerState.stop)
            ? Container()
            : const SizedBox(height: 76);
      },
    );
  }
}
