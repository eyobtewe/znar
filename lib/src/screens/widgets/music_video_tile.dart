import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';

class MusicVideoTile extends StatefulWidget {
  final MusicVideo musicVideo;

  const MusicVideoTile({Key key, this.musicVideo}) : super(key: key);
  @override
  State<MusicVideoTile> createState() => _MusicVideoTileState();
}

class _MusicVideoTileState extends State<MusicVideoTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    final String videoId = YoutubePlayer.convertUrlToId(widget.musicVideo.url);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  // true
                  // ?
                  VideoPlayerScreen(musicVideo: widget.musicVideo)
              // : CustomWebPage(url: widget.musicVideo.url),
              ),
        );
      },
      child: Container(
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 60 / 9 * 16,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedPicture(
                        image:
                            'https://img.youtube.com/vi/$videoId/mqdefault.jpg' ??
                                widget.musicVideo.thumbnail ??
                                ''),
                  ),
                  const Center(
                    child: Icon(Ionicons.play_circle_outline, size: 30),
                  )
                ],
              ),
            ),
            const VerticalDivider(color: cTransparent),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.musicVideo.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cGray,
                    fontFamilyFallback: f,
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.musicVideo.artistStatic?.fullName,
                  style: TextStyle(
                    color: cGray,
                    fontFamilyFallback: f,
                    fontSize: ScreenUtil().setSp(10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
