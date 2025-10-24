import 'dart:convert';
import 'package:geocoding/geocoding.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const BASE_API_URL = 'https://api.openweather.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$BASE_API_URL?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Problem in loading the weather data.');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    late LocationSettings locationSettings;
    locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Position position = await Geolocator.getCurrentPosition(locationSettings:locationSettings);
    print('position: $position');
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemark[0].locality;

    print('city : $city');
    return city ?? "";
  }
}
