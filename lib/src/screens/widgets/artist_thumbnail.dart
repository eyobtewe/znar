import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';
import 'widgets.dart';

class ArtistThumbnail extends StatelessWidget {
  const ArtistThumbnail({this.artist, this.isSearchResult});
  final bool isSearchResult;
  final dynamic artist;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtistDetailScreen(artist: artist),
          ),
        );
      },
      child: Container(
        // height: 150,
        // width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 10),
                    // height: size.width * 0.25,
                    // width: size.width * 0.25,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: artist.runtimeType == Artist
                            ? CachedPicture(image: artist.photo ?? '')
                            : CustomFileImage(img: artist.artistArtPath)),
                  ),
            Divider(
              height: 5,
            ),
            MusicTitle(
              title: artist.runtimeType == Artist
                  ? artist.fullName ?? ''
                  : artist.name,
              lines: 2,
              color: GRAY,
              alignment: Alignment.center,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
