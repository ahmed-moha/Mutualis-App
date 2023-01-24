class AmbulanceModel {
  int? id;
  String? nom;
  String? telephone;
  String? photo;
  String? matriculation;
  String? adresse;
  String? createdAt;
  String? updatedAt;

  AmbulanceModel(
      {this.id,
      this.nom,
      this.telephone,
      this.photo,
      this.matriculation,
      this.adresse,
      this.createdAt,
      this.updatedAt});

  AmbulanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    telephone = json['telephone'];
    photo = json['photo']==""?"https://craftsnippets.com/articles_images/placeholder/placeholder.jpg":json['photo'] ?? "https://craftsnippets.com/articles_images/placeholder/placeholder.jpg";
    matriculation = json['matriculation'];
    adresse = json['adresse'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['telephone'] = telephone;
    data['photo'] = photo;
    data['matriculation'] = matriculation;
    data['adresse'] = adresse;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
