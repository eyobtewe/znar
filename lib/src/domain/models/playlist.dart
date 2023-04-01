class Playlist {
  String sId;
  String name;
  String featureImage;
  String count;
  bool isLocal;

  Playlist({this.sId, this.name, this.featureImage, this.isLocal});

  Playlist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] ?? 'Playlist';
    isLocal = json['isLocal'] ?? false;
    featureImage = json['featureImage'] ?? '';
    count = json['count'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['isLocal'] = isLocal;
    data['featureImage'] = featureImage ?? '';
    data['count'] = count ?? '';
    return data;
  }
}
