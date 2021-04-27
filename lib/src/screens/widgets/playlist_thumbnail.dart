import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';
import 'widgets.dart';

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
    final w = size.width / 2 - 40;
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: w,
                    width: w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedPicture(
                        image: playlist.featureImage,
                        boxFit: BoxFit.cover,
                        isBackground: true,
                      ),
                    ),
                  ),
            MusicTitle(title: playlist.name ?? '', lines: 2),
            Divider(height: 5, color: TRANSPARENT),
            MusicTitle(title: playlist.count + ' songs' ?? '', lines: 1),
          ],
        ),
      ),
    );
  }
}
