// ignore: camel_case_types
class HastaneModel {
  int? id;
  String? name;
  String? description;
  String? address;
  String? phone;
  String? email;
  String? website;
  String? city;
  String? district;
  double? latitude;
  double? longitude;
  int? distanceMt;
  double? distanceKm;
  double? distanceMil;

  HastaneModel(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.phone,
      this.email,
      this.website,
      this.city,
      this.district,
      this.latitude,
      this.longitude,
      this.distanceMt,
      this.distanceKm,
      this.distanceMil});

  HastaneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    city = json['city'];
    district = json['district'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distanceMt = json['distanceMt'];
    distanceKm = json['distanceKm'];
    distanceMil = json['distanceMil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['website'] = website;
    data['city'] = city;
    data['district'] = district;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distanceMt'] = distanceMt;
    data['distanceKm'] = distanceKm;
    data['distanceMil'] = distanceMil;
    return data;
  }
}
