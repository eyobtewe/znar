import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

// import 'package:dart_tags/dart_tags.dart';

class DownloadedSong {
  String sId;
  String path;
  String title;
  String artist;
  String album;
  Uint8List image;

  DownloadedSong({
    this.sId,
    this.title,
    this.artist,
    this.path,
    this.album,
  });

  DownloadedSong.fromMap(Map map) {
    title = map['title'] ?? '';
    artist = map['artist'] ?? '';
    album = map['album'] ?? '';
    sId = const Uuid().v4();

    // if (map["picture"] != null) {
    //   AttachedPicture ap;

    //   ap = map["picture"]["Cover (front)"];
    //   image = Uint8List.fromList(ap.imageData);
    // }
  }

  @override
  String toString() {
    return '''
\t\tsId: $sId,
\t\ttitle: $title,
\t\tartist: $artist,
\t\talbum: $album,
\t\tpath: $path,
\t\timage: $image,
''';
  }
}

// const List<String> picturesType = [
//   'Cover (front)',
//   'Other',
//   '32x32 pixels "file icon" (PNG only)',
//   'Other file icon',
//   'Cover (back)',
//   'Leaflet page',
//   'Media (e.g. lable side of CD)',
//   'Lead artist/lead performer/soloist',
//   'Artist/performer',
//   'Conductor',
//   'Band/Orchestra',
//   'Composer',
//   'Lyricist/text writer',
//   'Recording Location',
//   'During recording',
//   'During performance',
//   'Movie/video screen capture',
//   'A bright coloured fish',
//   'Illustration',
//   'Band/artist logotype',
//   'Publisher/Studio logotype',
// ];
