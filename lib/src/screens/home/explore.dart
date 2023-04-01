// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({Key key}) : super(key: key);

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  UiBloc uiBloc;
  Size size;
  ApiBloc bloc;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    uiBloc = UiProvider.of(context);
    bloc = ApiProvider.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          // Row(
          //   children: [
          //     IconButton(onPressed: () {}, icon: Icon(Ionicons.language)),
          //     Spacer(),
          //     IconButton(
          //       onPressed: () {
          //         showSearch(
          //             context: context, delegate: SongSearch(MEDIA.SONG));
          //       },
          //       icon: Icon(Ionicons.search_outline),
          //     ),
          //   ],
          // ),
          buildDivider(),
          // buildDiscover(),
          buildPlaylists(),
          // buildDivider(),
          const BottomPlayerSpacer(),
          // SizedBox(height: 76),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context, Playlist playlist) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            playlist.name,
            style: TextStyle(
              color: cGray,
              fontSize: ScreenUtil().setSp(18),
              fontFamilyFallback: f,
              fontWeight: FontWeight.bold,
            ),
          ),
          // content.length > 6 ?
          buildMoreBtn(context, playlist),
          //  : Container(),
        ],
      ),
    );
  }

  ElevatedButton buildMoreBtn(BuildContext context, Playlist playlist) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PlaylistDetailScreen(playlist: playlist)));
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(cBackgroundColor),
        // visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(
                color: cCanvasBlack,
                width: 2,
              )),
        ),
      ),
      child: Text(
        Language.locale(uiBloc.language, 'more'),
        style: const TextStyle(
          color: cPrimaryColor,
          fontFamilyFallback: f,
        ),
      ),
    );
  }

  Widget buildPlaylists() {
    return FutureBuilder(
      future: bloc.fetchOnlinePlayList(1, 20),
      initialData: bloc.onlinePlaylists,
      builder: (_, AsyncSnapshot<List<Playlist>> snapshot) {
        if (!snapshot.hasData) {
          return const CustomLoader();
        } else {
          // return buildOnlinePlaylist(bloc.onlinePlaylists);
          return ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              primary: false,
              separatorBuilder: (_, int k) {
                if (k == 0) {
                  return Column(
                    children: [
                      buildDivider(),
                      ThumbnailCards(
                        ar: MEDIA.VIDEO,
                        title: Language.locale(uiBloc.language, 'music_videos'),
                      ),
                      buildDivider(),
                    ],
                  );
                } else if (k == 1) {
                  return Column(
                    children: [
                      buildDivider(),
                      ThumbnailCards(
                        ar: MEDIA.ARTIST,
                        title: Language.locale(uiBloc.language, 'artists'),
                      ),
                      buildDivider(),
                      buildDivider(),
                      buildDivider(),
                      buildDivider(),
                    ],
                  );
                } else {
                  return buildDivider();
                }
              },
              itemBuilder: (_, int k) {
                return buildSongsGrid(k, snapshot.data[k]);
              });
        }
      },
    );
  }

  Widget buildSongsGrid(int k, Playlist playlist) {
    return FutureBuilder(
        future: bloc.fetchPlaylistSong(bloc.onlinePlaylists[k].sId),
        initialData: bloc.playlistSongs[bloc.onlinePlaylists[k].sId],
        builder: (_, AsyncSnapshot<List<Song>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Column(
              children: [
                buildTitle(context, playlist),
                buildDivider(),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, int index) {
                    return SongThumbnail(i: index, song: snapshot.data);
                  },
                  itemCount:
                      snapshot.data.length > 6 ? 6 : snapshot.data.length,
                  shrinkWrap: true,
                  primary: false,
                ),
              ],
            );
          }
        });
  }

  Container buildDiscover() {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
      child: Text(
        Language.locale(uiBloc.language, 'discover'),
        style: TextStyle(
          color: cGray,
          fontWeight: FontWeight.w900,
          fontSize: ScreenUtil().setSp(28),
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}

enum MEDIA { SONG, VIDEO, ALBUM, ARTIST, PLAYLIST, CHANNEL, ANNOUNCEMENT }

Divider buildDivider() {
  return const Divider(
    color: cTransparent,
    indent: 10,
    endIndent: 10,
  );
}
