import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';
import 'widgets.dart';

class AlbumThumbnail extends StatelessWidget {
  const AlbumThumbnail(
      {this.album, this.isSearchResult, this.isFromArtist = false});

  final bool isSearchResult;
  final dynamic album;
  final bool isFromArtist;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AlbumDetailScreen(album: album),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    width: 120,
                    height: 120,
                    constraints: BoxConstraints(minWidth: 120, minHeight: 120),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: album.runtimeType == Album
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedPicture(
                              image: album.albumArt,
                              isBackground: true,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CustomFileImage(
                              img: album.albumArt,
                              isBackground: true,
                            ),
                          ),
                  ),
            MusicTitle(
                title:
                    album.runtimeType == Album ? album.name ?? '' : album.title,
                lines: 1),
            isFromArtist
                ? Container()
                : MusicTitle(
                    title: album.runtimeType == Album
                        ? album.artistStatic?.stageName ?? ''
                        : album.artist,
                    lines: 1,
                    color: GRAY,
                  ),
          ],
        ),
      ),
    );
  }
}
