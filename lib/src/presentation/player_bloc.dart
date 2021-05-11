import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../domain/models/downloaded_songs.dart';

enum PlayerInit { SLEEP, AWAKE }

class PlayerBloc {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('id');
  PlayerInit playerStatus = PlayerInit.SLEEP;
  bool playingLocal = false;

  // Future<bool> checkPermission() async {
  //   final permissionStatus = await Permission.storage.request();

  //   if (!permissionStatus.isGranted) {
  //     Fluttertoast.showToast(
  //       msg: 'Please give permission',
  //       backgroundColor: BLUE,
  //     );
  //   }
  //   return permissionStatus.isGranted;
  // }

  Future<bool> audioInit(int index, dynamic songs,
      [bool isLocal = false, bool isDownloaded = false]) async {
    List<Audio> _audios = fillAudio(songs, isLocal, isDownloaded);

    try {
      // if (await checkPermission()) {
      await audioPlayer.open(
        Playlist(audios: _audios, startIndex: index),
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings: NotificationSettings(
          stopEnabled: false,
        ),
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy: AudioFocusStrategy.request(),
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
    await audioPlayer.stop();
    playerStatus = PlayerInit.SLEEP;
    // _playerInit.close();
  }

  List<Audio> fillAudio(songs, bool isLocal, [bool isDownloaded = false]) {
    List<Audio> data = [];

    playingLocal = isLocal;

    if (isDownloaded) {
      songs.forEach((DownloadedSong s) {
        debugPrint(s.path);
        Audio _song = Audio.file(
          s.path,
          metas: Metas(
            title: s?.title ?? '',
            album: s?.album ?? '',
            artist: s?.artist ?? '',
            id: s.path,
            extra: {
              'image': s.image,
            },
          ),
        );
        data.add(_song);
      });
      return data;
    }

    if (!isLocal) {
      songs.forEach((e) {
        String urle = e.fileUrl;
        String url = urle.replaceAll(RegExp(r' '), '%20');
        // debugPrint('\n\n${e.artistStatic?.stageName}\n\n');
        // debugPrint('\n\n$url\n\n');
        // debugPrint('\n\n${e.artistStatic?.firstName}\n\n');
        Audio _song = Audio.network(
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
        data.add(_song);
      });
    } else {
      songs.forEach((e) {
        // String urle = e.fileUrl;
        // String url = urle.replaceAll(RegExp(r' '), '%20');
        Audio _song = Audio.file(e.filePath,
            metas: Metas(
              title: e.title ?? '',
              album: e.album ?? '',
              artist: e.artist ?? '',
              image: MetasImage.file(e.SongArtworkwork ?? ''),
              id: e.id ?? '',
              extra: {'image': null},
            ));
        data.add(_song);
      });
    }

    return data;
  }
}
