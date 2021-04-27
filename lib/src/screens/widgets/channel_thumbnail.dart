import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/models/models.dart';
import '../../helpers/network_image.dart';
import '../screens.dart';
import 'widgets.dart';

class ChannelThumbnail extends StatelessWidget {
  const ChannelThumbnail({
    this.r,
    this.i,
    this.channel,
  });

  final Channel channel;
  final int r;
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
                ChannelDetailScreen(channel: channel),
          ),
        );
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 100,
              child: CachedPicture(image: channel.photo),
            ),
            MusicTitle(title: channel.name ?? '', lines: 2),
          ],
        ),
      ),
    );
  }
}
