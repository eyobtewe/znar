import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ionicons/ionicons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../search/search.dart';
import '../widgets/widgets.dart';

class MusicVideoScreen extends StatefulWidget {
  const MusicVideoScreen({Key key}) : super(key: key);

  @override
  State<MusicVideoScreen> createState() => _MusicVideoScreenState();
}

class _MusicVideoScreenState extends State<MusicVideoScreen> {
  int page = 1;
  ScrollController scrollController;
  // List<Song> songsFetched;
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_listener);
  }

  void _listener() {
    if (scrollController.position.atEdge &&
        scrollController.position.pixels != 0) {
      setState(() {
        page++;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();
    super.dispose();
  }

  Size size;
  ApiBloc bloc;
  UiBloc uiBloc;
  PlayerBloc playerBloc;
  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return Scaffold(
      appBar: buildAppBar(),
      // bottomNavigationBar: BottomNavBar(currentIndex: 1),
      body: Stack(
        children: [
          buildBody(),
          const ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: bloc.fetchMusicVideos(page, 30),
      initialData: bloc.musicVideo,
      builder: (_, AsyncSnapshot<List<MusicVideo>> snapshot) {
        if (!snapshot.hasData) {
          return const CustomLoader();
        } else {
          return ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              buildNewsMusicVideos(snapshot.data),
              const Divider(color: cTransparent),
              // buildTitle(
              //     Language.locale(uiBloc.language, 'youtube_channels')),
              // buildChannelsList(),
              // Divider(color: cTransparent),
              // buildTitle(Language.locale(uiBloc.language, 'music_videos')),
              buildGridView(bloc.musicVideo),
              // CupertinoActivityIndicator(),
            ],
          );
        }
      },
    );
  }

  // Widget buildChannelsList() {
  //   return FutureBuilder(
  //     future: bloc.fetchChannels(),
  //     initialData: bloc.channels,
  //     builder: (_, AsyncSnapshot<List<Channel>> snapshot) {
  //       if (!snapshot.hasData) {
  //         return Container();
  //       } else {
  //         return Container(
  //           height: 150,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: bloc.channels?.length ?? 0,
  //             itemBuilder: (_, int index) {
  //               return ChannelThumbnail(
  //                   i: index, channel: bloc.channels[index]);
  //             },
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // Container buildTitle(String title) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //     child: Text(
  //       '$title',
  //       softWrap: true,
  //       style: TextStyle(
  //         fontWeight: FontWeight.w800,
  //         fontFamilyFallback: f,
  //         fontSize: ScreenUtil().setSp(18),
  //       ),
  //     ),
  //   );
  // }

  Widget buildGridView(List<MusicVideo> musicVideos) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
      ),
      itemCount: musicVideos.length ?? 0,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, int i) => MusicVideoThumbnail(
        i: i,
        musicVideo: musicVideos[i],
      ),
    );
  }

  Widget buildNewsMusicVideos(List<MusicVideo> musicVideos) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: size.width * 9 / 18,
      child: Swiper(
        itemCount: musicVideos.length < 7 ? musicVideos.length : 7,
        autoplayDelay: 10000,
        itemWidth: size.width,
        itemHeight: size.width * 9 / 18,
        layout: SwiperLayout.STACK,
        autoplay: true,
        loop: false,
        autoplayDisableOnInteraction: false,
        itemBuilder: (_, int index) =>
            buildClipRRect(context, musicVideos, index),
      ),
    );
  }

  ClipRRect buildClipRRect(
      BuildContext context, List<MusicVideo> musicVideos, int index) {
    final String videoId = YoutubePlayer.convertUrlToId(musicVideos[index].url);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(musicVideo: musicVideos[index]),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.zero,
          color: cCanvasBlack,
          child: CachedPicture(
            image: 'https://img.youtube.com/vi/$videoId/mqdefault.jpg' ??
                musicVideos[index].thumbnail,
            isBackground: true,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: false,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Ionicons.search),
            onPressed: () {
              showSearch(context: context, delegate: SongSearch(MEDIA.VIDEO));
            }),
      ],
      title: Text(
        Language.locale(uiBloc.language, 'videos'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontFamilyFallback: f,
        ),
      ),
    );
  }
}
