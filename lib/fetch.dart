import 'dart:convert';

import 'model/weather.dart';
import 'package:http/http.dart' as http;

class FetchWeather {
  static Future<Weather?> getWeather({String? query = 'Kathmandu'}) async {
    var url = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?q=$query&key=4f155aedb1224a8491863814210109');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      var decoded = json.decode(response.body);
      var data = Weather.fromJson(decoded);
      print(data);
      return data;
    }
    return null;
  }
}
