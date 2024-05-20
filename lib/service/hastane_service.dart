import 'dart:convert';
import 'package:flutter_diet_app/models/hastane_model.dart';
import 'package:http/http.dart' as http;

class HastaneService {
  final String baseUrl =
      "https://www.nosyapi.com/apiv2/service/hospital/locations";
  final String apiKey =
      "AYnogxvmyu6NHpUMC0j4XNJA4R9U4IJvVY8EEl4RUmE0prvhyIgXzZkirGbn"; 

  Future<List<HastaneModel>> getHastane(
      double latitude, double longitude) async {
    final url = Uri.parse('$baseUrl?latitude=$latitude&longitude=$longitude');
    final response = await http.get(
      url,
      headers: {'X-NSYP': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> resp = jsonDecode(response.body)["data"];
      List<HastaneModel> hastaneler = [];

      resp.forEach((element) {
        hastaneler.add(HastaneModel.fromJson(element));
      });

      return hastaneler;
    } else {
      throw Exception('Failed to load data');
    }
  }

}