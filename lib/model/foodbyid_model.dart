class FoodByID {
  Yemek? food;

  FoodByID({this.food});

  FoodByID.fromJson(Map<String, dynamic> json) {
    food = json['food'] != null ? Yemek.fromJson(json['food']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (food != null) {
      data['food'] = food!.toJson();
    }
    return data;
  }
}

class Yemek {
  String? foodId;
  String? foodName;
  String? foodType;
  String? foodUrl;
  Servings? servings;

  Yemek({this.foodId, this.foodName, this.foodType, this.foodUrl, this.servings});

  Yemek.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    foodType = json['food_type'];
    foodUrl = json['food_url'];
    servings = json['servings'] != null ? Servings.fromJson(json['servings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_id'] = foodId;
    data['food_name'] = foodName;
    data['food_type'] = foodType;
    data['food_url'] = foodUrl;
    if (servings != null) {
      data['servings'] = servings!.toJson();
    }
    return data;
  }
}

class Servings {
  List<Serving>? serving;

  Servings({this.serving});

  Servings.fromJson(Map<String, dynamic> json) {
    if (json['serving'] != null) {
      serving = <Serving>[];
      json['serving'].forEach((v) {
        serving!.add(Serving.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serving != null) {
      data['serving'] = serving!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Serving {
  String? servingId;
  String? servingDescription;
  String? servingUrl;
  String? metricServingAmount;
  String? metricServingUnit;
  String? numberOfUnits;
  String? measurementDescription;
  String? calories;
  String? carbohydrate;
  String? protein;
  String? fat;
  String? saturatedFat;
  String? polyunsaturatedFat;
  String? monounsaturatedFat;
  String? cholesterol;
  String? sodium;
  String? potassium;
  String? fiber;
  String? sugar;
  String? vitaminA;
  String? vitaminC;
  String? calcium;
  String? iron;

  Serving(
      {this.servingId,
      this.servingDescription,
      this.servingUrl,
      this.metricServingAmount,
      this.metricServingUnit,
      this.numberOfUnits,
      this.measurementDescription,
      this.calories,
      this.carbohydrate,
      this.protein,
      this.fat,
      this.saturatedFat,
      this.polyunsaturatedFat,
      this.monounsaturatedFat,
      this.cholesterol,
      this.sodium,
      this.potassium,
      this.fiber,
      this.sugar,
      this.vitaminA,
      this.vitaminC,
      this.calcium,
      this.iron});

  Serving.fromJson(Map<String, dynamic> json) {
    servingId = json['serving_id'];
    servingDescription = json['serving_description'];
    servingUrl = json['serving_url'];
    metricServingAmount = json['metric_serving_amount'];
    metricServingUnit = json['metric_serving_unit'];
    numberOfUnits = json['number_of_units'];
    measurementDescription = json['measurement_description'];
    calories = json['calories'];
    carbohydrate = json['carbohydrate'];
    protein = json['protein'];
    fat = json['fat'];
    saturatedFat = json['saturated_fat'];
    polyunsaturatedFat = json['polyunsaturated_fat'];
    monounsaturatedFat = json['monounsaturated_fat'];
    cholesterol = json['cholesterol'];
    sodium = json['sodium'];
    potassium = json['potassium'];
    fiber = json['fiber'];
    sugar = json['sugar'];
    vitaminA = json['vitamin_a'];
    vitaminC = json['vitamin_c'];
    calcium = json['calcium'];
    iron = json['iron'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serving_id'] = servingId;
    data['serving_description'] = servingDescription;
    data['serving_url'] = servingUrl;
    data['metric_serving_amount'] = metricServingAmount;
    data['metric_serving_unit'] = metricServingUnit;
    data['number_of_units'] = numberOfUnits;
    data['measurement_description'] = measurementDescription;
    data['calories'] = calories;
    data['carbohydrate'] = carbohydrate;
    data['protein'] = protein;
    data['fat'] = fat;
    data['saturated_fat'] = saturatedFat;
    data['polyunsaturated_fat'] = polyunsaturatedFat;
    data['monounsaturated_fat'] = monounsaturatedFat;
    data['cholesterol'] = cholesterol;
    data['sodium'] = sodium;
    data['potassium'] = potassium;
    data['fiber'] = fiber;
    data['sugar'] = sugar;
    data['vitamin_a'] = vitaminA;
    data['vitamin_c'] = vitaminC;
    data['calcium'] = calcium;
    data['iron'] = iron;
    return data;
  }
}
