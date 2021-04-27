import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../../core/core.dart';
import '../../domain/models/models.dart';
import '../abstracts/api.dart';
import 'dummy_data.dart';

class MusicApiService implements Api {
  Client _client = Client();

  // Future<dynamic> _setter(Map<String, dynamic> json, String uid, String url) async {
  //   Map<String, String> _header = {
  //     "Content-type": "application/json",
  //     "Authorization": "Bearer $uid",
  //   };

  //   return _client.post(url, body: jsonEncode(json), headers: _header).then(
  //     (Response onValue) {
  //       final int statusCode = onValue.statusCode;

  //       if (statusCode < 200 || statusCode > 400 || onValue == null) {
  //         throw new Exception('Error while fetching data');
  //       }
  //       if (jsonDecode(onValue.body)["success"] == true) {
  //         return jsonDecode(onValue.body)["data"];
  //       }
  //       return null;
  //     },
  //   );
  // }

  Future<dynamic> _getter(String url) async {
    Map<String, String> _header = {
      "xca-header": "ja04tw4tn-0bswtwojq3409hsty090ze",
    };

    try {
      var response = await _client.get(Uri.parse(url), headers: _header);

      final statusCode = response.statusCode;
      final String jsonBody = response.body;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException("Error request:", statusCode);
      }

      final parsedJson = json.decode(jsonBody);
      if (parsedJson["success"] == true) {
        return parsedJson["data"];
      } else {
        return null;
      }
    } on Exception catch (e) {
      throw new FetchDataException(e.toString(), 0);
    }
  }

  //! Channels
  Future<List<Channel>> fetchChannels() async {
    String url = ENDPOINT_CHANNELS + '?' + ENDPOINT_CHANNEL_FILTER;

    final parsedJson = await _getter(url);
    List<Channel> data = [];

    parsedJson.forEach((var item) {
      data.add(Channel.fromJson(item));
    });
    return data;
  }

  Future<List<Channel>> searchChannels(String channelName) async {
    String url =
        ENDPOINT_SEARCH_CHANNELS + channelName + '&' + ENDPOINT_CHANNEL_FILTER;

    final parsedJson = await _getter(url);
    List<Channel> data = [];

    parsedJson.forEach((var item) {
      data.add(Channel.fromJson(item));
    });
    return data;
  }

  Future<Channel> fetchChannelDetails(String id) async {
    String url =
        ENDPOINT_CHANNELS_DETAIL + '/$id' + '?' + ENDPOINT_CHANNEL_FILTER;

    final parsedJson = await _getter(url);
    return Channel.fromJson(parsedJson);
  }

  Future<List<MusicVideo>> fetchChannelMusicVideos(String id) async {
    String url = ENDPOINT_BASE +
        '/listings/channels/$id/videos/published' +
        '?' +
        ENDPOINT_MUSIC_VIDEO_FILTER;

    final parsedJson = await _getter(url);
    List<MusicVideo> data = [];

    parsedJson.forEach((var item) {
      data.add(MusicVideo.fromJson(item));
    });
    return data;
  }

  //! Songs
  Future<List<Song>> searchSongs(String term) async {
    String url = ENDPOINT_SEARCH_SONGS + term + '&' + ENDPOINT_SONG_FILTER;

    final parsedJson = await _getter(url);
    List<Song> data = [];

    parsedJson.forEach((var item) {
      data.add(Song.fromJson(item));
    });
    return data;
  }

  Future<Song> fetchSongDetails(String id) async {
    String url = ENDPOINT_SONGS_DETAIL + '/$id' + '?' + ENDPOINT_SONG_FILTER;

    final parsedJson = await _getter(url);
    return Song.fromJson(parsedJson);
  }

  Future<List<Song>> fetchSongs(int page, int count) async {
    String url = ENDPOINT_SONGS +
        '?page=$page&limit=$count' +
        '&' +
        ENDPOINT_SONG_FILTER;

    // final parsedJson = await _getter(url);
    final parsedJson = MOCK_SONGS["data"];
    List<Song> data = [];
    // debugPrint(url);
    parsedJson.forEach((var item) {
      data.add(Song.fromJson(item));
    });

    return data;
  }

  //! Albums
  Future<Album> fetchAlbumDetails(String id) async {
    String url = ENDPOINT_ALBUMS_DETAIL + '/$id' + '?' + ENDPOINT_ALBUM_FILTER;
    final parsedJson = await _getter(url);
    return Album.fromJson(parsedJson);
  }

  Future<List<Album>> searchAlbums(String albumTitle) async {
    String url =
        ENDPOINT_SEARCH_ALBUMS + albumTitle + '&' + ENDPOINT_ALBUM_FILTER;

    final parsedJson = await _getter(url);
    List<Album> data = [];

    parsedJson.forEach((var item) {
      data.add(Album.fromJson(item));
    });
    return data;
  }

  Future<List<Album>> fetchAlbums(int page, int count) async {
    String url = ENDPOINT_ALBUMS +
        '?page=$page&limit=$count' +
        '&' +
        ENDPOINT_ALBUM_FILTER;

    // final parsedJson = await _getter(url);
    final parsedJson = MOCK_ALBUMS["data"];
    List<Album> data = [];
    // debugPrint(url);
    parsedJson.forEach((var item) {
      data.add(Album.fromJson(item));
    });
    return data;
  }

  Future<List<Song>> fetchAlbumSongs(String albumId) async {
    String url = ENDPOINT_BASE +
        '/listings/albums/$albumId/songs/published' +
        '?' +
        ENDPOINT_SONG_FILTER;

    final parsedJson = await _getter(url);
    List<Song> data = [];
    parsedJson.forEach((var item) {
      data.add(Song.fromJson(item));
    });
    return data;
  }

  //! Playlists
  Future<Playlist> fetchPlaylistDetails(String id) async {
    String url = ENDPOINT_PLAYLISTS_DETAIL + '/$id?' + ENDPOINT_PLAYLIST_FILTER;

    final parsedJson = await _getter(url);
    return Playlist.fromJson(parsedJson);
  }

  Future<List<Song>> fetchPlaylistSongs(String id) async {
    String url =
        ENDPOINT_PLAYLISTS_DETAIL + '/$id/songs' + '?' + ENDPOINT_SONG_FILTER;

    final parsedJson = await _getter(url);
    List<Song> data = [];

    parsedJson.forEach((var item) {
      data.add(Song.fromJson(item));
    });
    return data;
  }

  Future<List<Playlist>> fetchPlayList(int page, int count) async {
    String url = ENDPOINT_PLAYLISTS + '?page=$page&limit=$count';

    // final parsedJson = await _getter(url);
    final parsedJson = MOCK_PLAYLISTS["data"];
    List<Playlist> data = [];
    // debugPrint(url);
    parsedJson.forEach((var item) {
      data.add(Playlist.fromJson(item));
    });
    return data;
  }

  Future<List<Playlist>> searchPlayLists(String playlistTitle) async {
    String url = ENDPOINT_SEARCH_PLAYLISTS + playlistTitle;

    final parsedJson = await _getter(url);
    List<Playlist> data = [];

    parsedJson.forEach((var item) {
      data.add(Playlist.fromJson(item));
    });
    return data;
  }

  //! ARTISTS
  Future<Artist> fetchArtistDetails(String artistId) async {
    String url =
        ENDPOINT_ARTISTS_DETAIL + '/$artistId' + '?' + ENDPOINT_ALBUM_FILTER;

    final parsedJson = await _getter(url);
    return Artist.fromJson(parsedJson);
  }

  Future<List<Song>> fetchArtistSongs(String artistId) async {
    String url = ENDPOINT_BASE +
        '/listings/artists/$artistId/songs/published' +
        '?' +
        ENDPOINT_SONG_FILTER;

    final parsedJson = await _getter(url);
    List<Song> data = [];
    parsedJson.forEach((var item) {
      data.add(Song.fromJson(item));
    });
    return data;
  }

  Future<List<MusicVideo>> fetchArtistMusicVideos(
      String artistId, String musicVideoId) async {
    String url = ENDPOINT_BASE +
        '/listings/artists/$artistId/videos/published' +
        '?_id[ne]=$musicVideoId&' +
        ENDPOINT_MUSIC_VIDEO_FILTER;

    final parsedJson = await _getter(url);
    List<MusicVideo> data = [];
    parsedJson.forEach((var item) {
      data.add(MusicVideo.fromJson(item));
    });
    return data;
  }

  Future<List<Artist>> searchArtist(String artistName) async {
    String url =
        ENDPOINT_SEARCH_ARTISTS + artistName + '&' + ENDPOINT_ARTIST_FILTER;

    final parsedJson = await _getter(url);
    List<Artist> data = [];

    parsedJson.forEach((var item) {
      data.add(Artist.fromJson(item));
    });
    return data;
  }

  Future<List<Album>> fetchArtistAlbums(String artistId) async {
    String url = ENDPOINT_BASE +
        '/listings/artists/$artistId/albums/published' +
        '?' +
        ENDPOINT_ALBUM_FILTER;

    final parsedJson = await _getter(url);
    List<Album> data = [];

    parsedJson.forEach((var item) {
      data.add(Album.fromJson(item));
    });
    return data;
  }

  Future<List<Artist>> fetchArtists(int page, int count) async {
    String url = ENDPOINT_ARTISTS +
        '?page=$page&limit=$count' +
        '&' +
        ENDPOINT_ARTIST_FILTER;

    // final parsedJson = await _getter(url);
    final parsedJson = MOCK_ARTISTS["data"];
    List<Artist> data = [];
    // debugPrint(url);
    parsedJson.forEach((var item) {
      data.add(Artist.fromJson(item));
    });
    return data;
  }

  //! Music Videos
  Future<List<MusicVideo>> searchMusicVideos(String term) async {
    String url =
        ENDPOINT_SEARCH_MUSIC_VIDEOS + term + '&' + ENDPOINT_MUSIC_VIDEO_FILTER;

    final parsedJson = await _getter(url);
    List<MusicVideo> data = [];

    parsedJson.forEach((var item) {
      data.add(MusicVideo.fromJson(item));
    });
    return data;
  }

  Future<MusicVideo> fetchMusicVideoDetails(String id) async {
    String url =
        ENDPOINT_MUSIC_VIDEOS + '/$id' + '?' + ENDPOINT_MUSIC_VIDEO_FILTER;
    final parsedJson = await _getter(url);
    return MusicVideo.fromJson(parsedJson);
  }

  Future<List<MusicVideo>> fetchMusicVideos(int page, int count) async {
    String url = ENDPOINT_MUSIC_VIDEOS +
        '?page=$page&limit=$count' +
        '&' +
        ENDPOINT_MUSIC_VIDEO_FILTER;

    // final parsedJson = await _getter(url);
    final parsedJson = MOCK_VIDEOS["data"];
    List<MusicVideo> data = [];
    // debugPrint(url);
    parsedJson.forEach((var item) {
      data.add(MusicVideo.fromJson(item));
    });
    return data;
  }

  //! AD | News
  Future<List<Announcement>> fetchAnnouncements() async {
    String url = ENDPOINT_ANNOUNCEMENTS;

    // final parsedJson = await _getter(url);
    final parsedJson = MOCK_ADS["data"];
    List<Announcement> data = [];
    // debugPrint(url);
    parsedJson.forEach((var item) {
      data.add(Announcement.fromJson(item));
    });
    return data;
  }

  Future<Announcement> fetchAnnouncementDetails(String id) async {
    String url = ENDPOINT_ANNOUNCEMENTS_DETAIL + '/$id';

    final parsedJson = await _getter(url);
    return Announcement.fromJson(parsedJson);
  }
}

class FetchDataException implements Exception {
  String _message;
  int _code;

  FetchDataException(this._message, this._code);

  String toString() {
    return "Exception: $_message/$_code";
  }

  int code() {
    return _code;
  }
}
