import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/clima_model.dart';


class ClimaService {

  static const BASE_URL = 'http://apiadvisor.climatempo.com.br/api/v1';
  final String apiKey;

  ClimaService(this.apiKey);

  Future<Clima> getClima(int cityId) async {
    final cityInfo = await http.get(Uri.parse('$BASE_URL/locale/city/$cityId?token=$apiKey'));
    // final cityTemperature = await http.get(Uri.parse('$BASE_URL/climate/temperature/locale/$cityId?token=$apiKey'));

    if (cityInfo.statusCode == 200) {
      final resultCity = jsonDecode(cityInfo.body);
      // final resultTemperature = jsonDecode(cityInfo.body);

      return Clima(
          cityName: resultCity['name'],
          cityState: resultCity['state'],
          temperature: 25,
          mainCondition: 'Quente'
      );

    } else {
      throw Exception('Erro ao carregar os dados do clima');
    }
  }

  Future<int> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    final response = await http.get(Uri.parse('$BASE_URL/locale/city?latitude=${position.latitude}&longitude=${position.longitude}&token=$apiKey'));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['id'];
    } else {
      throw Exception('Erro ao descobrir cidade');
    }
  }
}