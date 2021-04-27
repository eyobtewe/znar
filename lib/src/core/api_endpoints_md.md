<!--  -->

BASE_URL: http://13.235.149.233:3939/api/v1

# Listings

## Songs

<!-- Songs -->
<!-- get published songs -->

> GET: BASE_URL/listings/songs/published
> RES: [songs]
> Desc: returns list of songs

<!-- get published songs by artist -->

> GET: BASE_URL/listings/artists/<artistId>/songs/published
> RES: [songs]
> Desc: returns list of songs of an artists

<!-- get published songs by album -->

> GET: BASE_URL/listings/albums/<albumId>/songs/published
> RES: [songs]
> Desc: returns list of songs of an album

<!-- search published songs -->

> GET: BASE_URL/listings/songs/published/search?key=<value>
> RES: [songs]
> Desc: returns list of songs by search value

<!-- get details of a song -->

> GET: BASE_URL/listings/songs/<id>
> RES: {song}
> Desc: returns song details

## Albums

<!-- Albums -->
<!-- get published albums -->

> GET: BASE_URL/listings/albums/published
> RES: [albums]
> Desc: returns list of albums

<!-- get published albums by artist -->

> GET: BASE_URL/listings/artists/<artistId>/albums/published
> RES: [albums]
> Desc: returns list of albums of an artists

<!-- search published albums -->

> GET: BASE_URL/listings/albums/published/search?key=<value>
> RES: [albums]
> Desc: returns list of albums by search value

<!-- get details of an album -->

> GET: BASE_URL/listings/albums/<id>
> RES: {album}
> Desc: returns album details

## Playlists

<!-- Playlists -->
<!-- get published playlists -->

> GET: BASE_URL/listings/playlists/published
> RES: [playlists]
> Desc: returns list of playlists

<!-- search published playlists -->

> GET: BASE_URL/listings/playlists/published/search?key=<value>
> RES: [playlists]
> Desc: returns list of playlists by search value

<!-- get details of an playlist -->

> GET: BASE_URL/listings/playlists/<id>
> RES: {playlist}
> Desc: returns playlist details

## Videos

<!-- Videos -->
<!-- get published videos -->

> GET: BASE_URL/listings/videos/published
> RES: [videos]
> Desc: returns list of videos

<!-- get published videos by artist -->

> GET: BASE_URL/listings/artists/<artistId>/videos/published
> RES: [videos]
> Desc: returns list of videos of an artists

<!-- get published videos by channel -->

> GET: BASE_URL/listings/channels/<channelId>/videos/published
> RES: [videos]
> Desc: returns list of videos of a channel

<!-- search published videos -->

> GET: BASE_URL/listings/videos/published/search?key=<value>
> RES: [videos]
> Desc: returns list of videos by search value

<!-- get details of a video -->

> GET: BASE_URL/listings/videos/<id>
> RES: {video}
> Desc: returns video details

## Channels

<!-- Channels -->
<!-- get published channels -->

> GET: BASE_URL/listings/channels/published
> RES: [channels]
> Desc: returns list of channels

<!-- search published channels -->

> GET: BASE_URL/listings/channels/published/search?key=<value>
> RES: [channels]
> Desc: returns list of channels by search value

<!-- get details of a channel -->

> GET: BASE_URL/listings/channels/<id>
> RES: {channel}
> Desc: returns channel details

## Artists

<!-- Artists -->
<!-- get published artists -->

> GET: BASE_URL/listings/artists/published
> RES: [artists]
> Desc: returns list of artists

<!-- get published songs by artist -->

> GET: BASE_URL/listings/artists/<artistId>/songs/published
> RES: [songs]
> Desc: returns list of songs of an artist

<!-- get published videos by artist -->

> GET: BASE_URL/listings/artists/<artistId>/videos/published
> RES: [videos]
> Desc: returns list of videos of an artist

QUERY BY FIELD
field[operator]=value
operator: gt,gte,lt,lte,ne,eq,in

<!-- search published artists -->

> GET: BASE_URL/listings/artists/published/search?key=<value>
> RES: [artists]
> Desc: returns list of artists by search value

<!-- get details of an artist -->

> GET: BASE_URL/listings/artists/<id>
> RES: {artist}
> Desc: returns artist details

# AdNewses

<!-- AdNewses -->
<!-- get published ad-news -->

> GET: BASE_URL/listings/ad-news/published
> RES: [ad-news]
> Desc: returns list of ad-news

<!-- get published ads only -->

> GET: BASE_URL/listings/ad-news/published/ads
> RES: [ads]
> Desc: returns list of ads

<!-- get published news only -->

> GET: BASE_URL/listings/ad-news/published/news
> RES: [news]
> Desc: returns list of news

<!-- get details of an ad-news -->

> GET: BASE_URL/listings/ad-news/<id>
> RES: {ad-news}
> Desc: returns ad-news details
