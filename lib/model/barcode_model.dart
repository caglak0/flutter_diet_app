class BarcodeModel {
  FoodId? foodId;

  BarcodeModel({this.foodId});

  BarcodeModel.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'] != null ? FoodId.fromJson(json['food_id']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foodId != null) {
      data['food_id'] = foodId!.toJson();
    }
    return data;
  }
}

class FoodId {
  String? value;

  FoodId({this.value});

  FoodId.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}
