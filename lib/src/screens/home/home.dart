import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt;

import 'package:znar/src/screens/search/search.dart';

import '../../infrastructure/services/services.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../video_player/expandable_video_player.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String messageTitle = "Empty";
  // String notificationAlert = "alert";

  MiniplayerController miniPlayerController;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    miniPlayerController = MiniplayerController();
    super.initState();
    // listenForNotification();

    if (widget.key != const Key('NO-INIT')) {
      checkDynamicLinks();
    }
  }

  // void listenForNotification() async {
  // await _firebaseMessaging.requestPermission();
  // debugPrint(await _firebaseMessaging.getToken());
  // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //   setState(() {
  //     messageTitle = event.notification.title;
  //     // notificationAlert =
  //   });
  // });
  // _firebaseMessaging.configure(
  //   onLaunch: (message) async {
  //     setState(() {
  //       messageTitle = message["notification"]["title"];
  //       notificationAlert = "New Notification Alert";
  //     });
  //   },
  //   onResume: (message) async {
  //     setState(() {
  //       messageTitle = message["data"]["title"];
  //       notificationAlert = "Application opened from Notification";
  //     });
  //   },
  // );
  // }

  @override
  void dispose() {
    // _connectionChangeStream.cancel();
    super.dispose();
  }

  ApiBloc bloc;
  UiBloc uiBloc;
  PlayerBloc playerBloc;
  Size size;

  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    playerBloc = PlayerProvider.of(context);

    size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: cTransparent,
        leading: IconButton(
            onPressed: () {
              uiBloc.toggleLanguage();
              setState(() {});
            },
            icon: const Icon(Ionicons.language)),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SongSearch(MEDIA.SONG));
            },
            icon: const Icon(Ionicons.search_outline),
          ),
        ],
      ),
      body: Stack(
        children: [
          const ExplorerScreen(),
          StreamBuilder(
              stream: playerBloc.videoStr,
              builder: (_, AsyncSnapshot<yt.PlayerState> snapshot) {
                // debugPrint('\t\t\t ${snapshot.data}');
                return (snapshot.hasData &&
                        (snapshot.data != yt.PlayerState.unknown &&
                            snapshot.data != yt.PlayerState.unStarted))
                    ? const ExpandableBottomVideoPlayer()
                    : const ExpandableBottomPlayer();
              }),
        ],
      ),
    );
  }

  void checkDynamicLinks() async {
    await kDynamicLinkService.handleDynamicLinks(
      onLinkFound: (Map<String, String> id) {
        if (id != null) {
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              switch (id?.values?.single) {
                // case 'album':
                //   return AlbumDetailScreen(albumId: id.keys.single);
                // case 'channel':
                //   return ChannelDetailScreen(channelId: id.keys.single);
                // case 'announcement':
                //   return AnnouncementScreen(announcementId: id.keys.single);
                case 'musicvideo':
                  return PlayerDynamicLinkCatcher(
                      isAudio: false, songId: id.keys.single);
                case 'artist':
                  return ArtistDetailScreen(artistId: id.keys.single);
                case 'playlist':
                  return PlaylistDetailScreen(playlistId: id.keys.single);
                case 'song':
                  return PlayerDynamicLinkCatcher(
                      isAudio: true, songId: id.keys.single);
                default:
                  return const Home();
              }
            }),
          );
        }
      },
    );
  }
}
