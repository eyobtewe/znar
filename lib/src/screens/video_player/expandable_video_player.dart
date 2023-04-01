import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/core.dart';
import '../../domain/models/music_video.dart';
import '../../infrastructure/services/services.dart';
import '../../presentation/bloc.dart';
import '../widgets/widgets.dart';

class ExpandableBottomVideoPlayer extends StatefulWidget {
  const ExpandableBottomVideoPlayer({Key key}) : super(key: key);

  @override
  State<ExpandableBottomVideoPlayer> createState() =>
      _ExpandableBottomVideoPlayerState();
}

class _ExpandableBottomVideoPlayerState
    extends State<ExpandableBottomVideoPlayer> {
  MiniplayerController miniPlayerController;

  @override
  void initState() {
    miniPlayerController = MiniplayerController();

    super.initState();
  }

  PlayerBloc playerBloc;
  ApiBloc bloc;
  UiBloc uiBloc;

  Size size;

  @override
  Widget build(BuildContext context) {
    playerBloc = PlayerProvider.of(context);
    size = MediaQuery.of(context).size;

    bloc = ApiProvider.of(context);
    uiBloc = UiProvider.of(context);
    MusicVideo musicVideo = playerBloc.getCurrentVideo();

    return
        //  (playerBloc.youtubeController.value.playerState ==
        //             yt.PlayerState.unStarted ||
        //         playerBloc.youtubeController.value.playerState ==
        //             yt.PlayerState.unknown)
        //     ? Container()
        //     :
        Miniplayer(
            controller: miniPlayerController,
            backgroundColor: cBackgroundColor,
            curve: Curves.easeInOutCubic,
            minHeight: 67.0,
            maxHeight: size.height,
            builder: (double height, double percentage) {
              return height == 67
                  ? buildSmallPlayer(musicVideo)
                  : buildBigPlayer(musicVideo);
            });
  }

  Widget buildSmallPlayer(MusicVideo musicVideo) {
    double height = 67;
    return Container(
      color: cBackgroundColor,
      child: ListTile(
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        leading: buildVideoPlayer(height),
        title: Text(
          musicVideo.title,
          maxLines: 1,
          style: TextStyle(
            fontFamilyFallback: f,
            color: cGray,
            fontSize: ScreenUtil().setSp(12),
          ),
        ),
        subtitle: Text(
          musicVideo.artistStatic.fullName,
          maxLines: 1,
          style: TextStyle(
            color: cDarkGray,
            fontFamilyFallback: f,
            fontSize: ScreenUtil().setSp(10),
          ),
        ),
        onTap: () {
          miniPlayerController.animateToHeight(
            state: PanelState.MAX,
            duration: const Duration(milliseconds: 300),
          );
        },
        trailing: IconButton(
            icon: const Icon(Ionicons.close_outline),
            color: cPrimaryColor,
            onPressed: () {
              playerBloc.stopVideo();
            }),
      ),
    );
  }

  Widget buildVideoPlayer(double height) {
    return SizedBox(
      height: height,
      width: height * 16 / 9,
      child: YoutubePlayer(
        controller: playerBloc.youtubeController,
        showVideoProgressIndicator: false,
      ),
    );
  }

  Widget buildBigPlayer(MusicVideo musicVideo) {
    return Container(
      color: cBackgroundColor,
      child: Center(
        child: StreamBuilder<Playing>(
            stream: playerBloc.audioPlayer.current,
            builder: (_, AsyncSnapshot<Playing> snapshot) {
              return Column(
                children: [
                  Stack(
                    children: [
                      buildVideoPlayer(size.width * 9 / 16),
                      Positioned(
                        top: 20,
                        child: IconButton(
                          onPressed: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              miniPlayerController.animateToHeight(
                                state: PanelState.MIN,
                                duration: const Duration(milliseconds: 300),
                              );
                            } else {
                              playerBloc.youtubeController
                                  .toggleFullScreenMode();
                            }
                          },
                          icon: const Icon(Ionicons.arrow_back),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height - size.height * 9 / 16,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: [
                        buildVideoDescription(musicVideo),
                        buildThumbnails(musicVideo, 'similar_from_artist'),
                        buildThumbnails(musicVideo, 'other_videos',
                            other: true),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Container buildVideoDescription(MusicVideo musicVideo) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: SizedBox(
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * 0.85,
              child: Wrap(
                children: [
                  Text(
                    musicVideo.title,
                    style: const TextStyle(
                      fontFamilyFallback: f,
                      fontWeight: FontWeight.bold,
                      color: cGray,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    // child: Container(color: cGray, width: 2, height: 2),
                  ),
                  Text(
                    musicVideo.artistStatic.fullName,
                    style: const TextStyle(
                      fontFamilyFallback: f,
                      color: cDarkGray,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            InkWell(
              child: const Icon(Ionicons.share_social_outline,
                  color: cPrimaryColor),
              onTap: () async {
                String link =
                    await kDynamicLinkService.createDynamicLink(musicVideo);

                Share.share(
                    '${musicVideo.title} - ${musicVideo.artistStatic.fullName} \n\n$link');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildThumbnails(MusicVideo musicVideo, String title,
      {bool other = false}) {
    return FutureBuilder(
      future: other
          ? bloc.fetchMusicVideos(1, 30)
          : bloc.fetchArtistMusicVideos(
              musicVideo.artist ?? '', '' /*musicVideo.sId*/),
      builder: (_, AsyncSnapshot<List<MusicVideo>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          List<MusicVideo> clips = snapshot.data;

          if (other) {
            clips.removeWhere((MusicVideo e) => e.artist == musicVideo.artist);
          } else {
            clips.removeWhere((MusicVideo e) => e.sId == musicVideo.sId);
          }

          return clips.isEmpty
              ? Container()
              : Column(
                  children: [
                    buildTitle(title),
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: clips.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (_, int i) {
                        return MusicVideoThumbnail(i: i, musicVideo: clips[i]);
                      },
                    ),
                  ],
                );
        }
      },
    );
  }

  Container buildTitle(String title) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            Language.locale(uiBloc.language, title),
            style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
                fontFamilyFallback: f),
          ),
        ],
      ),
    );
  }
}
