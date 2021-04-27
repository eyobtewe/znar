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
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.albumStatic != null) {
      data['albumStatic'] = this.albumStatic.toJson();
    }
    if (this.artistStatic != null) {
      data['artistStatic'] = this.artistStatic.toJson();
    }
    if (this.featuredArtists != null) {
      data['featuredArtists'] = this.featuredArtists.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['isSingle'] = this.isSingle;
    data['releaseDate'] = this.releaseDate;
    data['fileUrl'] = this.fileUrl;
    data['filePath'] = this.filePath;
    data['coverArt'] = this.coverArt;
    return data;
  }
}
