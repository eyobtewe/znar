import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../presentation/bloc.dart';

class MusicVideoThumbnail extends StatelessWidget {
  const MusicVideoThumbnail({
    Key key,
    this.i,
    this.musicVideo,
    this.isSearchResult,
  }) : super(key: key);
  final bool isSearchResult;
  final MusicVideo musicVideo;
  final int i;

  @override
  Widget build(BuildContext context) {
    PlayerBloc playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    final String videoId = YoutubePlayer.convertUrlToId(musicVideo.url);

    return InkWell(
      onTap: () {
        playerBloc.videoInit(musicVideo);
        playerBloc.youtubeController.play();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (_) =>
        //           // true
        //           //     ?
        //           VideoPlayerScreen(musicVideo: musicVideo)
        //       // : CustomWebPage(url: musicVideo.url),
        //       ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            isSearchResult != null ? Container() : buildContainer(videoId),
            MusicTitle(
              title: musicVideo.title ?? '',
              lines: 1,
              fontSize: 14,
            ),
            const Divider(color: cTransparent, height: 5),
            MusicTitle(
                title: musicVideo.artistStatic.fullName,
                // !=
                //         song[i].artistStatic.firstName
                //     ? song[i].artistStatic.stageName
                //     : song[i].artistStatic.fullName,
                lines: 1,
                fontSize: 12,
                color: cGray),
          ],
        ),
      ),
    );
  }

  Container buildContainer(String videoId) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(
              'https://img.youtube.com/vi/$videoId/mqdefault.jpg' ??
                  musicVideo?.thumbnail ??
                  ' '),
          fit: BoxFit.cover,
        ),
      ),
      height: 90,
      child: const Center(
        child: Icon(Ionicons.play_circle_outline, size: 40),
      ),
    );
  }
}

class MusicTitle extends StatelessWidget {
  const MusicTitle({
    Key key,
    this.title,
    this.lines,
    this.color,
    this.alignment,
    this.fontSize = 12,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  final String title;
  final int lines;
  final int fontSize;
  final Color color;
  final Alignment alignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      width: double.maxFinite,
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize.toDouble(),
          // fontSize: ScreenUtil().setSp(fontSize),
          fontFamilyFallback: f,
          fontWeight: fontSize == 12 ? FontWeight.bold : FontWeight.normal,
          color: color ?? (fontSize == 12 ? cGray : cDarkGray),
        ),
      ),
    );
  }
}
