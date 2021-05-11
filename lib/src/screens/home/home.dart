import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../infrastructure/services/services.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initState() {
    super.initState();
    listenForNotification();

    if (widget.key != Key('NO-INIT')) {
      // checkDynamicLinks();
    }
  }

  void listenForNotification() async {
    // await _firebaseMessaging.requestPermission();
    // debugPrint(await _firebaseMessaging.getToken());
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setState(() {
        messageTitle = event.notification.title;
        // notificationAlert =
      });
    });
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
  }

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
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);

    return Scaffold(
      bottomSheet: BottomScreenPlayer(),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: ExplorerScreen(),
    );
  }

  void checkDynamicLinks() async {
    await kDynamicLinkService.handleDynamicLinks(
      onLinkFound: (Map<String, String> id) {
        if (id != null) {
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext ctx) {
              switch (id?.values?.single) {
                // case 'album':
                //   return AlbumDetailScreen(albumId: id.keys.single); //*
                case 'musicvideo':
                  return PlayerDynamicLinkCatcher(
                      isAudio: false, songId: id.keys.single); //*
                case 'artist':
                  return ArtistDetailScreen(artistId: id.keys.single); //*
                case 'playlist':
                  return PlaylistDetailScreen(playlistId: id.keys.single); //*
                // case 'channel':
                //   return ChannelDetailScreen(channelId: id.keys.single); //*
                // case 'announcement':
                //   return AnnouncementScreen(announcementId: id.keys.single); //*
                case 'song':
                  return PlayerDynamicLinkCatcher(
                      isAudio: true, songId: id.keys.single); //*
                default:
                  return Home();
              }
            }),
          );
        }
      },
    );
  }
}
