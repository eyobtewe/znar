import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors.dart';
import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';

class PlaylistThumbnail extends StatelessWidget {
  const PlaylistThumbnail({
    this.i,
    this.playlist,
    this.isSearchResult,
  });

  final Playlist playlist;
  final bool isSearchResult;
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
            builder: (BuildContext ctx) =>
                PlaylistDetailScreen(playlist: playlist),
          ),
        );
      },
      child: Container(
        width: size.width * 9 / 13,
        height: size.width * 9 / 13,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    width: size.width * 9 / 13 - 50,
                    height: size.width * 9 / 13 - 50,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedPicture(
                        image: playlist.featureImage,
                        isBackground: true,
                      ),
                    ),
                  ),
            Container(
              width: size.width * 9 / 13 - 50,
              child: Text(
                playlist.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  fontFamilyFallback: f,
                  color: GRAY,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
