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
  _MusicVideoTileState createState() => _MusicVideoTileState();
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
            builder: (BuildContext ctx) => true
                ? VideoPlayerScreen(musicVideo: widget.musicVideo)
                : CustomWebPage(url: widget.musicVideo.url),
          ),
        );
      },
      child: Container(
        width: size.width,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 60,
        child: Row(
          children: [
            Container(
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
                  Center(
                    child: Container(
                      child: const Icon(Ionicons.play_circle_outline, size: 30),
                    ),
                  )
                ],
              ),
            ),
            VerticalDivider(color: TRANSPARENT),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    widget.musicVideo.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: GRAY,
                      fontFamilyFallback: f,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.musicVideo.artistStatic?.fullName,
                  style: TextStyle(
                    color: GRAY,
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
