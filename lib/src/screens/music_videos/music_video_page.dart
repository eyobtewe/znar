import 'package:flutter/cupertino.dart';
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
  @override
  _MusicVideoScreenState createState() => _MusicVideoScreenState();
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
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return Scaffold(
      appBar: buildAppBar(),
      bottomSheet: BottomScreenPlayer(),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      child: FutureBuilder(
        future: bloc.fetchMusicVideos(page, 30),
        initialData: bloc.musicVideo,
        builder:
            (BuildContext context, AsyncSnapshot<List<MusicVideo>> snapshot) {
          if (!snapshot.hasData) {
            return const CustomLoader();
          } else {
            return ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                buildNewsMusicVideos(bloc.musicVideo),
                Divider(color: TRANSPARENT),
                // buildTitle(
                //     Language.locale(uiBloc.language, 'youtube_channels')),
                // buildChannelsList(),
                // Divider(color: TRANSPARENT),
                // buildTitle(Language.locale(uiBloc.language, 'music_videos')),
                buildGridView(bloc.musicVideo),
                // CupertinoActivityIndicator(),
              ],
            );
          }
        },
      ),
    );
  }

  // Widget buildChannelsList() {
  //   return FutureBuilder(
  //     future: bloc.fetchChannels(),
  //     initialData: bloc.channels,
  //     builder: (BuildContext context, AsyncSnapshot<List<Channel>> snapshot) {
  //       if (!snapshot.hasData) {
  //         return Container();
  //       } else {
  //         return Container(
  //           height: 150,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: bloc.channels?.length ?? 0,
  //             itemBuilder: (BuildContext context, int index) {
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
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: musicVideos.length ?? 0,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext ctx, int i) => MusicVideoThumbnail(
          i: i,
          musicVideo: musicVideos[i],
        ),
      ),
    );
  }

  Widget buildNewsMusicVideos(List<MusicVideo> musicVideos) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: size.width * 9 / 16,
      child: Swiper(
        itemCount: musicVideos.length < 7 ? musicVideos.length : 7,
        autoplayDelay: 10000,
        itemWidth: size.width,
        itemHeight: size.width * 9 / 16,
        layout: SwiperLayout.STACK,
        autoplay: true,
        autoplayDisableOnInteraction: false,
        itemBuilder: (BuildContext context, int index) =>
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
              builder: (BuildContext ctx) =>
                  CustomWebPage(url: musicVideos[index].url),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.zero,
          color: GRAY,
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedPicture(
                  image: 'https://img.youtube.com/vi/$videoId/mqdefault.jpg' ??
                      musicVideos[index].thumbnail,
                  isBackground: true,
                ),
              ),
              Center(
                child: Container(
                  child: const Icon(
                    Ionicons.play_circle_outline,
                    size: 60,
                  ),
                ),
              ),
            ],
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
              showSearch(
                  context: context,
                  delegate: SongSearch(CustomAspectRatio.VIDEO));
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
