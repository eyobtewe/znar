import 'dart:io';
import 'dart:typed_data';

import 'package:audiotagger/audiotagger.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/colors.dart';

import '../../domain/models/models.dart';

class DownloadsManager {
  CancelToken cancelToken = CancelToken();
  Dio dio = Dio();
  Directory externalDirectory;

  Future<String> downloadMusic(
    Song song, {
    Function(int i, int j) onReceiveProgress,
  }) async {
    await setDirectory();

    Directory dir = Directory('${externalDirectory.path}/.znar');
    if (!dir.existsSync()) {
      dir.createSync();
    }

    if (cancelToken.isCancelled) {
      cancelToken = CancelToken();
    }
    try {
      String fileTitle = '${dir.path}/${song.title}.mp3';
      final id = await dio.download(
        song.fileUrl,
        fileTitle,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      return id.data;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> getDownloaded() async {
    await setDirectory();

    final Directory directory = Directory('${externalDirectory.path}/.znar');
    if (!directory.existsSync()) {
      directory.createSync();
    }

    Stream<FileSystemEntity> files = directory.list();

    return getFile(files, directory);
  }

  Future<List<dynamic>> getFile(files, directory) async {
    return files.asyncMap(
      (FileSystemEntity event) async {
        Audiotagger audiotagger = Audiotagger();
        Map audioFile = await audiotagger.readTagsAsMap(path: event.path);
        Uint8List img = await audiotagger.readArtwork(path: event.path);

        DownloadedSong songData;
        songData = DownloadedSong.fromMap(audioFile);

        songData.path = event.path;
        songData.image = img;

        return songData;
      },
    ).toList();
  }

  Future<void> setDirectory() async {
    externalDirectory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
  }

  void deleteDownload(List<DownloadedSong> songs) {
    if (songs.isEmpty) {
      final Directory directory = Directory('${externalDirectory.path}/.znar');
      directory.deleteSync(recursive: true);
    } else {
      for (final element in songs) {
        var f = File(element.path);
        f.deleteSync();
      }
    }
  }

  void kill() {
    cancelToken.cancel();
  }
}

void showToast(String message) {
  ScaffoldMessengerState().showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: cGray),
      ),
    ),
  );
}
