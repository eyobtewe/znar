import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../infrastructure/services/services.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class VideoPlayerScreen extends StatefulWidget {
  final MusicVideo musicVideo;

  const VideoPlayerScreen({Key key, @required this.musicVideo})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController _youtubeController;

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.musicVideo.url),
      flags: const YoutubePlayerFlags(
        // hideControls: true,
        enableCaption: false,
        autoPlay: true,
      ),
    );

    super.initState();
  }

  ApiBloc bloc;
  UiBloc uiBloc;

  Size size;

  @override
  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);

    size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          buildBody(),
          const ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  CustomScrollView buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: size.width * 9 / 16,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: YoutubePlayer(controller: _youtubeController),
          ),
          pinned: true,
          leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                Navigator.pop(context);
              } else {
                _youtubeController.toggleFullScreenMode();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        SliverFillRemaining(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              buildVideoDescription(),
              buildThumbnails(
                  Language.locale(uiBloc.language, 'similar_from_artist')),
              buildThumbnails(Language.locale(uiBloc.language, 'other_videos'),
                  other: true),
            ],
          ),
        ),
      ],
    );
  }

  Container buildVideoDescription() {
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: SizedBox(
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * 0.85,
              child: Wrap(
                children: [
                  Text(
                    widget.musicVideo.title,
                    style: const TextStyle(
                      fontFamilyFallback: f,
                      fontWeight: FontWeight.bold,
                      color: cGray,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    // child: Container(color: cGray, width: 2, height: 2),
                  ),
                  Text(
                    widget.musicVideo.artistStatic.fullName,
                    style: const TextStyle(
                      fontFamilyFallback: f,
                      color: cDarkGray,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            InkWell(
              child: const Icon(Ionicons.share_social_outline,
                  color: cPrimaryColor),
              onTap: () async {
                String link = await kDynamicLinkService
                    .createDynamicLink(widget.musicVideo);

                Share.share(
                    '${widget.musicVideo.title} - ${widget.musicVideo.artistStatic.fullName} \n\n$link');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildThumbnails(String title, {bool other = false}) {
    return FutureBuilder(
      future: other
          ? bloc.fetchMusicVideos(1, 30)
          : bloc.fetchArtistMusicVideos(
              widget.musicVideo.artist ?? '', '' /*widget.musicVideo.sId*/),
      builder: (_, AsyncSnapshot<List<MusicVideo>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          List<MusicVideo> clips = snapshot.data;

          if (other) {
            clips.removeWhere(
                (MusicVideo e) => e.artist == widget.musicVideo.artist);
          } else {
            clips.removeWhere((MusicVideo e) => e.sId == widget.musicVideo.sId);
          }

          return clips.isEmpty
              ? Container()
              : Column(
                  children: [
                    buildTitle(title),
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: clips.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (_, int i) {
                        return MusicVideoThumbnail(i: i, musicVideo: clips[i]);
                      },
                    ),
                  ],
                );
        }
      },
    );
  }

  Container buildTitle(String title) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
                fontFamilyFallback: f),
          ),
        ],
      ),
    );
  }
}
