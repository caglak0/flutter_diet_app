import 'dart:convert';
import 'package:flutter_diet_app/models/nobetci_eczane_model.dart';
import 'package:http/http.dart' as http;

class NobetciEczaneService {
  final String baseUrl =
      "https://www.nosyapi.com/apiv2/service/pharmacies-on-duty/locations";
  final String apiKey =
      "AYnogxvmyu6NHpUMC0j4XNJA4R9U4IJvVY8EEl4RUmE0prvhyIgXzZkirGbn"; 

  Future<List<NobetciEczane>> getEczane(
      double latitude, double longitude) async {
    final url = Uri.parse('$baseUrl?latitude=$latitude&longitude=$longitude');
    final response = await http.get(
      url,
      headers: {'X-NSYP': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> resp = jsonDecode(response.body)["data"];
      List<NobetciEczane> eczaneler = [];

      resp.forEach((element) {
        eczaneler.add(NobetciEczane.fromJson(element));
      });

      return eczaneler;
    } else {
      throw Exception('Failed to load data');
    }
  }

}
