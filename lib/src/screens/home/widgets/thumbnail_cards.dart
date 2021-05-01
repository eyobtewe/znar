import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../presentation/bloc.dart';
import '../../screens.dart';
import '../../widgets/widgets.dart';
import 'widgets.dart';

class ThumbnailCards extends StatelessWidget {
  const ThumbnailCards({Key key, @required this.ar, this.title})
      : super(key: key);

  final CustomAspectRatio ar;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ApiBloc bloc = ApiProvider.of(context);
    final UiBloc uiBloc = UiProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return FutureBuilder(
      future: bloc.buildFutures(ar),
      initialData: bloc.buildInitialData(ar),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return ar == CustomAspectRatio.SONG
              ? Container(
                  height: _cardHeight(ar),
                  child: const CustomLoader(),
                )
              : Container();
        } else {
          return bloc.buildInitialData(ar).isEmpty
              ? Container()
              : Column(
                  children: [
                    buildTitle(uiBloc, context),
                    buildDivider(),
                    Container(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ar == CustomAspectRatio.SONG ? 3 : 3,
                          childAspectRatio: _childAspectRatio(ar),
                        ),
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                            height: 150,
                            width: 150,
                            child: HomeCards(
                              ar: ar,
                              data: bloc.buildInitialData(ar),
                              i: index,
                            ),
                          );
                        },
                        itemCount: bloc.buildInitialData(ar).length,
                        // itemCount: ar == CustomAspectRatio.SONG ? 6 : 4,
                        shrinkWrap: true,
                        primary: false,
                      ),
                    ),
                  ],
                );
        }
      },
    );
  }

  double _childAspectRatio(CustomAspectRatio aspectRatio) {
    switch (aspectRatio) {
      case CustomAspectRatio.PLAYLIST:
      // return 0.8;
      case CustomAspectRatio.SONG:
        return 0.7;
      case CustomAspectRatio.ARTIST:
        return 0.9;
      default:
        return 1;
    }
  }

  // Container buildContainer(ApiBloc bloc, int index) {
  //   return Container(
  //     height: _cardHeight(ar),
  //     child: ListView.builder(
  //       physics: const BouncingScrollPhysics(),
  //       key: PageStorageKey('$ar'),
  //       scrollDirection: Axis.horizontal,
  //       // shrinkWrap: true,
  //       itemBuilder: (BuildContext context, int i) {
  //         return HomeCards(
  //           ar: ar,
  //           data: bloc.buildInitialData(ar),
  //           i: i * index,
  //         );
  //       },
  //       itemCount: (bloc.buildInitialData(ar).length ~/ 2),
  //     ),
  //   );
  // }

  Widget buildMoreBtn(
      CustomAspectRatio ar, BuildContext context, UiBloc uiBloc) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, _routePage(ar));
      },
      child: Text(
        Language.locale(uiBloc.language, 'view_all'),
        style: const TextStyle(color: PRIMARY_COLOR),
      ),
    );
  }

  Widget buildTitle(UiBloc uiBloc, BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: ScreenUtil().setSp(18),
                fontFamilyFallback: f,
              ),
            ),
          ),
          title != Language.locale(uiBloc.language, 'youtube_channels')
              ? buildMoreBtn(ar, context, uiBloc)
              : Container(),
        ],
      ),
    );
  }

  String _routePage(CustomAspectRatio ar) {
    switch (ar) {
      case CustomAspectRatio.SONG:
        return SONGS_PAGE_ROUTE;
      case CustomAspectRatio.ALBUM:
        return ALBUMS_PAGE_ROUTE;
      case CustomAspectRatio.VIDEO:
        return MUSIC_VIDEOS_PAGE_ROUTE;
      case CustomAspectRatio.ARTIST:
        return ARTISTS_PAGE_ROUTE;
      case CustomAspectRatio.PLAYLIST:
        return PLAYLISTS_PAGE_ROUTE;
      default:
        return ALBUMS_PAGE_ROUTE;
    }
  }

  double _cardHeight(CustomAspectRatio ar) {
    switch (ar) {
      case CustomAspectRatio.ALBUM:
      case CustomAspectRatio.SONG:
      case CustomAspectRatio.CHANNEL:
        return 190;
      case CustomAspectRatio.PLAYLIST:
      case CustomAspectRatio.VIDEO:
        return 170;
      case CustomAspectRatio.ARTIST:
        return 140;
      default:
        return 190;
    }
  }
}
