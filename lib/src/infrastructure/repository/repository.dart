import '../../domain/models/models.dart';
import '../database/local_playlist.dart';
import '../services/services.dart';

class Repository {
  final LocalPlaylist _localPlaylist = LocalPlaylist();
  final MusicApiService _musicApiService = MusicApiService();

  //! Local storage

  Future<int> addSongToPlaylist(Song song, Playlist playlist) async {
    return await _localPlaylist.addSongToPlaylist(song, playlist);
  }

  Future<int> removeSongFromPlaylist(Song song, Playlist playlist) async {
    return await _localPlaylist.removeSongFromPlaylist(song, playlist);
  }

  Future<List<Song>> fetchLocalPlaylistSongs(Playlist playlist) async {
    return await _localPlaylist.fetchSongs(playlist);
  }

  Future<int> addToFavorites(Song song) async {
    return await _localPlaylist.addToFavorites(song);
  }

  Future<bool> isInFavorites(Song song) async {
    return await _localPlaylist.isInFavorites(song);
  }

  Future<int> removeFromFavorites(Song song) async {
    return await _localPlaylist.removeFromFavorites(song);
  }

  Future<int> clearAllPlaylists() async {
    return await _localPlaylist.clearAllPlaylists();
  }

  Future<List<Playlist>> fetchLocalPlaylists() async {
    return await _localPlaylist.fetchPlaylists();
  }

  Future<int> removePlaylist(Playlist playlist) async {
    return await _localPlaylist.removePlaylist(playlist);
  }

  Future<int> savePlaylist(Playlist playlist) async {
    return await _localPlaylist.createPlaylist(playlist);
  }

  //! Channels
  Future<List<Channel>> fetchChannels() async {
    return await _musicApiService.fetchChannels();
  }

  Future<List<Channel>> searchChannels(String channelName) async {
    return await _musicApiService.searchChannels(channelName);
  }

  Future<Channel> fetchChannelDetails(String id) async {
    return await _musicApiService.fetchChannelDetails(id);
  }

  Future<List<MusicVideo>> fetchChannelMusicVideos(String id) async {
    return await _musicApiService.fetchChannelMusicVideos(id);
  }

  //! Songs
  Future<List<Song>> searchSongs(String term) async {
    return await _musicApiService.searchSongs(term);
  }

  Future<Song> fetchSongDetails(String id) async {
    return await _musicApiService.fetchSongDetails(id);
  }

  Future<List<Song>> fetchSongs(int page, int count) async {
    return await _musicApiService.fetchSongs(page, count);
  }

  //! Albums
  Future<Album> fetchAlbumDetails(String id) async {
    return await _musicApiService.fetchAlbumDetails(id);
  }

  Future<List<Album>> searchAlbums(String albumTitle) async {
    return await _musicApiService.searchAlbums(albumTitle);
  }

  Future<List<Album>> fetchAlbums(int page, int count) async {
    return await _musicApiService.fetchAlbums(page, count);
  }

  Future<List<Song>> fetchAlbumSongs(String albumId) async {
    return await _musicApiService.fetchAlbumSongs(albumId);
  }

  //! Playlists
  Future<Playlist> fetchPlaylistDetails(String id) async {
    return await _musicApiService.fetchPlaylistDetails(id);
  }

  Future<List<Song>> fetchPlaylistSongs(String id) async {
    return await _musicApiService.fetchPlaylistSongs(id);
  }

  Future<List<Playlist>> fetchOnlinePlayList(int page, int count) async {
    return await _musicApiService.fetchPlayList(page, count);
  }

  Future<List<Playlist>> searchPlayLists(String playlistTitle) async {
    return await _musicApiService.searchPlayLists(playlistTitle);
  }

  //! ARTISTS
  Future<Artist> fetchArtistDetails(String artistId) async {
    return await _musicApiService.fetchArtistDetails(artistId);
  }

  Future<List<Song>> fetchArtistSongs(String artistId) async {
    return await _musicApiService.fetchArtistSongs(artistId);
  }

  Future<List<MusicVideo>> fetchArtistMusicVideos(String artistId, String musicVideoId) async {
    return await _musicApiService.fetchArtistMusicVideos(artistId, musicVideoId);
  }

  Future<List<Artist>> searchArtist(String artistName) async {
    return await _musicApiService.searchArtist(artistName);
  }

  Future<List<Album>> fetchArtistAlbums(String artistId) async {
    return await _musicApiService.fetchArtistAlbums(artistId);
  }

  Future<List<Artist>> fetchArtists(int page, int count) async {
    return await _musicApiService.fetchArtists(page, count);
  }

  //! Music Videos
  Future<List<MusicVideo>> searchMusicVideos(String term) async {
    return await _musicApiService.searchMusicVideos(term);
  }

  Future<MusicVideo> fetchMusicVideoDetails(String id) async {
    return await _musicApiService.fetchMusicVideoDetails(id);
  }

  Future<List<MusicVideo>> fetchMusicVideos(int page, int count) async {
    return await _musicApiService.fetchMusicVideos(page, count);
  }

  //! AD | News
  Future<List<Announcement>> fetchAnnouncements() async {
    return await _musicApiService.fetchAnnouncements();
  }

  Future<Announcement> fetchAnnouncementDetails(String id) async {
    return await _musicApiService.fetchAnnouncementDetails(id);
  }
}
