import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../screens.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({this.playlist, this.onTap, this.padded});

  final Playlist playlist;
  final Function onTap;
  final double padded;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size);

    return Container(
      // height: 170,
      padding: EdgeInsets.symmetric(horizontal: padded ?? 10),
      child: ListTile(
        leading: Container(
          color: CANVAS_BLACK,
          width: 48,
          height: 48,
          child: const Icon(Icons.playlist_play, color: GRAY),
        ),
        title: Text(
          playlist.name ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(20),
            fontFamilyFallback: f,
          ),
        ),
        onTap: onTap != null
            ? onTap
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext ctx) =>
                        PlaylistDetailScreen(playlist: playlist),
                  ),
                );
              },
      ),
    );
  }
}
