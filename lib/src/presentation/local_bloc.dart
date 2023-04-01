import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/models/models.dart';
import '../infrastructure/services/download_manager.dart';
import '../infrastructure/services/services.dart';

class LocalSongsBloc {
  CustomNotification _customNotification;

  final _downloadsManager = DownloadsManager();

  int downloadProgess = 0;

  List<dynamic> downloadedSongs;

  void init() async {
    _customNotification = CustomNotification();
    getDownloadedMusic();
  }

  Future<List<dynamic>> getDownloadedMusic() async {
    downloadedSongs = await _downloadsManager.getDownloaded();
    return downloadedSongs;
  }

  void deleteDownloads(List<DownloadedSong> songs) {
    return _downloadsManager.deleteDownload(songs);
  }

  Future downloadMusic(
    Song song, {
    Function(int i, int j) progress,
  }) async {
    if (await checkPermission()) {
      final response = await _downloadsManager.downloadMusic(
        song,
        onReceiveProgress: (int i, int j) {
          progress(i, j);
          downloadProgess = i * 100 ~/ j;
          _customNotification.showProgressNotification(downloadProgess, song);
        },
      );

      _customNotification.noti.cancel(song.filePath.length);
      if (response == 'OK') {
        _customNotification.showProgressNotification(100, song);
      } else {
        _customNotification.showProgressNotification(-1, song);
      }
    }
  }

  Future<bool> checkPermission() async {
    final permissionStatus = await Permission.storage.request();

    if (!permissionStatus.isGranted) {
      ScaffoldMessengerState().showSnackBar(
        const SnackBar(
          content: Text('Please give permission'),
        ),
      );
    }
    return permissionStatus.isGranted;
  }

  void killDownloader() {
    _downloadsManager.kill();
  }
}
