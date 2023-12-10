import 'package:flutter/material.dart';
import '../models/clima_model.dart';
import '../services/clima_service.dart';
import 'package:lottie/lottie.dart';
import '../secrets.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  final _climaService = ClimaService(API_KEY);
  Clima? _clima;

  _fetchClima() async {
    int cityId = await _climaService.getCurrentCity();

    try {
      final clima = await _climaService.getClima(cityId);

      setState(() {
        _clima = clima;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchClima();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_clima?.cityName ?? 'Carregando a cidade...'}, ${_clima?.cityState}'),
            Lottie.asset('assets/sunny.json'),
            Text('${_clima?.temperature.round().toString()}°C' ),
          ],
        ),
      )
    );
  }
}
