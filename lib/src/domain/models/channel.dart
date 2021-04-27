class Channel {
  String sId;
  String name;
  String description;
  String photo;
  String banner;

  Channel({
    this.sId,
    this.name,
    this.description,
    this.photo,
    this.banner,
  });

  Channel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    photo = json['photo'] ?? '';
    banner = json['banner'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['banner'] = this.banner;
    return data;
  }
}
