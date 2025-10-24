import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../models/weather_model.dart';
import '../../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('08f313718432f996ece9032681a5a7e7');
  Weather? _weather;

  _fetchWeather() async {
    String? cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState((){
        _weather = weather;
      });
    } catch (e) {
      print('Errorx: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Loading city..."),
            Lottie.asset('assets/partly cloudy.json'),
            Text("${_weather?.temperature.round()}°C")
          ],
        )
      )
    );
  }
}
