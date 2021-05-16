import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class VideoPlayerScreen extends StatefulWidget {
  final MusicVideo musicVideo;

  const VideoPlayerScreen({@required this.musicVideo});

  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController _youtubeController;

  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.musicVideo.url),
      flags: YoutubePlayerFlags(
        enableCaption: false,
        autoPlay: true,
      ),
    );

    super.initState();
  }

  ApiBloc bloc;
  UiBloc uiBloc;

  Size size;

  Widget build(BuildContext context) {
    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);

    size = MediaQuery.of(context).size;
    ScreenUtil.init(context, allowFontScaling: true, designSize: size);

    return Scaffold(
      body: Stack(
        children: [
          buildBody(context),
          ExpandableBottomPlayer(),
        ],
      ),
    );
  }

  CustomScrollView buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: size.width * 9 / 16,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: YoutubePlayer(controller: _youtubeController),
          ),
          pinned: true,
        ),
        SliverFillRemaining(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              buildVideoDescription(context),
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

  Container buildVideoDescription(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        width: size.width,
        child: Row(
          children: [
            Text(
              widget.musicVideo.title,
              style: TextStyle(
                fontFamilyFallback: f,
                fontWeight: FontWeight.bold,
                color: GRAY,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(color: GRAY, width: 2, height: 2),
            ),
            Text(
              widget.musicVideo.artistStatic.fullName,
              style: TextStyle(fontFamilyFallback: f, color: DARK_GRAY),
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
      builder:
          (BuildContext context, AsyncSnapshot<List<MusicVideo>> snapshot) {
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (BuildContext context, int i) {
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
            '$title',
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
