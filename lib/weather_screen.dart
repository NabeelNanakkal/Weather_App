import 'dart:ui';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';

class WeatherSreen extends StatefulWidget {
  const WeatherSreen({super.key});

  @override
  State<WeatherSreen> createState() => _WeatherSreenState();
}

class _WeatherSreenState extends State<WeatherSreen> {
  // bool isLoader = false;
  // double temp = 0;
  // String description = "";
  // int humidity = 0;
  // double windSpeed = 0;
  // int pressure = 0;

  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // setState(() {
      //   isLoader= true;
      // });
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=Bengaluru,in&APPID=1abdbcd080ce7e49f1229c3ab22adb63'));

      final data = json.decode(res.body);

      if (data['cod'] != '200') {
        throw data['message'];
      }

      return data;
      // setState(() {
      //   temp = data['list'][0]['main']['temp'];
      //   description = data['list'][0]['weather'][0]['description'];
      //   humidity = data['list'][0]['main']['humidity'];
      //   windSpeed = data['list'][0]['wind']['speed'];
      //   pressure = data['list'][0]['main']['pressure'];
      //   isLoader= false;
      // });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {
              setState(() {
                weather = getCurrentWeather();
              })
            },
            icon: const Icon(Icons.refresh_outlined),
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                    EdgeInsets.only(right: 20.0, left: 20.0))),
          ),
        ],
      ),
      // isLoader ? const Center(child: CircularProgressIndicator(),) :
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentHumidity = currentWeatherData['main']['humidity'];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      elevation: 5.0,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${currentTemp.toStringAsFixed(2)} K',
                                  style: const TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 70.0,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hourly Forecast',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 5; i++)
                  //         HourlyForcasteCard(
                  //             temp: data['list'][i + 1]['main']['temp']
                  //                 .toString(),
                  //             time: data['list'][i + 1]['dt'].toString(),
                  //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                  //                         'Clouds' ||
                  //                     data['list'][i + 1]['weather'][0]
                  //                             ['main'] ==
                  //                         'Rain'
                  //                 ? Icons.cloud
                  //                 : Icons.sunny),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final time = DateTime.parse(
                              data['list'][index + 1]['dt_txt'].toString());
                          return HourlyForcasteCard(
                              temp: data['list'][index + 1]['main']['temp']
                                  .toString(),
                              time: DateFormat.jm().format(time),
                              icon: data['list'][index + 1]['weather'][0]
                                              ['main'] ==
                                          'Clouds' ||
                                      data['list'][index + 1]['weather'][0]
                                              ['main'] ==
                                          'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny);
                        }),
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdditionalInf(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: currentHumidity.toStringAsFixed(2)),
                      AdditionalInf(
                          icon: Icons.air,
                          label: 'Wind Speed',
                          value: currentWindSpeed.toStringAsFixed(2)),
                      AdditionalInf(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: currentPressure.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
