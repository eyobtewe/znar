import 'models.dart';

class MusicVideo {
  Artist artistStatic;
  String sId;
  String title;
  String url;
  Channel channel;
  String thumbnail;
  String artist;

  MusicVideo({
    this.artistStatic,
    this.sId,
    this.title,
    this.url,
    this.channel,
    this.thumbnail,
    this.artist,
  });

  MusicVideo.fromJson(Map<String, dynamic> json) {
    artistStatic = json['artistStatic'] != null ? Artist.fromJson(json['artistStatic']) : null;
    sId = json['_id'];
    title = json['title'] ?? '';
    url = json['url'] ?? '';
    channel = json['channel'] != null
        ? (json['channel'].runtimeType == String
            ? Channel(sId: json['channel'].toString())
            : Channel.fromJson(json['channel']))
        : null;
    thumbnail = json['thumbnail'] ?? '';
    artist = json['artist'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.artistStatic != null) {
      data['artistStatic'] = this.artistStatic.toJson();
    }
    if (this.channel != null) {
      data['channel'] = this.channel.toJson();
    }
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['url'] = this.url;
    data['channel'] = this.channel;
    data['thumbnail'] = this.thumbnail;
    data['artist'] = this.artist;
    return data;
  }
}
