import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({Key? key}) : super(key: key);

  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  @override
  void initState() {
    _determinePosition();
    // TODO: implement initState
    super.initState();
  }

  Position? positione;
  Map<String, dynamic>? wetherMap;
  Map<String, dynamic>? forecastMap;

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    positione = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = positione!.latitude;
      longatute = positione!.longitude;
    });

    wetherData();
  }

  var latitude;
  var longatute;

  wetherData() async {
    var wether =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2rx2vtjKr8f2ruYvSucR1ythRMsztUD_s8IgW4WCS8d3cve0Bodf5LOxE";

    var forecast =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2rx2vtjKr8f2ruYvSucR1ythRMsztUD_s8IgW4WCS8d3cve0Bodf5LOxE";
    var recponce_wether = await http.get(Uri.parse(wether));
    var recponce_forecast = await http.get(Uri.parse(forecast));

    setState(() {
      forecastMap =
          Map<String, dynamic>.from(jsonDecode(recponce_forecast.body));

      wetherMap = Map<String, dynamic>.from(jsonDecode(recponce_wether.body));
      print("ppppppppppppppppp ${latitude}, lonnnnn$longatute");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Wether'),
      ),
      body: wetherMap != null
          ? Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(4),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            "${Jiffy(DateTime.now()).format("MMM do yy, h:mm:a")}",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            "${wetherMap!["name"]}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 4,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.0),
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            CircleAvatar(
                              maxRadius: 40,
                              backgroundImage: NetworkImage(
                                  "http://openweathermap.org/img/wn/10d@2x.png"),
                            ),
                            Text(
                              "${wetherMap!["main"]["temp"]}",
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Column(
                              children: [
                                Text(
                                  "Feels like ${wetherMap!["main"]["feels_like"]}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Text(
                                  " ${wetherMap!["weather"][0]["description"]}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Humidity ${wetherMap!["main"]["humidity"]},Pressure ${wetherMap!["main"]["pressure"]}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                                Text(
                                  "Sunrise ${Jiffy(DateTime.fromMillisecondsSinceEpoch(wetherMap!["sys"]["sunrise"] * 1000)).format("h:mm:a")}, Sunset ${Jiffy(DateTime.fromMillisecondsSinceEpoch(wetherMap!["sys"]["sunset"] * 1000)).format("h:mm:a")}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: forecastMap?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.all(14),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                        "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE,h:mm:a")}"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Image.network(
                                        "http://openweathermap.org/img/wn/10d@2x.png"),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text(
                                      "${forecastMap!["list"][index]["main"]["temp_min"]} / ${forecastMap!["list"][index]["main"]["temp_max"]}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text(
                                      "${forecastMap!["list"][index]["weather"][0]["main"]}",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                              )),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }
}
