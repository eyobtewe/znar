import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/core.dart';
import '../../infrastructure/services/dummy_data.dart';
import '../../presentation/bloc.dart';

class LyricsBtn extends StatefulWidget {
  const LyricsBtn({Key key}) : super(key: key);

  @override
  _LyricsBtnState createState() => _LyricsBtnState();
}

class _LyricsBtnState extends State<LyricsBtn> {
  bool scrollable = false;
  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    final uiBloc = UiProvider.of(context);
    final size = MediaQuery.of(context).size;
    ScreenUtil.init(context, designSize: size, allowFontScaling: true);

    return ElevatedButton(
      onPressed: () {
        ScrollController sc = ScrollController();
        buildShowModalBottomSheet(context, playerBloc, sc, size);
      },
      child: Text(
        Language.locale(uiBloc.language, 'lyric'),
        style: TextStyle(
          color: PRIMARY_COLOR,
          // fontWeight: FontWeight.bold,
          fontFamilyFallback: f,
        ),
      ),
      style: ButtonStyle(
        // elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(BACKGROUND),
        // visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(
                color: PRIMARY_COLOR,
                width: 1,
              )),
        ),
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context, PlayerBloc playerBloc,
      ScrollController sc, Size size) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: BACKGROUND.withOpacity(0.5),
        isScrollControlled: true,
        enableDrag: true,
        builder: (_) {
          return playerBloc.audioPlayer.builderRealtimePlayingInfos(
              builder: (_, RealtimePlayingInfos r) {
            if (sc.hasClients && !scrollable) {
              sc.animateTo(
                  (r.currentPosition.inSeconds / r.duration.inSeconds) *
                      size.height,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500));
            }
            return buildContainer(sc, size, context);
          });
        });
  }

  Container buildContainer(
      ScrollController sc, Size size, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Stack(
        children: [
          ListWheelScrollView(
            itemExtent: 25,
            physics: scrollable
                ? BouncingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            controller: sc,
            children: kLYRIC
                .map((e) => Container(
                      width: size.width,
                      child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamilyFallback: f,
                          color: GRAY,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: IconButton(
                  visualDensity: VisualDensity.compact,
                  color: PRIMARY_COLOR,
                  // color: BACKGROUND,
                  icon: Icon(Ionicons.close_circle_outline),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                color: !scrollable ? PRIMARY_COLOR : GRAY,
                icon: Icon(Ionicons.list_outline),
                onPressed: () {
                  setState(() {
                    scrollable = !scrollable;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
