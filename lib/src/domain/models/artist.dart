class Artist {
  String sId;
  String stageName;
  String firstName;
  String lastName;
  String bio;
  String photo;
  String coverImage;
  String fullName;

  Artist({
    this.sId,
    this.stageName,
    this.firstName,
    this.lastName,
    this.bio,
    this.coverImage,
    this.photo,
    this.fullName,
  });

  Artist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    stageName = json['stageName'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    bio = json['bio'] ?? '';
    photo = json['photo'] ?? '';
    coverImage = json['coverImage'] ?? '';
    fullName = json['fullName'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['stageName'] = stageName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['bio'] = bio;
    data['coverImage'] = coverImage;
    data['photo'] = photo;
    data['fullName'] = fullName;
    return data;
  }
}
