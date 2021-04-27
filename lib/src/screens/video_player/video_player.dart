// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:share/share.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../../app.dart';
// import '../../core/core.dart';
// import '../../domain/models/models.dart';
// import '../../presentation/bloc.dart';
// import '../screens.dart';
// import '../widgets/widgets.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final MusicVideo musicVideo;

//   const VideoPlayerScreen({@required this.musicVideo});

//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   YoutubePlayerController _youtubeController;
//   // final _nativeAdController = NativeAdmobController();
//   // double _height = 0;

//   // StreamSubscription _subscription;

//   void dispose() {
//     // _subscription.cancel();
//     // _nativeAdController.dispose();
//     // _youtubeController.dispose();
//     super.dispose();
//   }

//   // void _onStateChanged(AdLoadState state) {
//   //   if (state == AdLoadState.loadCompleted) {
//   //     setState(() {
//   //       _height = 330;
//   //     });
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
//     // _nativeAdController.setTestDeviceIds(['0285E4EA075685841E958F067765106D']);

//     kAnalytics.setCurrentScreen(screenName: 'video-player/${widget.musicVideo?.title}',screenClassOverride: 'video-player/${widget.musicVideo?.title}',);

//     _youtubeController = YoutubePlayerController(
//       initialVideoId: YoutubePlayer.convertUrlToId(widget.musicVideo.url),
//       flags: YoutubePlayerFlags(
//         enableCaption: false,
//       ),
//     );

//     super.initState();
//   }

//   ApiBloc bloc;
//   UiBloc uiBloc;
//   PlayerBloc playerBloc;
//   Size size;

//   Widget build(BuildContext context) {
//     bloc = ApiProvider.of(context);
//     uiBloc = UiProvider.of(context);
//     playerBloc = PlayerProvider.of(context);

//     size = MediaQuery.of(context).size;
//     ScreenUtil.init(context, allowFontScaling: true, designSize: size);

//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: BottomScreenPlayer(),
//         body: buildBody(context),
//       ),
//     );
//   }

//   CustomScrollView buildBody(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverAppBar(
//           expandedHeight: size.width * 9 / 16,
//           flexibleSpace: FlexibleSpaceBar(
//             collapseMode: CollapseMode.none,
//             background: YoutubePlayer(
//               // controller: playerBloc.youtubeController,
//               controller: _youtubeController,
//             ),
//           ),
//           pinned: true,
//         ),
//         SliverFillRemaining(
//           child: ListView(
//             shrinkWrap: true,
//             children: <Widget>[
//               buildVideoDescription(context),
//               buildThumbnails(Language.locale(uiBloc.language, 'similar_from_artist')),
//               // BuildAd(height: _height, nativeAdController: _nativeAdController),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Container buildVideoDescription(BuildContext context) {
//     return Container(
//       width: size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 width: size.width * 0.8,
//                 child: Text(
//                   widget.musicVideo.title ?? '',
//                   style: const TextStyle(fontFamilyFallback: f),
//                 ),
//               ),
//               Divider(color: TRANSPARENT, height: 1),
//               widget.musicVideo?.channel != null
//                   ? InkWell(
//                       onTap: () {
//                         // playerBloc.youtubeController.dispose();
//                         _youtubeController.dispose();
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext ctx) => ChannelDetailScreen(channel: widget.musicVideo.channel)),
//                         );
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         child: Text(
//                           widget.musicVideo?.channel?.name ?? '',
//                           style: const TextStyle(color: PRIMARY_COLOR, fontFamilyFallback: f),
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () async {
//               final String link = await bloc.dynamikLinkService.createDynamicLink(widget.musicVideo);

//               Share.share(
//                   'Watch ${widget.musicVideo.artistStatic?.stageName ?? ''} - ${widget.musicVideo.title ?? ''} on IAAM streaming app \n$link');
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildThumbnails(String title) {
//     return FutureBuilder(
//       future: bloc.fetchArtistMusicVideos(widget.musicVideo.artist ?? '', widget.musicVideo.sId),
//       builder: (BuildContext context, AsyncSnapshot<List<MusicVideo>> snapshot) {
//         if (!snapshot.hasData) {
//           return Container();
//         } else {
//           List<MusicVideo> clips = snapshot.data;
//           return Column(
//             children: [
//               buildTitle(title),
//               Container(
//                 width: double.maxFinite,
//                 height: 175,
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   separatorBuilder: (BuildContext context, int i) => clips[i].sId == widget.musicVideo.sId
//                       ? Container()
//                       : VerticalDivider(
//                           color: TRANSPARENT,
//                         ),
//                   itemBuilder: (BuildContext context, int i) {
//                     return clips[i].sId == widget.musicVideo.sId
//                         ? Container()
//                         : Container(
//                             child: MusicVideoThumbnail(i: i, musicVideo: clips[i]),
//                             width: 180,
//                           );
//                   },
//                   itemCount: clips.length,
//                 ),
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   Container buildTitle(String title) {
//     return Container(
//       width: double.maxFinite,
//       padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             '$title',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontFamilyFallback: f),
//           ),
//         ],
//       ),
//     );
//   }
// }
