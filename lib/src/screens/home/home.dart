import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
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

  listenForNotification() async {
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

    // List<String> titles = [
    //   'Explore',
    //   (uiBloc.version <= 28 && uiBloc.version != 0)
    //       ? 'Offline'
    //       : 'downloaded_songs',
    //   'Charts',
    // ];

    return SafeArea(
      child: Scaffold(
        bottomSheet: BottomScreenPlayer(),
        bottomNavigationBar: BottomNavBar(currentIndex: 0),
        // appBar: buildAppBar(context),

        body: ExplorerScreen(),
      ),
    );
  }

  // Widget buildAppBar(BuildContext context) {
  //   return AppBar(
  //     leading: IconButton(
  //       onPressed: () {
  //         // Navigator.pushNamed(context, SETTINGS_PAGE_ROUTE);
  //         uiBloc.toggleLanguage();
  //         setState(() {});
  //         Fluttertoast.showToast(
  //           msg: Language.locale(uiBloc.language, 'langauge_changed'),
  //           backgroundColor: PURE_WHITE,
  //           textColor: BACKGROUND,
  //           gravity: ToastGravity.BOTTOM,
  //           toastLength: Toast.LENGTH_SHORT,
  //         );
  //       },
  //       icon: Icon(Icons.language),
  //     ),
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           Navigator.pushNamed(context, SEARCH_HOME_PAGE_ROUTE);
  //         },
  //         icon: const Icon(Icons.search),
  //       )
  //     ],
  //     elevation: 0,
  //     centerTitle: true,
  //   );
  // }

  // void checkDynamicLinks() async {
  //   await kDynamicLinkService.handleDynamicLinks(
  //     onLinkFound: (Map<String, String> id) {
  //       return Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (BuildContext ctx) {
  //           switch (id?.values?.single) {
  //             case 'album':
  //               return AlbumDetailScreen(albumId: id.keys.single); //*
  //             case 'musicvideo':
  //               return PlayerDynamicLinkCatcher(
  //                   isAudio: false, songId: id.keys.single); //*
  //             case 'artist':
  //               return ArtistDetailScreen(artistId: id.keys.single); //*
  //             case 'playlist':
  //               return PlaylistDetailScreen(playlistId: id.keys.single); //*
  //             case 'channel':
  //               return ChannelDetailScreen(channelId: id.keys.single); //*
  //             case 'announcement':
  //               return AnnouncementScreen(announcementId: id.keys.single); //*
  //             case 'song':
  //               return PlayerDynamicLinkCatcher(
  //                   isAudio: true, songId: id.keys.single); //*
  //             default:
  //               return Home();
  //           }
  //         }),
  //       );
  //     },
  //   );
  // }
}
