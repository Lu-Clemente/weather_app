import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:weather_app/additional_information_box.dart';
import 'package:weather_app/hourly_forecast_card.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();

    weather = fetchCurrentWeather();
  }

  Future<Map<String, dynamic>> fetchCurrentWeather() async {
    String cityName = "Para";
    String country = "br";
    try {
      final response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$country&units=metric&APPID=$openWeatherAPIKey"));

      final data = jsonDecode(response.body);

      if (data["cod"] != "200") {
        throw "An unexpected error occurred";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData getCurrentIcon(String sky) {
      switch (sky) {
        case "Clouds":
          return Icons.cloud;
        case "Clear":
          return Icons.sunny;
        case "Rain":
          return Icons.water;
        default:
          return Icons.cloud;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = fetchCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final weatherData = data["list"][0];

          final currentTemp = weatherData["main"]["temp"].round();
          final currentSky = weatherData["weather"][0]["main"];
          final currentPressure = weatherData["main"]["pressure"];
          final currentHumidity = weatherData["main"]["humidity"];
          final currentWindSpeed = weatherData["wind"]["speed"];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* MAIN CARD */
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "${currentTemp.toString()} °C",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(getCurrentIcon(currentSky), size: 64),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),

                /* WEATHER FORECAST CARDS */
                SizedBox(
                  height: 120.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final forecast = data["list"][index + 1];

                      final forecastSky = forecast["weather"][0]["main"];
                      final forecastTemp = forecast["main"]["temp"];
                      final forecastTime = forecast["dt_txt"];

                      final time = DateTime.parse(forecastTime);
                      final timeFormated = DateFormat.j().format(time);

                      return HourlyForecastCard(
                        icon: getCurrentIcon(forecastSky),
                        temperature: forecastTemp.round().toString(),
                        time: timeFormated,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),

                /* ADDITIONAL INFORMATION */
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInformationBox(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "$currentHumidity%",
                    ),
                    AdditionalInformationBox(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "$currentWindSpeed m/s",
                    ),
                    AdditionalInformationBox(
                      icon: Icons.thermostat,
                      label: "Pressure",
                      value: "${currentPressure.toString()} hPa",
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
