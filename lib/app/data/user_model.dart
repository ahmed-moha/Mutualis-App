class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? taille;
  String? birthdate;
  String? profession;
  String? about;
  String? profilImage;
  String? coverImage;
  String? emailVerifiedAt;
  int? verified;
  int? doctorCategoryId;
  String? createdAt;
  String? updatedAt;
  String? uid;

  String? photoUrl;
  bool? isDoctor;
  bool? isAdmin;

  int? state;
  String? lastSeen;
  String? fcmToken;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.taille,
      this.birthdate,
      this.profession,
      this.about,
      this.profilImage,
      this.coverImage,
      this.emailVerifiedAt,
      this.verified,
      this.doctorCategoryId,
      this.createdAt,
      this.updatedAt,
      this.uid,
      this.photoUrl,
      this.isDoctor,
      this.isAdmin,
      this.state,
      this.lastSeen,
      this.fcmToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    taille = json['taille'];
    birthdate = json['birthdate'];
    profession = json['profession'];
    about = json['about'];
    profilImage = json['profil_image'];
    coverImage = json['cover_image'];
    emailVerifiedAt = json['email_verified_at'];
    verified = json['verified'];
    doctorCategoryId = json['doctor_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uid = json['uid'];

    photoUrl = json['photoUrl'];
    isDoctor = json['isDoctor'];
    isAdmin = json['isAdmin'];

    state = json['state'];
    lastSeen = json['lastSeen'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['taille'] = taille;
    data['birthdate'] = birthdate;
    data['profession'] = profession;
    data['about'] = about;
    data['profil_image'] = profilImage;
    data['cover_image'] = coverImage;
    data['email_verified_at'] = emailVerifiedAt;
    data['verified'] = verified;
    data['doctor_category_id'] = doctorCategoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['uid'] = uid;

    data['photoUrl'] = photoUrl;
    data['isDoctor'] = isDoctor;
    data['isAdmin'] = isAdmin;

    data['state'] = state;
    data['lastSeen'] = lastSeen;
    data['fcmToken'] = fcmToken;
    return data;
  }
}
