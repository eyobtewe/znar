import '../../domain/models/models.dart';

abstract class Api {
  //! Channels
  Future<List<Channel>> fetchChannels();
  Future<List<Channel>> searchChannels(String channelName);
  Future<Channel> fetchChannelDetails(String id);
  Future<List<MusicVideo>> fetchChannelMusicVideos(String id);

  //! Songs
  Future<List<Song>> searchSongs(String term);
  Future<Song> fetchSongDetails(String id);
  // Future<List<Song>> fetchNewSongs(int page);
  Future<List<Song>> fetchSongs(int page, int count);

  //! Albums
  Future<Album> fetchAlbumDetails(String id);
  // Future<List<Album>> fetchNewAlbums(int page);
  Future<List<Album>> searchAlbums(String albumTitle);
  Future<List<Album>> fetchAlbums(int page, int count);
  Future<List<Song>> fetchAlbumSongs(String albumId);

  //! Playlists
  Future<List<Song>> fetchPlaylistSongs(String id);
  Future<Playlist> fetchPlaylistDetails(String id);
  // Future<Playlist> createPlaylist(Playlist playlist, String uid);
  Future<List<Playlist>> fetchPlayList(int page, int count);
  Future<List<Playlist>> searchPlayLists(String playlistTitle);

  //! ARTISTS
  Future<Artist> fetchArtistDetails(String artistId);
  Future<List<Song>> fetchArtistSongs(String artistId);
  Future<List<MusicVideo>> fetchArtistMusicVideos(String artistId, String musicVideoId);
  Future<List<Artist>> searchArtist(String artistName);
  Future<List<Album>> fetchArtistAlbums(String artistId);
  // Future<List<Artist>> fetchNewArtists(int page);
  Future<List<Artist>> fetchArtists(int page, int count);

  //! Music Videos
  Future<List<MusicVideo>> searchMusicVideos(String term);
  Future<MusicVideo> fetchMusicVideoDetails(String id);
  // Future<List<MusicVideo>> fetchNewMusicVideos(int page);
  Future<List<MusicVideo>> fetchMusicVideos(int page, int count);

  // Future<List<Genre>> fetchGenres(int page);
  // Future<MusicVideo> fetchGenresDetails(String id);

  //! AD | News
  Future<List<Announcement>> fetchAnnouncements();
  Future<Announcement> fetchAnnouncementDetails(String id);
}
