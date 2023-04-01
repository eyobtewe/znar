import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../presentation/bloc.dart';
import '../../screens.dart';
import '../../widgets/widgets.dart';

class ThumbnailCards extends StatelessWidget {
  const ThumbnailCards({Key key, @required this.ar, this.title})
      : super(key: key);

  final MEDIA ar;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ApiBloc bloc = ApiProvider.of(context);
    final UiBloc uiBloc = UiProvider.of(context);
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: bloc.buildFutures(ar),
      initialData: bloc.buildInitialData(ar),
      builder: (_, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return ar == MEDIA.SONG
              ? SizedBox(
                  height: _cardHeight(ar),
                  child: const CustomLoader(),
                )
              : Container();
        } else {
          return bloc.buildInitialData(ar).isEmpty
              ? Container()
              : Column(
                  children: [
                    buildTitle(uiBloc, context, bloc.buildInitialData(ar)),
                    buildDivider(),
                    Container(
                      child: (MEDIA.PLAYLIST == ar || ar == MEDIA.ARTIST)
                          ? buildContainer(bloc, size)
                          : buildGridView(bloc),
                    ),
                  ],
                );
        }
      },
    );
  }

  GridView buildGridView(ApiBloc bloc) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ar == MEDIA.SONG ? 3 : 2,
        childAspectRatio: _childAspectRatio(ar),
      ),
      itemBuilder: (_, int index) {
        return HomeCards(
          ar: ar,
          data: bloc.buildInitialData(ar),
          i: index,
        );
      },
      itemCount: bloc.buildInitialData(ar).length > (ar == MEDIA.SONG ? 6 : 4)
          ? ar == MEDIA.SONG
              ? 6
              : 4
          : bloc.buildInitialData(ar).length,
      shrinkWrap: true,
      primary: false,
    );
  }

  double _childAspectRatio(MEDIA aspectRatio) {
    switch (aspectRatio) {
      case MEDIA.VIDEO:
        return 1.2;
      case MEDIA.SONG:
        return 0.7;
      case MEDIA.ARTIST:
        return 0.9;
      default:
        return 1;
    }
  }

  Widget buildContainer(ApiBloc bloc, Size size) {
    return SizedBox(
      height: ar == MEDIA.ARTIST ? 150 : size.width * 9 / 13,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        key: PageStorageKey('$ar'),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int i) {
          return HomeCards(
            ar: ar,
            data: bloc.buildInitialData(ar),
            i: i,
          );
        },
        itemCount: (bloc.buildInitialData(ar).length),
      ),
    );
  }

  Widget buildMoreBtn(MEDIA ar, BuildContext context, UiBloc uiBloc) {
    return ElevatedButton(
      onPressed: () {
        if (MEDIA.SONG == ar || MEDIA.VIDEO == ar) {
          Navigator.pushNamed(context, _routePage(ar));
        } else {
          Navigator.pushReplacementNamed(context, _routePage(ar));
        }
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(cBackgroundColor),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: cCanvasBlack, width: 2),
          ),
        ),
      ),
      child: Text(
        Language.locale(uiBloc.language, 'more'),
        style: const TextStyle(
          color: cPrimaryColor,
          fontFamilyFallback: f,
        ),
      ),
    );
  }

  Widget buildTitle(
      UiBloc uiBloc, BuildContext context, List<dynamic> content) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: cGray,
              fontSize: ScreenUtil().setSp(18),
              fontFamilyFallback: f,
              fontWeight: FontWeight.bold,
            ),
          ),
          // content.length > 6 ?
          buildMoreBtn(ar, context, uiBloc)
          //  : Container(),
        ],
      ),
    );
  }

  String _routePage(MEDIA ar) {
    switch (ar) {
      case MEDIA.SONG:
        return SONGS_PAGE_ROUTE;
      case MEDIA.ALBUM:
        return ALBUMS_PAGE_ROUTE;
      case MEDIA.VIDEO:
        return MUSIC_VIDEOS_PAGE_ROUTE;
      case MEDIA.ARTIST:
        return ARTISTS_PAGE_ROUTE;
      case MEDIA.PLAYLIST:
        return PLAYLISTS_PAGE_ROUTE;
      default:
        return ALBUMS_PAGE_ROUTE;
    }
  }

  double _cardHeight(MEDIA ar) {
    switch (ar) {
      case MEDIA.ALBUM:
      case MEDIA.SONG:
      case MEDIA.CHANNEL:
        return 190;
      case MEDIA.PLAYLIST:
      case MEDIA.VIDEO:
        return 170;
      case MEDIA.ARTIST:
        return 140;
      default:
        return 190;
    }
  }
}
