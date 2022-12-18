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
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black38,
        title: Text('Wether'),
        centerTitle: true,
        actions: [
          Icon(Icons.search),
          Icon(Icons.location_disabled_rounded),
        ],
      ),
      body: wetherMap != null
          ? Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("images/ab.png"))),
                    height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(4),
              child: SingleChildScrollView(
                child: Stack(

                  children: [

                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 3, child: Container()),
                            Expanded(
                                flex: 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "data:image/jpeg;base64,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"))),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.01),
                                        Text(
                                          "${Jiffy(DateTime.now()).format("MMM do yy, h:mm:a")}",
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),
                                        SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.01),
                                        Text(
                                          "${wetherMap!["name"]}",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                        SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.01),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.lightGreenAccent,
                          // ),
                          // // padding: EdgeInsets.all(10.0),
                          // margin:
                          //     EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          child: Stack(
                            children: [
                              Image.asset("images/a.jpg"),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.01),
                                    Container(
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: CircleAvatar(
                                        maxRadius: 35,
                                        backgroundImage: NetworkImage(
                                            "http://openweathermap.org/img/wn/10d@2x.png"),
                                      ),
                                    ),
                                    Text(
                                      "${wetherMap!["main"]["temp"]},",
                                      style: TextStyle(
                                          fontSize: 35, color: Colors.white),
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.01),
                                    Column(
                                      children: [
                                        Row(children: [
                                          Column(children: [
                                            Text(
                                              "Feels like ${wetherMap!["main"]["feels_like"]}",
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.white),
                                            ),
                                            SizedBox(
                                                height:
                                                MediaQuery.of(context).size.height *
                                                    0.01),
                                            Text(
                                              " ${wetherMap!["weather"][0]["description"]}",
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.white),
                                            ),
                                          ],)
                                        ],),
                                        SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.01),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Humidity ${wetherMap!["main"]["humidity"]},Pressure ${wetherMap!["main"]["pressure"]}",
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.white),
                                        ),
                                        SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.02),
                                        Text(
                                          "Sunrise ${Jiffy(DateTime.fromMillisecondsSinceEpoch(wetherMap!["sys"]["sunrise"] * 1000)).format("h:mm:a")}, Sunset ${Jiffy(DateTime.fromMillisecondsSinceEpoch(wetherMap!["sys"]["sunset"] * 1000)).format("h:mm:a")}",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                        // SizedBox(
                                        //     height: MediaQuery.of(context).size.height *
                                        //         0.01),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: forecastMap?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // color: Colors.lightGreen,
                                          borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.all(14),
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Text(
                                              "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE,h:mm:a")}"),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Image.network(
                                              "http://openweathermap.org/img/wn/10d@2x.png"),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Text(
                                            "${forecastMap!["list"][index]["main"]["temp_min"]} / ${forecastMap!["list"][index]["main"]["temp_max"]}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          Text(
                                            "${forecastMap!["list"][index]["weather"][0]["main"]}",
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      ],
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
