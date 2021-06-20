import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import 'widgets/widgets.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({Key key}) : super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  UiBloc uiBloc;
  Size size;

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    uiBloc = UiProvider.of(context);
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: buildListView(),
    );
  }

  ListView buildListView() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Divider(
          color: TRANSPARENT,
          height: 40,
        ),
        buildDiscover(),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.PLAYLIST,
          title: Language.locale(uiBloc.language, 'popular_playlists'),
        ),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.VIDEO,
          title: Language.locale(uiBloc.language, 'music_videos'),
        ),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.SONG,
          title: Language.locale(uiBloc.language, 'timeless_songs'),
        ),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.ARTIST,
          title: Language.locale(uiBloc.language, 'artists'),
        ),
        SizedBox(height: 76),
      ],
    );
  }

  Container buildDiscover() {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
      child: Container(
        child: Text(
          Language.locale(uiBloc.language, 'discover'),
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: ScreenUtil().setSp(28),
            fontFamilyFallback: f,
          ),
        ),
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
