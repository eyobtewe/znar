// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../abstracts/local.dart';
import 'app_databse.dart';

class LocalPlaylist implements LocalStorage {
  static const String PLAYLIST_STORE_NAME = 'playlists';
  static const String FAVORITES_STORE_NAME = 'favorites';
  static const String DOWNLOAD_STORE_NAME = 'downloads';

  final _playlistStore = intMapStoreFactory.store(PLAYLIST_STORE_NAME);
  final _favoriteStore = intMapStoreFactory.store(FAVORITES_STORE_NAME);
  // final _downloadStore = intMapStoreFactory.store(DOWNLOAD_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  @override
  Future<int> createPlaylist(Playlist playlist) async {
    int data = await _updatePlaylist(playlist);
    if (data == 0) {
      return await _playlistStore.add(
        await _db,
        playlist.toJson(),
      );
    }
    return null;
  }

  @override
  Future<int> addSongToPlaylist(Song song, Playlist playlist) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final Playlist temp = Playlist.fromJson(record.value);
        return temp.sId == playlist.sId;
      }),
    );

    final RecordSnapshot recordSnapshots = await _playlistStore.findFirst(
      await _db,
      finder: finder,
    );

    final Playlist p = Playlist.fromJson(recordSnapshots.value);
    final StoreRef plistStor = intMapStoreFactory.store(p.name);

    int data = await _update(song, plistStor);

    if (data == 0) {
      return await plistStor.add(
        await _db,
        song.toJson(),
      );
    }
    return null;
  }

  @override
  Future<int> removeSongFromPlaylist(Song song, Playlist playlist) async {
    final StoreRef playlistStor = intMapStoreFactory.store(playlist.name);

    final finder = Finder(
      filter: Filter.custom((record) {
        final Playlist s = Playlist.fromJson(record.value);
        return song == null ? true : s.sId == song.sId;
      }),
    );

    return await checkPermission()
        ? await playlistStor.delete(
            await _db,
            finder: finder,
          )
        : 0;
  }

  @override
  Future<int> removePlaylist(Playlist playlist) async {
    await removeSongFromPlaylist(null, playlist);
    final finder = Finder(
      filter: Filter.custom((record) {
        final Playlist list = Playlist.fromJson(record.value);
        return list.sId == playlist.sId;
      }),
    );

    return await checkPermission()
        ? await _playlistStore.delete(await _db, finder: finder)
        : 0;
  }

  @override
  Future<List<Playlist>> fetchPlaylists() async {
    final List<RecordSnapshot> recordSnapshots = await _playlistStore.find(
      await _db,
    );
    return recordSnapshots.map((e) {
      final Playlist playlist = Playlist.fromJson(e.value);
      return playlist;
    }).toList();
  }

  @override
  Future<List<Song>> fetchSongs(Playlist playlist) async {
    final StoreRef playlistStor = intMapStoreFactory.store(playlist.name);

    final List<RecordSnapshot> recordSnapshots = await playlistStor.find(
      await _db,
    );

    return recordSnapshots.map((e) {
      final Song playlist = Song.fromJson(e.value);
      return playlist;
    }).toList();
  }

  @override
  Future<int> clearAllPlaylists() async {
    return await _playlistStore.delete(await _db);
  }

  @override
  Future<int> addToFavorites(Song song) async {
    int data = await _update(song, _favoriteStore);
    if (data == 0) {
      return await _favoriteStore.add(
        await _db,
        song.toJson(),
      );
    }
    return null;
  }

  @override
  Future<bool> isInFavorites(Song song) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final Song s = Song.fromJson(record.value);
        return s.sId == song.sId;
      }),
    );

    RecordSnapshot record = await _favoriteStore.findFirst(
      await _db,
      finder: finder,
    );

    return record == null ? false : true;
  }

  @override
  Future<int> removeFromFavorites(Song song) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final Song s = Song.fromJson(record.value);
        return s.sId == song.sId;
      }),
    );
    return await _favoriteStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<int> _updatePlaylist(Playlist playlist) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final list = Playlist.fromJson(record.value);
        return (list.sId == playlist.sId);
      }),
    );
    return await _playlistStore.update(
      await _db,
      playlist.toJson(),
      finder: finder,
    );
  }

  Future<int> _update(Song song, StoreRef playlistStore) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        final list = Song.fromJson(record.value);
        return (list.sId == song.sId);
      }),
    );
    return await playlistStore.update(
      await _db,
      song.toJson(),
      finder: finder,
    );
  }

  // Future<List<Song>> fetchDownloadedSongsDetails(List<String> ids) async {
  //   final _finder = Finder(
  //     filter: Filter.custom((record) {
  //       final song = Song.fromJson(record.value);
  //       ids.forEach((element) {
  //         if (element == song.filePath) {
  //           return true;
  //         }
  //       });
  //       return false;
  //     }),
  //   );
  //   // Filter.or(filters)
  //   final List<RecordSnapshot> recordSnapshots = await _downloadStore.find(
  //     await _db,
  //     finder: _finder,
  //   );

  //   return recordSnapshots.map((e) {
  //     final Song playlist = Song.fromJson(e.value);
  //     return playlist;
  //   }).toList();
  // }

  // Future<int> saveDownloadedSong(Song song) async {
  //   int data = await _update(song, _downloadStore);

  //   if (data == 0) {
  //     return await _downloadStore.add(
  //       await _db,
  //       song.toJson(),
  //     );
  //   }
  //   return null;
  // }

  Future<bool> checkPermission() async {
    final permissionStatus = await Permission.storage.request();

    if (!permissionStatus.isGranted) {
      ScaffoldMessengerState().showSnackBar(
        const SnackBar(
          backgroundColor: cBlue,
          content: Text(
            'Please give permission',
          ),
        ),
      );
    }
    return permissionStatus.isGranted;
  }
}
