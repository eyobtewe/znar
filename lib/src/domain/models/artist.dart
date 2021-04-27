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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['stageName'] = this.stageName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['bio'] = this.bio;
    data['coverImage'] = this.coverImage;
    data['photo'] = this.photo;
    data['fullName'] = this.fullName;
    return data;
  }
}
