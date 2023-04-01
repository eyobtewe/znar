import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../screens.dart';

class PlaylistTile extends StatelessWidget {
   const PlaylistTile({Key key, this.playlist, this.onTap, this.padded}) : super(key: key);

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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: cPrimaryColor,
            width: 48,
            height: 48,
            child: const Icon(
              Ionicons.musical_notes_outline,
              color: cBackgroundColor,
            ),
          ),
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
        onTap: onTap ?? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaylistDetailScreen(playlist: playlist),
                  ),
                );
              },
      ),
    );
  }
}
