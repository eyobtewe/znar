import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            builder: (BuildContext ctx) => ArtistDetailScreen(artist: artist),
          ),
        );
      },
      child: Container(
        // color: BACKGROUND,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            isSearchResult != null
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 5, top: 10),
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: artist.runtimeType == Artist
                            ? CachedPicture(image: artist.photo ?? '')
                            : CustomFileImage(img: artist.artistArtPath)),
                  ),
            MusicTitle(
              title: artist.runtimeType == Artist
                  ? artist.stageName ?? ''
                  : artist.name,
              lines: 2,
              alignment: Alignment.center,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
