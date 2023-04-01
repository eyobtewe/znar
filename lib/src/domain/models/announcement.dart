class Announcement {
  String sId;
  String title;
  String description;
  String type;
  String moreInfoLink;
  String targetType;
  String targetId;
  String contentImage;
  String featureImage;

  Announcement(
      {this.sId,
      this.title,
      this.description,
      this.type,
      this.moreInfoLink,
      this.targetType,
      this.targetId,
      this.contentImage,
      this.featureImage});

  Announcement.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title']??'';
    description = json['description']??'';
    type = json['type']??'';
    moreInfoLink = json['moreInfoLink']??'';
    targetType = json['targetType']??'';
    targetId = json['targetId']??'';
    contentImage = json['contentImage']??'';
    featureImage = json['featureImage']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['moreInfoLink'] = moreInfoLink;
    data['targetType'] = targetType;
    data['targetId'] = targetId;
    data['contentImage'] = contentImage;
    data['featureImage'] = featureImage;
    return data;
  }
}
