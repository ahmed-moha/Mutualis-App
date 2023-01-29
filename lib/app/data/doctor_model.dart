class DoctorModel {
  String? description;
  bool? isAdmin;
  String? type;
  int? createdAt;
  String? uid;
  String? photoUrl;
  String? email;
  String? name;
  int? id;
  String? fcmToken;
  int? state;
  int? lastSeen;
  String? phone;

  DoctorModel(
      {this.description,
      this.isAdmin,
      this.type,
      this.createdAt,
      this.uid,
      this.photoUrl,
      this.email,
      this.name,
      this.id,
      this.fcmToken,
      this.state,
      this.lastSeen,this.phone});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    phone=json['phone']??"";
    isAdmin = json['isAdmin'];
    type = json['type'];
    createdAt = int.parse(json['createdAt'].toString());
    uid = json['uid'];
    photoUrl = json['photoUrl'];
    email = json['email'];
    name = json['name'];
    id = int.parse(json['id'].toString());
    fcmToken = json['fcmToken'];
    state = int.parse(json['state'].toString());
    lastSeen = int.parse(json['lastSeen'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['isAdmin'] = isAdmin;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['uid'] = uid;
    data[' photoUrl'] = photoUrl;
    data['email'] = email;
    data['name'] = name;
    data['id'] = id;
    data['fcmToken'] = fcmToken;
    data['state'] = state;
    data['last_seen'] = lastSeen;
    data['phone']=phone;
    return data;
  }
}
