import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';
import 'package:share/share.dart';

import '../../core/core.dart';
import '../../infrastructure/services/services.dart';
import '../../presentation/bloc.dart';
import '../screens.dart';
import '../widgets/widgets.dart';
import 'widgets/widgets.dart';

class AudioPlayerScreen extends StatefulWidget {
  final List<dynamic> songs;
  final int i;
  final bool isFromBottomBar;
  final bool isLocal;
  final bool isDownloaded;

  const AudioPlayerScreen(
      {this.songs,
      this.i,
      this.isFromBottomBar = false,
      this.isLocal = false,
      this.isDownloaded = false});
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  void initState() {
    super.initState();
  }

  PlayerBloc playerBloc;
  ApiBloc bloc;
  Size size;
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    bloc = ApiProvider.of(context);
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      extendBody: true,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: BACKGROUND.withOpacity(0),
      elevation: 0,
      actions: (widget.isLocal || widget.isDownloaded)
          ? null
          : [
              IconButton(
                icon: Icon(Ionicons.share_social_outline),
                onPressed: () async {
                  final String link = await kDynamicLinkService
                      .createDynamicLink(widget.songs[widget.i]);

                  Share.share(
                      '${widget.songs[widget.i].title} - ${widget.songs[widget.i].artistStatic.fullName} \n\n$link');
                },
              ),
            ],
    );
  }

  Widget buildBody() {
    return Center(
      child: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: Row(
            //     children: [Spacer(), LyricsBtn()],
            //   ),
            // ),
            SongArtwork(songArt: widget.songs[widget.i].coverArt),
            Divider(color: TRANSPARENT),
            SongDetails(),
            PlayerButtons(),
            Divider(color: TRANSPARENT),
            buildContainer(),
          ],
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      height: 180,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          return playerBloc.audioPlayer.builderCurrent(
              builder: (BuildContext ctx, Playing playing) {
            return playing.audio.audio.metas.id == widget.songs[i].sId
                ? Container()
                : Container(
                    child: SongThumbnail(i: i, song: widget.songs),
                    width: 120,
                  );
          });
        },
        itemCount: bloc.buildInitialData(CustomAspectRatio.SONG).length - 1,
      ),
    );
  }
}

class LyricsBtn extends StatelessWidget {
  const LyricsBtn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = PlayerProvider.of(context);
    final size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: () {
        ScrollController sc = ScrollController();
        buildShowModalBottomSheet(context, playerBloc, sc, size);
      },
      child: Text(
        'Lyrics',
        style: TextStyle(color: BACKGROUND),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR),
        visualDensity: VisualDensity.compact,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context, PlayerBloc playerBloc,
      ScrollController sc, Size size) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: BACKGROUND,
        enableDrag: true,
        builder: (BuildContext ctx) {
          return playerBloc.audioPlayer.builderRealtimePlayingInfos(
              builder: (BuildContext ctx, RealtimePlayingInfos r) {
            if (sc.hasClients) {
              sc.animateTo(
                  (r.currentPosition.inSeconds / r.duration.inSeconds) *
                      size.height,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500));
            }
            return buildContainer(sc, size);
          });
        });
  }

  Container buildContainer(ScrollController sc, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListWheelScrollView(
        itemExtent: 30,
        overAndUnderCenterOpacity: 0.8,
        physics: NeverScrollableScrollPhysics(),
        controller: sc,
        children: kLYRIC
            .map((e) => Container(
                  width: size.width,
                  child: Text(
                    e,
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// }

List<String> kLYRIC = [
  "Love yours",
  "No such thing as a life that's better than yours",
  "(Love yourz)",
  "No such thing as a life that's better than yours",
  "No such thing, no such thing",
  "Heart beatin' fast, let a nigga know that he alive",
  "Fake niggas mad, snakes in the grass let a nigga know that he arrive",
  "Don't be sleepin' on you lover cause its beauty in the struggle nigga",
  "Goes for all y'all",
  "It's beauty in the struggle nigga",
  "It's beauty in the struggle nigga, ugliness in the success",
  "Hear my words or listen to my signal of distress",
  "I grew up in the city and though some times we had less",
  "Compared to some of my niggas down the block man we were blessed",
  "And life can't be no fairytale, no once upon a time",
  "But I be God damned if a nigga don't be tryin'",
  "So tell me mama please why you be drinking all the time?",
  "Does all the pain he brought you still linger in your mind?",
  "Cause pain still lingers on mine",
  "On the road to riches listen this is what you'll find",
  "The good news is nigga you came a long way",
  "The bad news is nigga you went the wrong way",
  "You think being broke is better",
  "No such thing as a life that's better than yours",
  "No such thing, no such thing",
  "For what's money without hapiness?",
  "Or hard times without the people you love",
  "Though I'm not sure what's 'bout to happen next",
  "I asked for strength from the Lord up above",
  "Cause I've been strong so far",
  "But I can feel my grip loosening",
  "Quick, do something before you lose it for good",
  "Get it back and use it for good",
  "And touch the people how you did like before",
  "I'm tired of living with demons cause they always inviting more",
  "Think being broke was better",
  "Now I don't mean that phrase with no disrespect",
  "To all my niggas out there living in debt",
  "Cashing minimal checks",
  "Turn on the TV see a nigga Rolex",
  "And fantasize about a life with no stress",
  "I mean this shit sincerely",
  "And that's a nigga who was once in your shoes",
  "Living with nothin' to lose",
  "I hope one day you hear me",
  "Always gon' be a bigger house somewhere, but nigga feel me",
  "'Long as the people in that motherfucker love you dearly",
  "Always gon' be a whip that's better than the the one you got",
  "Always gon' be some clothes that's fresher than the one's you rock",
  "Always gon' be a bitch that's badder out there on the tours",
  "But you ain't never gon' be happy till you love yours",
  "No such thing as a life that's better than yours",
  "(Love yourz)",
  "No such thing as a life that's better than yours",
  "No such thing, no such thing",
  "Heart beatin' fast, let a nigga know that he alive",
  "Fake niggas mad, snakes in the grass let a nigga know that he arrive",
];
