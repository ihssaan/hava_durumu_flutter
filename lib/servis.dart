import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'weather.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Havalar?> fetchWeatherData(String cities) async {
    final url = Uri.parse(
        'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$cities');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'KENDİ APİ KEYİNİZ',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Havalar.fromJson(data);
      } else {
        print('Veri alınamadı: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }
}
