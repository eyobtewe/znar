import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../presentation/bloc.dart';
import '../search/search.dart';
import 'widgets/widgets.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({Key key}) : super(key: key);

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  void initState() {
    super.initState();
  }

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
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Divider(
          color: TRANSPARENT,
          height: 40,
        ),
        buildDiscover(),
        // buildSearchBar(),
        // Divider(color: TRANSPARENT),
        // AnnouncementCards(size: size),
        buildDivider(),
        // buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.PLAYLIST,
          title: Language.locale(uiBloc.language, 'popular_playlists'),
        ),
        // buildDivider(),
        // buildDivider(),
        // ThumbnailCards(
        //   ar: CustomAspectRatio.SONG,
        //   title: Language.locale(uiBloc.language, 'popular_songs'),
        // ),
        buildDivider(),
        buildDivider(),
        ThumbnailCards(
          ar: CustomAspectRatio.SONG,
          title: Language.locale(uiBloc.language, 'timeless_songs'),
        ),
        // ThumbnailCards(
        //   ar: CustomAspectRatio.ARTIST,
        //   title: Language.locale(widget.uiBloc.language, 'artists'),
        // ),
      ],
    );
  }

  Container buildDiscover() {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Discover',
              style: TextStyle(
                color: GRAY,
                fontWeight: FontWeight.w900,
                fontSize: ScreenUtil().setSp(28),
                fontFamilyFallback: f,
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(Ionicons.search),
          //   onPressed: () {
          //     showSearch(
          //         context: context,
          //         delegate: SongSearch(CustomAspectRatio.SONG));
          //   },
          // ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return InkWell(
      onTap: () {
        showSearch(
            context: context, delegate: SongSearch(CustomAspectRatio.SONG));
      },
      child: Container(
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
