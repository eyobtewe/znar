import 'models.dart';

class Song {
  Album albumStatic;
  Artist artistStatic;
  List<Artist> featuredArtists;
  String sId;
  String title;
  bool isSingle;
  String releaseDate;
  String fileUrl;
  String filePath;
  String coverArt;

  Song({
    this.albumStatic,
    this.artistStatic,
    this.featuredArtists,
    this.sId,
    this.title,
    this.isSingle,
    this.releaseDate,
    this.fileUrl,
    this.filePath,
    this.coverArt,
  });

  Song.fromJson(Map<String, dynamic> json) {
    albumStatic = json['albumStatic'] != null ? Album.fromJson(json['albumStatic']) : null;
    artistStatic = json['artistStatic'] != null ? Artist.fromJson(json['artistStatic']) : null;
    if (json['featuredArtists'] != null) {
      featuredArtists = <Artist>[];
      json['featuredArtists'].forEach((v) {
        featuredArtists.add(Artist.fromJson(v));
      });
    }
    sId = json['_id'] ?? '';
    title = json['title'] ?? '';
    isSingle = json['isSingle'];
    releaseDate = json['releaseDate'] ?? '';
    fileUrl = json['fileUrl'] ?? '';
    filePath = json['filePath'] ?? '';
    coverArt = json['coverArt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (albumStatic != null) {
      data['albumStatic'] = albumStatic.toJson();
    }
    if (artistStatic != null) {
      data['artistStatic'] = artistStatic.toJson();
    }
    if (featuredArtists != null) {
      data['featuredArtists'] = featuredArtists.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['title'] = title;
    data['isSingle'] = isSingle;
    data['releaseDate'] = releaseDate;
    data['fileUrl'] = fileUrl;
    data['filePath'] = filePath;
    data['coverArt'] = coverArt;
    return data;
  }
}
