import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../screens.dart';

class MusicVideoThumbnail extends StatelessWidget {
  const MusicVideoThumbnail({
    this.i,
    this.musicVideo,
    this.isSearchResult,
  });
  final bool isSearchResult;
  final MusicVideo musicVideo;
  final int i;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext ctx) => CustomWebPage(
              url: musicVideo.url,
              title: musicVideo?.channel?.name ?? '',
              musicVideo: musicVideo,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(musicVideo?.thumbnail ?? ' '),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: PRIMARY_COLOR.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(Ionicons.play_back_circle_outline,
                            size: 40),
                      ),
                    ),
                    height: 90,
                  ),
            MusicTitle(title: musicVideo?.title ?? '', lines: 2),
            MusicTitle(
                title: musicVideo?.artistStatic?.stageName ?? '',
                lines: 2,
                color: GRAY),
          ],
        ),
      ),
    );
  }
}

class MusicTitle extends StatelessWidget {
  const MusicTitle({
    this.title,
    this.lines,
    this.color,
    this.alignment,
    this.fontSize = 14,
    this.textAlign = TextAlign.left,
  });

  final String title;
  final int lines;
  final int fontSize;
  final Color color;
  final Alignment alignment;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.centerLeft,
      width: double.maxFinite,
      child: Text(
        '$title',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(fontSize),
          fontFamilyFallback: f,
          color: color,
        ),
      ),
    );
  }
}
