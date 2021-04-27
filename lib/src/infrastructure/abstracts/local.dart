import '../../domain/models/models.dart';

abstract class LocalStorage {
  Future<int> createPlaylist(Playlist playlist);
  Future<int> clearAllPlaylists();

  Future<List<Playlist>> fetchPlaylists();
  Future<List<Song>> fetchSongs(Playlist playlist);
  Future<int> removePlaylist(Playlist playlist);

  Future<int> addToFavorites(Song song);
  Future<int> removeFromFavorites(Song song);
  Future<bool> isInFavorites(Song song);

  Future<int> addSongToPlaylist(Song song, Playlist playlist);
  Future<int> removeSongFromPlaylist(Song song, Playlist playlist);

  // Future<List<Song>> fetchDownloadedSongsDetails(List<String> ids);
  // Future<int> saveDownloadedSong(Song song);
}
