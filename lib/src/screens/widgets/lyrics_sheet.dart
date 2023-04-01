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
  State<LyricsBtn> createState() => _LyricsBtnState();
}

class _LyricsBtnState extends State<LyricsBtn> {
  bool scrollable = false;
  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    final uiBloc = UiProvider.of(context);
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () {
        ScrollController sc = ScrollController();
        buildShowModalBottomSheet(context, playerBloc, sc, size);
      },
      style: ButtonStyle(
        // elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all<Color>(cBackgroundColor),
        // visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(
                color: cPrimaryColor,
                width: 1,
              )),
        ),
      ),
      child: Text(
        Language.locale(uiBloc.language, 'lyric'),
        style: const TextStyle(
          color: cPrimaryColor,
          // fontWeight: FontWeight.bold,
          fontFamilyFallback: f,
        ),
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context, PlayerBloc playerBloc,
      ScrollController sc, Size size) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: cBackgroundColor.withOpacity(0.5),
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
                  duration: const Duration(milliseconds: 500));
            }
            return buildContainer(sc, size, context);
          });
        });
  }

  Container buildContainer(
      ScrollController sc, Size size, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Stack(
        children: [
          ListWheelScrollView(
            itemExtent: 25,
            physics: scrollable
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: sc,
            children: kLYRIC
                .map((e) => SizedBox(
                      width: size.width,
                      child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamilyFallback: f,
                          color: cGray,
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
                  color: cPrimaryColor,
                  // color: cBackgroundColor,
                  icon: const Icon(Ionicons.close_circle_outline),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                color: !scrollable ? cPrimaryColor : cGray,
                icon: const Icon(Ionicons.list_outline),
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
