import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import 'widgets/widgets.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({
    Key key,
    @required this.size,
    @required this.uiBloc,
  }) : super(key: key);

  final Size size;
  final UiBloc uiBloc;

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Divider(
            color: TRANSPARENT,
            height: 40,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text(
              'Explore',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: ScreenUtil().setSp(28),
                fontFamilyFallback: f,
              ),
            ),
          ),
          buildSearchBar(),
          Divider(color: TRANSPARENT),
          AnnouncementCards(size: widget.size),
          buildDivider(),
          buildDivider(),
          ThumbnailCards(
            ar: CustomAspectRatio.PLAYLIST,
            title: Language.locale(widget.uiBloc.language, 'playlists'),
          ),
          buildDivider(),
          buildDivider(),
          ThumbnailCards(
            ar: CustomAspectRatio.SONG,
            title: Language.locale(widget.uiBloc.language, 'latest_songs'),
          ),
          // ThumbnailCards(
          //   ar: CustomAspectRatio.ARTIST,
          //   title: Language.locale(widget.uiBloc.language, 'artists'),
          // ),
        ],
      ),
    );
  }

  Container buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(
            Ionicons.search_outline,
            color: GRAY.withOpacity(0.5),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              'Search',
              style: TextStyle(
                color: GRAY.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: GRAY.withOpacity(0.5),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

enum CustomAspectRatio {
  SONG,
  VIDEO,
  ALBUM,
  ARTIST,
  PLAYLIST,
  CHANNEL,
  ANNOUNCEMENT
}

Divider buildDivider() {
  return Divider(
    color: TRANSPARENT,
    indent: 10,
    endIndent: 10,
  );
}
