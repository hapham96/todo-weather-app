import 'dart:convert';

import 'package:Todo_App/core/logger/logger_tracker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = WeatherService();
  Weather? weatherData;
  String city = 'Hanoi';
  final _cityController = TextEditingController();
  final logger = LoggerTrackerService();
  bool isLoading = false;

  Future<void> _fetchWeather() async {
    setState(() => isLoading = true);
    try {
      final data = await _weatherService.fetchWeatherByCity(city);
      setState(() => weatherData = data as Weather?);
      logger.logInfo("Fetching data from API -> $weatherData", tag: "WeatherService");
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Có lỗi xảy ra'),
              content: Text(e.toString()),
            ),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _cityController.text = city;
    // _fetchWeather();
  }

  @override
  void dispose() {
    _cityController.dispose();
    logger.saveLogToFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // vintage beige
      appBar: AppBar(
        title: Text(
          '🌤️ Weather',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFDEB887),
        foregroundColor: const Color(0xFF3E2723),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCitySearch(),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : weatherData != null
                ? _buildWeatherCard()
                : const Text('Không có dữ liệu'),
          ],
        ),
      ),
    );
  }

  Widget _buildCitySearch() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: 'Nhập tên thành phố...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            city = _cityController.text.trim();
            if (city.isNotEmpty) {
              _fetchWeather();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6D4C41),
          ),
          child: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: weatherData != null ? 1.0 : 0.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFFFFE0B2),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Text(
                weatherData!.cityName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Image.network(
                'https://openweathermap.org/img/wn/${weatherData!.weatherIcon}@2x.png',
                width: 100,
                height: 100,
              ),
              Text(
                '${weatherData!.temperature.toStringAsFixed(1)}°C',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                weatherData!.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text('${weatherData!.humidity}%'),
                  const SizedBox(width: 16),
                  Icon(Icons.air, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text('${weatherData!.windSpeed} m/s'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
