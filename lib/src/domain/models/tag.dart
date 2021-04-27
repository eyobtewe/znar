class MetaTag {
  String sId;
  String title;
  String artist;
  String album;
  // SongImage picture;
  String path;

  MetaTag({
    // this.title,
    this.title,
    this.artist,
    this.path,
    this.album,
    // this.picture,
  });

  MetaTag.fromMap(Map map) {
    title = map["title"];
    artist = map["artist"];
    album = map["album"];
    path = map["path"];
  }
}

// class SongImage {
//   Uint8List image;
//   SongImage.fromMap(Map map) {
//     image = map['Cover (front)']['bitmap'];
//   }
// }
