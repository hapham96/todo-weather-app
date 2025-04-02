// lib/models/weather.dart

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double windSpeed;
  final int humidity;
  final String weatherIcon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.weatherIcon,
  });

  // Factory constructor to parse from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      weatherIcon: json['weather'][0]['icon'],
    );
  }
}
