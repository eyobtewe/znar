// ignore_for_file: constant_identifier_names

const String ENDPOINT_BASE = 'https://api-gedli-tunes.herokuapp.com/api/v1';
// const String ENDPOINT_BASE = 'https://iaamapp.api.iaamrecords.com/api/v1-temp';

// ! listings
const String ENDPOINT_SONGS = '$ENDPOINT_BASE/listings/songs/published';
const String ENDPOINT_ALBUMS = '$ENDPOINT_BASE/listings/albums/published';
const String ENDPOINT_ARTISTS = '$ENDPOINT_BASE/listings/artists/published';
const String ENDPOINT_CHANNELS = '$ENDPOINT_BASE/listings/channels/published';
const String ENDPOINT_PLAYLISTS = '$ENDPOINT_BASE/listings/playlists/published';
const String ENDPOINT_MUSIC_VIDEOS = '$ENDPOINT_BASE/listings/videos/published';
const String ENDPOINT_ANNOUNCEMENTS = '$ENDPOINT_BASE/ad-news/published';

//! listing detail
const String ENDPOINT_SONGS_DETAIL = '$ENDPOINT_BASE/listings/songs';
const String ENDPOINT_ALBUMS_DETAIL = '$ENDPOINT_BASE/listings/albums';
const String ENDPOINT_ARTISTS_DETAIL = '$ENDPOINT_BASE/listings/artists';
const String ENDPOINT_CHANNELS_DETAIL = '$ENDPOINT_BASE/listings/channels';
const String ENDPOINT_PLAYLISTS_DETAIL = '$ENDPOINT_BASE/listings/playlists';
const String ENDPOINT_MUSIC_VIDEOS_DETAIL = '$ENDPOINT_BASE/listings/videos';
const String ENDPOINT_ANNOUNCEMENTS_DETAIL = '$ENDPOINT_BASE/ad-news';

// ! search
const String ENDPOINT_SEARCH_SONGS =
    '$ENDPOINT_BASE/listings/songs/published/search?key=';
const String ENDPOINT_SEARCH_ALBUMS =
    '$ENDPOINT_BASE/listings/albums/published/search?key=';
const String ENDPOINT_SEARCH_ARTISTS =
    '$ENDPOINT_BASE/listings/artists/published/search?key=';
const String ENDPOINT_SEARCH_CHANNELS =
    '$ENDPOINT_BASE/listings/channels/published/search?key=';
const String ENDPOINT_SEARCH_PLAYLISTS =
    '$ENDPOINT_BASE/listings/playlists/published/search?key=';
const String ENDPOINT_SEARCH_MUSIC_VIDEOS =
    '$ENDPOINT_BASE/listings/videos/published/search?key=';

// ! filters
const String ENDPOINT_SONG_FILTER =
    'select=albumStatic,artistStatic,featuredArtists,title,isSingle,releaseDate,fileUrl,coverArt';
const String ENDPOINT_ALBUM_FILTER =
    'select=artistStatic,name,description,releaseDate,albumArt,songs';
const String ENDPOINT_ARTIST_FILTER =
    'select=stageName,firstName,lastName,bio,photo,fullName,coverImage';
const String ENDPOINT_CHANNEL_FILTER = 'select=name,description,photo,banner';
const String ENDPOINT_PLAYLIST_FILTER = 'select=name,featureImage';
const String ENDPOINT_MUSIC_VIDEO_FILTER =
    'select=title,url,description,airedDate,channel,thumbnail,artist,artistStatic';
