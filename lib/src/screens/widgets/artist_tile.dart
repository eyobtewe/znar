import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';

class ArtistTile extends StatefulWidget {
  final Artist artist;

  const ArtistTile({Key key, this.artist}) : super(key: key);
  @override
  State<ArtistTile> createState() => _ArtistTileState();
}

class _ArtistTileState extends State<ArtistTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ArtistDetailScreen(artist: widget.artist)),
        );
      },
      child: Container(
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedPicture(image: widget.artist.photo ?? ''),
              ),
            ),
            const VerticalDivider(color: cTransparent),
            Text(
              widget.artist.fullName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: cGray,
                fontFamilyFallback: f,
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
