// lib/services/weather_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Todo_App/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = 'b3f1e48eff6596271321d3951dc0f25d';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeatherByCity(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric&lang=vi',
    );

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['cod'] != 200 && json['cod'] != '200') {
          throw Exception('Không tìm thấy thành phố');
        }
        return Weather.fromJson(json);
      } else {
        throw HttpException('Server trả về mã lỗi ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('📡 Không có Internet. Kiểm tra kết nối nhé!');
    } on TimeoutException {
      throw Exception('⏰ Hệ thống phản hồi quá lâu. Thử lại sau nha.');
    } on FormatException {
      throw Exception('🧩 Dữ liệu từ API không hợp lệ.');
    } on HttpException catch (e) {
      throw Exception('⚠️ ${e.message}');
    } catch (e) {
      throw Exception('❌ Lỗi không xác định: $e');
    }
  }
}
