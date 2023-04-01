// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt;

import '../domain/models/music_video.dart';

enum PlayerInit { SLEEP, AWAKE }

class PlayerBloc {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('id');
  yt.YoutubePlayerController youtubeController;
  MusicVideo _currentVideo;

  StreamController<yt.PlayerState> videoPlayer =
      StreamController<yt.PlayerState>.broadcast();

  Stream<yt.PlayerState> get videoStr => videoPlayer.stream;
  Sink<yt.PlayerState> get videoSnk => videoPlayer.sink;

  PlayerInit playerStatus = PlayerInit.SLEEP;
  bool playingLocal = false;

  void setCurrentVideo(MusicVideo musicVideo) {
    _currentVideo = musicVideo;
  }

  MusicVideo getCurrentVideo() => _currentVideo;

  void videoInit(MusicVideo musicVideo) {
    stop();
    setCurrentVideo(musicVideo);
    if (youtubeController != null) {
      youtubeController = null;
    }
    youtubeController = yt.YoutubePlayerController(
      initialVideoId: yt.YoutubePlayer.convertUrlToId(musicVideo.url),
      flags: const yt.YoutubePlayerFlags(
        enableCaption: false,
        autoPlay: true,
      ),
    );
    // youtubeController.play();

    debugPrint('\t\t\t ${youtubeController.value.playerState}');
    videoSnk.add(yt.PlayerState.cued);
    // youtubeController.addListener(() {

    //   videoSnk.add(youtubeController.value.playerState);
    // });
  }

  void dispose() async {
    // videoSnk.add(yt.PlayerState.unknown);
    await videoPlayer.close();
  }

  void stopVideo() {
    videoSnk.add(yt.PlayerState.unknown);

    // youtubeController.dispose();
    // dispose();
  }

  Future<bool> audioInit(int index, dynamic songs,
      [bool isLocal = false, bool isDownloaded = false]) async {
    // audioPlayer = AssetsAudioPlayer.withId('id');
    List<Audio> audios = fillAudio(songs, isLocal, isDownloaded);
    stopVideo();
    try {
      // if (await checkPermission()) {
      await audioPlayer.open(
        Playlist(audios: audios, startIndex: index),
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings: const NotificationSettings(),
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy: const AudioFocusStrategy.request(),
        autoStart: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
      );
      playerStatus = PlayerInit.AWAKE;
      // }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> stop() async {
    if (audioPlayer != null) {
      await audioPlayer.stop();
    }
    playerStatus = PlayerInit.SLEEP;
    // _playerInit.close();
  }

  List<Audio> fillAudio(songs, bool isLocal, [bool isDownloaded = false]) {
    List<Audio> data = [];

    playingLocal = isLocal;

    if (isDownloaded) {
      songs.forEach((dynamic s) {
        Audio song = Audio.file(
          s.path,
          metas: Metas(
            title: s?.title ?? '',
            album: s?.album ?? '',
            artist: s?.artist ?? '',
            id: s.sId,
            extra: {
              'image': s.image,
            },
          ),
        );
        data.add(song);
      });
      return data;
    }

    if (!isLocal) {
      songs.forEach((e) {
        String urle = e.fileUrl;
        String url = urle.replaceAll(RegExp(r' '), '%20');
        Audio song = Audio.network(
          url,
          metas: Metas(
            title: e.title ?? '',
            album: e.albumStatic?.name ?? '',
            artist:
                // e.artistStatic.stageName != e.artistStatic.firstName
                // ? e.artistStatic.stageName
                // :
                e.artistStatic.fullName,
            image: MetasImage.network(e.coverArt ?? ''),
            id: e.sId,
            extra: {'image': null},
          ),
        );
        data.add(song);
      });
    } else {
      songs.forEach((e) {
        // String urle = e.fileUrl;
        // String url = urle.replaceAll(RegExp(r' '), '%20');
        Audio song = Audio.file(e.filePath,
            metas: Metas(
              title: e.title ?? '',
              album: e.album ?? '',
              artist: e.artist ?? '',
              image: MetasImage.file(e.albumArtwork ?? ''),
              id: e.id ?? '',
              extra: {'image': null},
            ));
        data.add(song);
      });
    }

    return data;
  }
}
