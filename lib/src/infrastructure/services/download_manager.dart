import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/models.dart';

class DownloadsManager {
  // CancelToken cancelToken = CancelToken();
  // Dio dio = Dio();
  Directory externalDirectory;

  Future<String> downloadMusic(
    TargetPlatform platform,
    Song song, {
    onReceiveProgress(int i, int j),
  }) async {
    await setDirectory(platform);

    // Directory dir = Directory(externalDirectory.path);
    Directory dir = Directory(externalDirectory.path + '/.znar');
    if (!dir.existsSync()) {
      dir.createSync();
    }

    // if (cancelToken.isCancelled) {
    //   cancelToken = CancelToken();
    // }

    try {
      // final id = await FlutterDownloader.enqueue(
      //   url: song.fileUrl,
      //   savedDir: dir.path,
      //   showNotification: true,
      //   openFileFromNotification: true,
      //   fileName: song.title,
      // );
      // final id = await dio.download(
      //   song.fileUrl,
      //   dir.path + '/' + song.sId + '.mp3',
      //   onReceiveProgress: onReceiveProgress,
      //   cancelToken: cancelToken,
      // );
      // return id;
      // if (id.statusMessage == 'OK') {
      //   showToast('Downloaded successfully');
      // }
      // return id.statusMessage;
    } catch (e) {
      return null;
    }
  }

  Future<List<DownloadedSong>> getDownloaded(TargetPlatform platform) async {
    await setDirectory(platform);

    // final Directory directory = Directory(externalDirectory.path);
    final Directory directory = Directory(externalDirectory.path + '/.znar');
    if (!directory.existsSync()) {
      directory.createSync();
    }

    Stream<FileSystemEntity> files = directory.list();
    TagProcessor tp = TagProcessor();

    return files.asyncMap((FileSystemEntity event) async {
      List<Tag> t = [];

      t = await tp.getTagsFromByteArray(
        File(event.path).readAsBytes(),
        [TagType.id3v1],
      );

      debugPrint(event.path);

      if (t[0].tags.isNotEmpty) {
        final dil = await tp.getTagsFromByteArray(
          File(event.path).readAsBytes(),
          [TagType.id3v2],
        );
        DownloadedSong songData = DownloadedSong.fromMap(dil[0]?.tags);

        songData.path = event.path;

        songData.sId = event.path.replaceFirst(directory.path + '/', '');
        // debugPrint('\n\n--\n\n\t\t${songData.toString()}\n\n--\n\n');
        return songData;
      }

      return DownloadedSong();
    }).toList();
  }

  Future<void> setDirectory(TargetPlatform platform) async {
    externalDirectory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    // debugPrint('\n\n--\n\n\t\t$externalDirectory\n\n--\n\n');
  }

  void deleteDownload(List<DownloadedSong> songs) {
    if (songs.isEmpty) {
      // final Directory directory = Directory(externalDirectory.path);
      final Directory directory = Directory(externalDirectory.path + '/.znar');
      directory.deleteSync(recursive: true);
    } else {
      songs.forEach((element) {
        var f = File(element.path);
        f.deleteSync();
      });
    }
  }

  // void kill() {
  //   cancelToken.cancel();
  // }
}

Future showToast(String message) async {
  ScaffoldMessengerState().showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
