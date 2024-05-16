class NobetciEczane {
  int? pharmacyID;
  String? pharmacyName;
  String? address;
  String? city;
  String? district;
  String? town;
  String? directions;
  String? phone;
  String? pharmacyDutyStart;
  String? pharmacyDutyEnd;
  double? latitude;
  double? longitude;
  int? distanceMt;
  double? distanceKm;

  NobetciEczane(
      {this.pharmacyID,
      this.pharmacyName,
      this.address,
      this.city,
      this.district,
      this.town,
      this.directions,
      this.phone,
      this.pharmacyDutyStart,
      this.pharmacyDutyEnd,
      this.latitude,
      this.longitude,
      this.distanceMt,
      this.distanceKm});

  NobetciEczane.fromJson(Map<String, dynamic> json) {
    pharmacyID = json['pharmacyID'];
    pharmacyName = json['pharmacyName'];
    address = json['address'];
    city = json['city'];
    district = json['district'];
    town = json['town'];
    directions = json['directions'];
    phone = json['phone'];
    pharmacyDutyStart = json['pharmacyDutyStart'];
    pharmacyDutyEnd = json['pharmacyDutyEnd'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distanceMt = json['distanceMt'];
    distanceKm = json['distanceKm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pharmacyID'] = pharmacyID;
    data['pharmacyName'] = pharmacyName;
    data['address'] = address;
    data['city'] = city;
    data['district'] = district;
    data['town'] = town;
    data['directions'] = directions;
    data['phone'] = phone;
    data['pharmacyDutyStart'] = pharmacyDutyStart;
    data['pharmacyDutyEnd'] = pharmacyDutyEnd;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distanceMt'] = distanceMt;
    data['distanceKm'] = distanceKm;
    return data;
  }
}
