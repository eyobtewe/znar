import 'models.dart';

class Album {
  Artist artistStatic;
  String sId;
  String name;
  Artist artist;
  String releaseDate;
  String SongArtwork;

  Album({
    this.artistStatic,
    this.sId,
    this.name,
    this.artist,
    this.releaseDate,
    this.SongArtwork,
  });

  Album.fromJson(Map<String, dynamic> json) {
    artistStatic = json['artistStatic'] != null
        ? Artist.fromJson(json['artistStatic'])
        : null;
    sId = json['_id'] ?? '';
    name = json['name'] ?? '';
    artist = json['artist'] != null
        ? (json['artist'].runtimeType == String
            ? Artist(sId: json['artist'].toString())
            : Artist.fromJson(json['artist']))
        : null;
    releaseDate = json['releaseDate'] ?? '';
    SongArtwork = json['SongArtwork'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.artistStatic != null) {
      data['artistStatic'] = this.artistStatic.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['artist'] = this.artist;
    data['releaseDate'] = this.releaseDate;
    data['SongArtwork'] = this.SongArtwork;
    return data;
  }
}
