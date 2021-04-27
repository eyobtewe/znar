import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class ArtistDetailScreen extends StatefulWidget {
  final dynamic artist;
  final String artistId;

  const ArtistDetailScreen({this.artist, this.artistId});

  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  void initState() {
    super.initState();
  }

  Size size;
  ApiBloc bloc;
  LocalSongsBloc localSongsBloc;
  UiBloc uiBloc;

  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    localSongsBloc = LocalSongsProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Scaffold(
      bottomNavigationBar: BottomScreenPlayer(),
      floatingActionButton: HomeFAB(context: context),
      body: widget.artistId != null
          ? FutureBuilder(
              future: bloc.fetchArtistDetails(widget.artistId),
              builder: (BuildContext context, AsyncSnapshot<Artist> snapshot) {
                if (!snapshot.hasData) {
                  return const CustomLoader();
                } else {
                  return buildBody(snapshot.data);
                }
              },
            )
          : buildBody(widget.artist),
    );
  }

  Widget buildBody(dynamic artist) {
    return SafeArea(
      child: CustomScrollView(
        primary: true,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            elevation: 0,
            stretch: true,
            actions: [
              // artist.runtimeType == Artist
              //     ? IconButton(
              //         icon: Icon(Icons.share),
              //         onPressed: () async {
              //           final String link = await bloc.dynamikLinkService
              //               .createDynamicLink(artist);

              //           Share.share(
              //               'Checkout ${artist.stageName}\'s songs \n\n$link');
              //         },
              //       )
              //     : Container(),
            ],
            flexibleSpace: buildFlexibleSpaceBar(artist),
            expandedHeight: size.width * 9 / 16 - 30,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                buildAlbums(artist),
                buildSongs(artist),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSongs(dynamic artist) {
    return FutureBuilder(
      future: artist.runtimeType == Artist
          ? bloc.fetchArtistSongs(artist.sId)
          : localSongsBloc.getSongsFromArtist(artist.id),
      initialData: artist.runtimeType == Artist
          ? bloc.artistSongs[artist.sId]
          : localSongsBloc.artistSongs[artist.id],
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const CustomLoader();
        } else {
          dynamic songs = snapshot.data;
          return ListView.builder(
            itemCount: songs.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  index == 0
                      ? buildTitle(Language.locale(uiBloc.language, 'songs'))
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
      future: artist.runtimeType == Artist
          ? bloc.fetchArtistAlbums(artist.sId)
          : localSongsBloc.getAlbumsFromArtist(artist.name),
      initialData: artist.runtimeType == Artist
          ? bloc.artistAlbums[artist.sId]
          : localSongsBloc.artistAlbums[artist.name],
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          dynamic album = snapshot.data;
          return album.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(Language.locale(uiBloc.language, 'albums')),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: album.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
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

  FlexibleSpaceBar buildFlexibleSpaceBar(dynamic artist) {
    return FlexibleSpaceBar(
      stretchModes: <StretchMode>[
        StretchMode.zoomBackground,
        StretchMode.fadeTitle,
      ],
      centerTitle: true,
      title: Container(
        width: size.width,
        child: buildArtistProfile(artist),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
            ],
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
          ),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      background: buildAppBarBackground(artist),
    );
  }

  Widget buildAppBarBackground(dynamic artist) {
    return artist.runtimeType == Artist
        ? CachedPicture(image: artist.coverImage, isBackground: true)
        : CustomFileImage(img: artist.artistArtPath);
  }

  Widget buildArtistProfile(dynamic artist) {
    return ListTile(
      // trailing: Container(
      //   height: 36,
      //   width: 36,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(50),
      //     child: artist.runtimeType == Artist
      //         ? CachedPicture(image: artist.photo)
      //         : CustomFileImage(img: artist.artistArtPath),
      //   ),
      // ),
      title: Text(
        artist.runtimeType == Artist ? artist.stageName ?? '' : artist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: f,
        ),
      ),
      dense: true,
    );
  }

  Container buildTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 10, left: 10),
      child: Text(
        '$title',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: ScreenUtil().setSp(18),
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}
