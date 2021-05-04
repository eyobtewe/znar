import '../domain/models/models.dart';
import '../infrastructure/repository/repository.dart';
import '../screens/screens.dart';

class ApiBloc {
  String language = 'am';
  // final DynamicLinkService dynamikLinkService = DynamicLinkService();
  final Repository _repository = Repository();

  List<Playlist> localPlaylists;
  List<Playlist> onlinePlaylists;
  List<Artist> artists;
  List<Channel> channels;
  List<MusicVideo> musicVideo;
  List<Album> albums;
  List<Song> songs;
  List<Announcement> announcement;

  Map<String, List<MusicVideo>> channelMusicVideo = {};

  Map<String, List<Song>> playlistSongs = {};

  Map<String, List<Song>> artistSongs = {};

  Map<String, List<Song>> albumsSongs = {};

  Map<String, List<Album>> artistAlbums = {};

  Map<String, List<MusicVideo>> artistMusicVideos = {};

  //! Local storage

  Future<int> addSongToPlaylist(Song song, Playlist playlist) async {
    return await _repository.addSongToPlaylist(song, playlist);
  }

  Future<int> removeSongFromPlaylist(Song song, Playlist playlist) async {
    return await _repository.removeSongFromPlaylist(song, playlist);
  }

  Future<List<Song>> fetchLocalPlaylistSongs(Playlist playlist) async {
    return await _repository.fetchLocalPlaylistSongs(playlist);
  }

  Future<int> addToFavorites(Song song) async {
    return await _repository.addToFavorites(song);
  }

  Future<bool> isInFavorites(Song song) async {
    return await _repository.isInFavorites(song);
  }

  Future<int> removeFromFavorites(Song song) async {
    return await _repository.removeFromFavorites(song);
  }

  Future<int> clearAllPlaylists() async {
    return await _repository.clearAllPlaylists();
  }

  Future<List<Playlist>> fetchLocalPlaylists() async {
    localPlaylists = await _repository.fetchLocalPlaylists();
    return localPlaylists;
  }

  Future<int> removePlaylist(Playlist playlist) async {
    return await _repository.removePlaylist(playlist);
  }

  Future<int> savePlaylist(Playlist playlist) async {
    return await _repository.savePlaylist(playlist);
  }

  //! Channels
  Future<List<Channel>> fetchChannels() async {
    channels = await _repository.fetchChannels();
    return channels;
  }

  Future<List<Channel>> searchChannels(String channelName) async {
    return await _repository.searchChannels(channelName);
  }

  Future<Channel> fetchChannelDetails(String id) async {
    return await _repository.fetchChannelDetails(id);
  }

  Future<List<MusicVideo>> fetchChannelMusicVideos(String id) async {
    channelMusicVideo[id] = await _repository.fetchChannelMusicVideos(id);
    return channelMusicVideo[id];
  }

  //! Songs
  Future<List<Song>> searchSongs(String term) async {
    return await _repository.searchSongs(term);
  }

  Future<Song> fetchSongDetails(String id) async {
    return await _repository.fetchSongDetails(id);
  }

  Future<List<Song>> fetchSongs(int page, int count) async {
    final data = await _repository.fetchSongs(page, count);
    if (page == 1) {
      songs = data;
    } else {
      songs.addAll(data);
    }
    return songs;
  }

  //! Albums
  Future<Album> fetchAlbumDetails(String id) async {
    return await _repository.fetchAlbumDetails(id);
  }

  Future<List<Album>> searchAlbums(String albumTitle) async {
    return await _repository.searchAlbums(albumTitle);
  }

  Future<List<Album>> fetchAlbums(int page, int count) async {
    final data = await _repository.fetchAlbums(page, count);
    if (page == 1) {
      albums = data;
    } else {
      albums.addAll(data);
    }
    return albums;
  }

  Future<List<Song>> fetchAlbumSongs(String albumId) async {
    albumsSongs[albumId] = await _repository.fetchAlbumSongs(albumId);
    return albumsSongs[albumId];
  }

  //! Playlists
  Future<Playlist> fetchPlaylistDetails(String id) async {
    return await _repository.fetchPlaylistDetails(id);
  }

  Future<List<Song>> fetchPlaylistSong(String id) async {
    playlistSongs[id] = await _repository.fetchPlaylistSongs(id);
    return playlistSongs[id];
  }

  Future<List<Song>> fetchLocalSongs(Playlist playlist) async {
    playlistSongs[playlist.sId] =
        await _repository.fetchLocalPlaylistSongs(playlist);
    return playlistSongs[playlist.sId];
  }

  Future<List<Playlist>> fetchOnlinePlayList(int page, int count) async {
    final data = await _repository.fetchOnlinePlayList(page, count);
    if (page == 1) {
      onlinePlaylists = data;
    } else {
      onlinePlaylists.addAll(data);
    }
    return onlinePlaylists;
  }

  Future<List<Playlist>> searchPlayLists(String playlistTitle) async {
    return await _repository.searchPlayLists(playlistTitle);
  }

  //! ARTISTS
  Future<Artist> fetchArtistDetails(String artistId) async {
    return await _repository.fetchArtistDetails(artistId);
  }

  Future<List<Song>> fetchArtistSongs(String artistId) async {
    artistSongs[artistId] = await _repository.fetchArtistSongs(artistId);
    return artistSongs[artistId];
  }

  Future<List<MusicVideo>> fetchArtistMusicVideos(
      String artistId, String musicVideoId) async {
    artistMusicVideos[artistId] =
        await _repository.fetchArtistMusicVideos(artistId, musicVideoId);
    return artistMusicVideos[artistId];
  }

  Future<List<Artist>> searchArtist(String artistName) async {
    return await _repository.searchArtist(artistName);
  }

  Future<List<Album>> fetchArtistAlbums(String artistId) async {
    artistAlbums[artistId] = await _repository.fetchArtistAlbums(artistId);
    return artistAlbums[artistId];
  }

  Future<List<Artist>> fetchArtists(int page, int count) async {
    final data = await _repository.fetchArtists(page, count);
    if (page == 1) {
      artists = data;
    } else {
      artists.addAll(data);
    }
    return artists;
  }

  //! Music Videos
  Future<List<MusicVideo>> searchMusicVideos(String term) async {
    return await _repository.searchMusicVideos(term);
  }

  Future<MusicVideo> fetchMusicVideoDetails(String id) async {
    return await _repository.fetchMusicVideoDetails(id);
  }

  Future<List<MusicVideo>> fetchMusicVideos(int page, int count) async {
    final data = await _repository.fetchMusicVideos(page, count);
    if (page == 1) {
      musicVideo = data;
    } else {
      musicVideo.addAll(data);
    }
    return musicVideo;
  }

  //! AD | News
  Future<List<Announcement>> fetchAnnouncements() async {
    announcement = await _repository.fetchAnnouncements();
    return announcement;
  }

  Future<Announcement> fetchAnnouncementDetails(String id) async {
    return await _repository.fetchAnnouncementDetails(id);
  }

  //! Shortcuts
  List<dynamic> buildInitialData(CustomAspectRatio ar) {
    switch (ar) {
      case CustomAspectRatio.ALBUM:
        return albums;
      case CustomAspectRatio.ARTIST:
        return artists;
      case CustomAspectRatio.PLAYLIST:
        return onlinePlaylists;
      case CustomAspectRatio.CHANNEL:
        return channels;
      case CustomAspectRatio.VIDEO:
        return musicVideo;
      case CustomAspectRatio.SONG:
        return songs;
      default:
        return announcement;
    }
  }

  Future<List<dynamic>> buildFutures(CustomAspectRatio ar) async {
    switch (ar) {
      case CustomAspectRatio.ALBUM:
        return fetchAlbums(1, 7);
      case CustomAspectRatio.ARTIST:
        return fetchArtists(1, 7);
      case CustomAspectRatio.PLAYLIST:
        return fetchOnlinePlayList(1, 7);
      case CustomAspectRatio.CHANNEL:
        return fetchChannels();
      case CustomAspectRatio.VIDEO:
        return fetchMusicVideos(1, 7);
      case CustomAspectRatio.SONG:
        return fetchSongs(1, 7);
      default:
        return fetchAnnouncements();
    }
  }

  Future fetchAll() async {
    // Future.wait([
    // fetchAlbums(1, 7);
    // fetchArtists(1, 7);
    fetchOnlinePlayList(1, 7);
    // fetchChannels();
    // fetchMusicVideos(1, 7);
    fetchSongs(1, 7);
    // fetchAnnouncements();
    // ]);
  }
}
