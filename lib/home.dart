import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:week6/Util/open_weather.dart';
import 'package:week6/data_classes/weather_data/weather_data.dart';
import 'package:week6/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<WeatherData> weaterData;
  @override
  void initState() {
    super.initState();
    weaterData = OpenWeather.fetchBycurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Report')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(197, 134, 91, 214),
              Color.fromARGB(199, 196, 65, 196)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FutureBuilder(
                future: weaterData,
                builder: (context, AsyncSnapshot<WeatherData> snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasData) {
                    var iconID = snapshot.data!.weather!.first.icon.toString();
                    children = [
                      Text(
                        snapshot.data!.name.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!.sys!.country.toString(),
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now().toUtc()),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    'http://openweathermap.org/img/wn/$iconID@2x.png',
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                      value: progress.progress),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                ((snapshot.data!.main!.temp! - 273.15))
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Text(
                                " ํC",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Max : ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ((snapshot.data!.main!.tempMax! - 273.15))
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    " ํC",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Min : ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ((snapshot.data!.main!.tempMin! - 273.15))
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    " ํC",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        snapshot.data!.weather!.first.description.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(snapshot.data!.toString())
                    ];
                  } else if (snapshot.hasError) {
                    children.add(const Center(
                      child: Icon(
                        Icons.error,
                        size: 80,
                        color: Colors.red,
                      ),
                    ));
                    children.add(const Text(
                      'Error',
                      style: TextStyle(color: Colors.white),
                    ));
                    children.add(Text(
                      snapshot.hasError.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ));
                  } else {
                    children.add(const Text(
                      'Waiting...',
                      style: TextStyle(color: Colors.white),
                    ));
                  }
                  return Column(
                    children: children,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.purple)),
                onPressed: () async {
                  var cityName = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Search()),
                  );
                  if (cityName != null) {
                    setState(() {});
                    weaterData =
                        OpenWeather.fetchByCityName(cityName: cityName);
                  }
                },
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
