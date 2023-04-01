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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artistStatic != null) {
      data['artistStatic'] = artistStatic.toJson();
    }
    if (channel != null) {
      data['channel'] = channel.toJson();
    }
    data['_id'] = sId;
    data['title'] = title;
    data['url'] = url;
    data['channel'] = channel;
    data['thumbnail'] = thumbnail;
    data['artist'] = artist;
    return data;
  }
}
