import 'dart:convert';
import 'package:flutter_diet_app/model/foodbyid_model.dart';
import 'package:flutter_diet_app/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FatSecretService {
  static const String _authUrl = 'https://oauth.fatsecret.com/connect/token';
  static const String _baseUrl = "https://platform.fatsecret.com/rest/server.api";
  static const String _clientId = '2c03ae6aaa4a43df87e583a014380aca ';
  static const String _clientSecret = 'b7abeea9ed6b4093acb67ea713c38e9c';

  static Future<void> resetFoodsDaily() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString('lastResetDate');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).toString();

    if (lastReset != today) {
      prefs.setString('lastResetDate', today);
      prefs.remove('kahvaltiFoods');
      prefs.remove('araOgunFoods');
      prefs.remove('ogleYemegiFoods');
      prefs.remove('aksamYemegiFoods');
    }
  }

  static Future<String> _getAccessToken() async {
    final uri = Uri.parse(_authUrl);
    final response = await http.post(uri, body: {
      'grant_type': 'client_credentials',
      'client_id': _clientId,
      'client_secret': _clientSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'] as String;
    } else {
      throw Exception('Kimlik doğrulama başarısız: ${response.statusCode}');
    }
  }

  static Future<SearchModel> foodSearchService(String searchExpression) async {
    final token = await _getAccessToken();
    final uri = Uri.parse(_baseUrl);
    final response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'method': 'foods.search',
      'format': 'json',
      'search_expression': searchExpression,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return SearchModel.fromJson(jsonResponse);
    } else {
      throw Exception('Yiyecekler yüklenemedi: ${response.statusCode}');
    }
  }

  static Future<FoodByID> foodDetailService(String foodId) async {
    final token = await _getAccessToken();
    final uri = Uri.parse(_baseUrl);
    final response = await http.post(uri, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'method': 'food.get.v4',
      'format': 'json',
      'food_id': foodId,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return FoodByID.fromJson(jsonResponse);
    } else {
      throw Exception('Yiyecek detayları yüklenemedi: ${response.statusCode}');
    }
  }
}
