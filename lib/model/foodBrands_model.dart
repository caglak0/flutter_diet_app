class FoodBrandsModel {
  FoodBrands? foodBrands;

  FoodBrandsModel({this.foodBrands});

  FoodBrandsModel.fromJson(Map<String, dynamic> json) {
    foodBrands = json['food_brands'] != null ? FoodBrands.fromJson(json['food_brands']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foodBrands != null) {
      data['food_brands'] = foodBrands!.toJson();
    }
    return data;
  }
}

class FoodBrands {
  List<String>? foodBrand;

  FoodBrands({this.foodBrand});

  FoodBrands.fromJson(Map<String, dynamic> json) {
    foodBrand = json['food_brand'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_brand'] = foodBrand;
    return data;
  }
}
