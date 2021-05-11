import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class ChannelDetailScreen extends StatefulWidget {
  final Channel channel;
  final String channelId;

  const ChannelDetailScreen({this.channel, this.channelId});
  @override
  _ChannelDetailScreenState createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  // int page = 1;
  // ScrollController scrollController;
  // List<Song> songsFetched;
  @override
  void initState() {
    super.initState();
    // scrollController = ScrollController();
    // scrollController.addListener(_listener);
  }

  // void _listener() {
  //   if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
  //     setState(() {
  //       page++;
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   scrollController.removeListener(_listener);
  //   scrollController.dispose();
  //   super.dispose();
  // }

  Size size;
  ApiBloc bloc;
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return Scaffold(
      bottomNavigationBar: BottomScreenPlayer(),
      // floatingActionButton: HomeFAB(context: context),
      body: widget.channelId != null
          ? FutureBuilder(
              future: bloc.fetchChannelDetails(widget.channelId),
              builder: (BuildContext context, AsyncSnapshot<Channel> snapshot) {
                if (!snapshot.hasData) {
                  return const CustomLoader();
                } else {
                  return buildBody(snapshot.data);
                }
              },
            )
          : buildBody(widget.channel),
    );
  }

  Widget buildBody(Channel channel) {
    return CustomScrollView(
      primary: true,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        buildSliverAppBar(channel),
        buildFutureBuilder(channel),
      ],
    );
  }

  FutureBuilder<List<MusicVideo>> buildFutureBuilder(Channel channel) {
    return FutureBuilder(
      future: bloc.fetchChannelMusicVideos(channel.sId),
      initialData: bloc.channelMusicVideo[channel.sId],
      builder:
          (BuildContext context, AsyncSnapshot<List<MusicVideo>> snapshot) {
        if (!snapshot.hasData) {
          return SliverFillRemaining(child: const CustomLoader());
        } else {
          // List<MusicVideo> musicVideo = snapshot.data;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext ctx, int index) {
                return MusicVideoThumbnail(
                    i: index,
                    musicVideo: bloc.channelMusicVideo[channel.sId][index]);
              },
              childCount: bloc.channelMusicVideo[channel.sId].length,
            ),
          );
        }
      },
    );
  }

  SliverAppBar buildSliverAppBar(Channel channel) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      centerTitle: true,
      stretch: true,
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.share),
        //   onPressed: () async {
        //     final String link =
        //         await bloc.dynamikLinkService.createDynamicLink(channel);

        //     Share.share(
        //         'Checkout ${channel.name} on IAAM streaming app \n$link');
        //   },
        // )
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        centerTitle: true,
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: size.width,
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
          child: Text(
            channel.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontFamilyFallback: f,
            ),
          ),
        ),
        background: CachedPicture(image: channel.banner, isBackground: true),
      ),
      expandedHeight: size.width * 9 / 16 - 30,
    );
  }
}
