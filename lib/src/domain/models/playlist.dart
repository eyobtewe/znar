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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['isLocal'] = this.isLocal;
    data['featureImage'] = this.featureImage ?? '';
    data['count'] = this.count ?? '';
    return data;
  }
}
