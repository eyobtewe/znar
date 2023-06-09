import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../presentation/bloc.dart';
import '../screens.dart';
import 'widgets.dart';

class PlayerDynamicLinkCatcher extends StatelessWidget {
  final String songId;
  final bool isAudio;

  const PlayerDynamicLinkCatcher({Key key, this.songId, this.isAudio}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = ApiProvider.of(context);
    final playerBloc = PlayerProvider.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: isAudio
            ? bloc.fetchSongDetails(songId)
            : bloc.fetchMusicVideoDetails(songId),
        builder: (_, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const CustomLoader();
          } else {
            Future.delayed(const Duration(milliseconds: 200), () {
              goTo(snapshot, context, playerBloc);
            });

            return Center(
              child: IconButton(
                icon: const Icon(Ionicons.play_back_circle_outline, size: 54),
                onPressed: () {
                  goTo(snapshot, context, playerBloc);
                },
              ),
            );
          }
        },
      ),
    );
  }

  void goTo(AsyncSnapshot<dynamic> snapshot, BuildContext context,
      PlayerBloc playerBloc) {
    if (isAudio) {
      if (playerBloc.audioPlayer != null) {
        playerBloc.audioPlayer.stop();
      }
      playerBloc.audioInit(0, [snapshot.data]);

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => AudioPlayerScreen(
      //               i: 0,
      //               songs: [snapshot.data],
      //             )));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomWebPage(url: snapshot.data.url),
        ),
      );
    }
  }
}
