class AutocompleteModel {
  Suggestions? suggestions;

  AutocompleteModel({this.suggestions});

  AutocompleteModel.fromJson(Map<String, dynamic> json) {
    suggestions = json['suggestions'] != null ? Suggestions.fromJson(json['suggestions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (suggestions != null) {
      data['suggestions'] = suggestions!.toJson();
    }
    return data;
  }
}

class Suggestions {
  List<String>? suggestion;

  Suggestions({this.suggestion});

  Suggestions.fromJson(Map<String, dynamic> json) {
    suggestion = json['suggestion'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suggestion'] = suggestion;
    return data;
  }
}
