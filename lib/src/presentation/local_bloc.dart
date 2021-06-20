// import 'package:flutter/material.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../domain/models/models.dart';
// import '../infrastructure/services/download_manager.dart';
// import '../infrastructure/services/services.dart';

class LocalSongsBloc {
//   CustomNotification _customNotification;

//   final down = DownloadsManager();
//   final _audioQuery = FlutterAudioQuery();
//   final _downloadsManager = DownloadsManager();

//   int downloadProgess = 0;

//   List<ArtistInfo> artists;
//   List<AlbumInfo> albums;
//   List<SongInfo> songs;
//   List<DownloadedSong> downloadedSongs;
//   List<GenreInfo> genres;

//   Map<String, List<SongInfo>> artistSongs = {};
//   Map<String, List<SongInfo>> albumsSongs = {};
//   Map<String, List<AlbumInfo>> artistAlbums = {};
//   Map<String, List<SongInfo>> genreSongs = {};

//   void init() async {
//     //
//     _customNotification = CustomNotification();
//     //
//   }

//   Future<List<SongInfo>> getSongsFromArtist(String artistId) async {
//     artistSongs[artistId] =
//         await _audioQuery.getSongsFromArtist(artistId: artistId);

//     return artistSongs[artistId];
//   }

//   Future<List<SongInfo>> searchSongs(String name) async =>
//       await _audioQuery.searchSongs(query: name);
//   Future<List<ArtistInfo>> searchArtists(String name) async =>
//       await _audioQuery.searchArtists(query: name);
//   Future<List<AlbumInfo>> searchAlbums(String name) async =>
//       await _audioQuery.searchAlbums(query: name);
//   Future<List<GenreInfo>> searchGenres(String name) async =>
//       await _audioQuery.searchGenres(query: name);

//   Future<List<SongInfo>> getSongsFromGenre(String genreTitle) async {
//     genreSongs[genreTitle] =
//         await _audioQuery.getSongsFromGenre(genre: genreTitle);

//     return genreSongs[genreTitle];
//   }

//   Future<List<SongInfo>> getSongsFromAlbum(String albumId) async {
//     albumsSongs[albumId] =
//         await _audioQuery.getSongsFromAlbum(albumId: albumId);

//     return albumsSongs[albumId];
//   }

//   Future<List<AlbumInfo>> getAlbumsFromArtist(String artistName) async {
//     artistAlbums[artistName] =
//         await _audioQuery.getAlbumsFromArtist(artist: artistName);

//     return artistAlbums[artistName];
//   }

//   Future<List<GenreInfo>> getGenres() async {
//     genres = await _audioQuery.getGenres();
//     return genres;
//   }

//   Future<List<SongInfo>> getSongs() async {
//     songs = await _audioQuery.getSongs();
//     return songs;
//   }

//   Future<List<ArtistInfo>> getArtists() async {
//     artists = await _audioQuery.getArtists();
//     return artists;
//   }

//   Future<List<AlbumInfo>> getAlbums() async {
//     albums = await _audioQuery.getAlbums();
//     return albums;
//   }

//   Future<List<DownloadedSong>> getDownloadedMusic(
//       TargetPlatform platform) async {
//     downloadedSongs = await _downloadsManager.getDownloaded(platform);
//     return downloadedSongs;
//   }

//   void deleteDownloads(List<DownloadedSong> songs) {
//     return _downloadsManager.deleteDownload(songs);
//   }

//   dynamic buildFutures(String categoryTitle) {
//     switch (categoryTitle) {
//       case 'Songs':
//         return getSongs();
//       case 'Artists':
//         return getArtists();
//       case 'Albums':
//         return getAlbums();
//       default:
//         return null;
//     }
//   }

//   Future fetchAll() async {
//     getSongs();
//     getArtists();
//     getAlbums();
//   }

//   dynamic buildInitialData(String categoryTitle) {
//     switch (categoryTitle) {
//       case 'Songs':
//         return songs;
//       case 'Artists':
//         return artists;
//       case 'Albums':
//         return albums;
//       default:
//         return null;
//     }
//   }

//   Future downloadMusic(
//     TargetPlatform platform,
//     Song song, {
//     progress(int i, int j),
//   }) async {
//     if (await checkPermission()) {
//       final response = await down.downloadMusic(
//         platform,
//         song,
//         onReceiveProgress: (int i, int j) {
//           progress(i, j);
//           downloadProgess = i * 100 ~/ j;
//           _customNotification.showProgressNotification(downloadProgess, song);
//         },
//       );

//       _customNotification.noti.cancel(song.filePath.length);
//       if (response == 'OK') {
//         _customNotification.showProgressNotification(100, song);
//       } else {
//         _customNotification.showProgressNotification(-1, song);
//       }
//     }
//   }

//   Future<bool> checkPermission() async {
//     final permissionStatus = await Permission.storage.request();

//     if (!permissionStatus.isGranted) {
//       ScaffoldMessengerState().showSnackBar(
//         SnackBar(
//           content: Text('Please give permission'),
//         ),
//       );
//     }
//     return permissionStatus.isGranted;
//   }

//   void killDownloader() {
//     // down.kill();
//   }
}
