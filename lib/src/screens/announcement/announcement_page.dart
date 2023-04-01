import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class AnnouncementScreen extends StatefulWidget {
  final Announcement announcement;
  final String announcementId;

  const AnnouncementScreen({Key key, this.announcement, this.announcementId})
      : super(key: key);
  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  void initState() {
    super.initState();
  }

  ApiBloc bloc;
  UiBloc uiBloc;
  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: widget.announcementId != null
                ? FutureBuilder(
                    future:
                        bloc.fetchAnnouncementDetails(widget.announcementId),
                    builder: (_, AsyncSnapshot<Announcement> snapshot) {
                      if (!snapshot.hasData) {
                        return const CustomLoader();
                      } else {
                        return buildBody(snapshot.data);
                      }
                    },
                  )
                : buildBody(widget.announcement),
          ),
          const ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(Announcement announcement) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              Stack(
                children: <Widget>[
                  CachedPicture(
                    image: announcement.contentImage != ''
                        ? announcement.contentImage
                        : announcement.featureImage,
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // buildShare(announcement),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: HtmlBody(data: announcement.description),
              ),
              buildButtons(announcement),
            ],
          ),
        )
      ],
    );
  }

  Widget buildButtons(Announcement announcement) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLearnMore(announcement),
          buildGoTo(announcement),
        ],
      ),
    );
  }

  Widget buildGoTo(Announcement announcement) {
    return announcement.targetType != ''
        ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(cTransparent),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  switch (announcement.targetType) {
                    case 'album':
                      return AlbumDetailScreen(
                          albumId: announcement.targetId); //*
                    case 'video':
                      return PlayerDynamicLinkCatcher(
                          isAudio: false, songId: announcement.targetId); //*
                    case 'artist':
                      return ArtistDetailScreen(
                          artistId: announcement.targetId); //*
                    case 'playlist':
                      return PlaylistDetailScreen(
                          playlistId: announcement.targetId); //*
                    case 'song':
                      return PlayerDynamicLinkCatcher(
                          isAudio: true, songId: announcement.targetId); //*
                    default:
                      return const Home();
                  }
                }),
              );
            },
            child: Text(
              '${Language.locale(uiBloc.language, 'go_to')} ${Language.locale(uiBloc.language, announcement.targetType.toLowerCase())}',
              style:
                  const TextStyle(color: cPrimaryColor, fontFamilyFallback: f),
            ),
          )
        : Container();
  }

  // Widget buildShare(Announcement announcement) {
  //   return IconButton(
  //     onPressed: () async {
  //       final String link =
  //           await bloc.dynamikLinkService.createDynamicLink(announcement);

  //       Share.share('${announcement.title} $link');
  //     },
  //     icon: const Icon(Icons.share),
  //   );
  // }

  Widget buildLearnMore(Announcement announcement) {
    return announcement.moreInfoLink != ''
        ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(cTransparent),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CustomWebPage(
                            url: announcement.moreInfoLink,
                            title: announcement.type,
                          )));
            },
            child: Text(
              Language.locale(uiBloc.language, 'learn_more'),
              style: const TextStyle(color: cBlue, fontFamilyFallback: f),
            ),
          )
        : Container();
  }
}
