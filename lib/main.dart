import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int temp = 12;
  String weather = "clear";
  int humidity = 12;
  int windspeed = 22;
  String location = "San Fransisco";
  int woeid = 2487956;

  String searchapiurl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationapiurl = 'https://www.metaweather.com/api/location/';

  void fetchsearch(String input) async {
    var searchresults = await http.get(searchapiurl + input);
    var result = json.decode(searchresults.body)[0];
    setState(() {
      location = result["title"];
      woeid = result["woeid"];
    });
  }

  void fetchlocation() async {
    var locationresult = await http.get(locationapiurl + woeid.toString());
    var result = json.decode(locationresult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];

    setState(() {
      temp = data["the_temp"].round();
      weather = data["weather_state_name"];
      windspeed = data["wind_speed"].round();
      humidity = data["humidity"].round();
    });
  }

  void ontextfieldsubmit(String input) {
    fetchsearch(input);
    fetchlocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: Text(
          "Weather",
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                onSubmitted: (String input) {
                  ontextfieldsubmit(input);
                },
                style: TextStyle(color: Colors.grey[900], fontSize: 25),
                decoration: InputDecoration(
                  hintText: "        Enter City Name",
                  hintStyle: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 40,
                    color: Colors.amber[900],
                  ),
                ),
              ),
              color: Colors.white,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  temp <= 20
                      ? (weather == "clear"
                          ? Icons.wb_sunny
                          : FontAwesomeIcons.cloudRain)
                      : Icons.brightness_7,
                  size: 100,
                  color: Colors.yellow,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "$location",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "$temp" + " \u2103",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.thermometerQuarter,
                    size: 40,
                    color: Colors.orange[900],
                  ),
                  title: Text(
                    "Temperature",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "$temp" + " \u2103",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.wind,
                    size: 40,
                    color: Colors.yellow[700],
                  ),
                  title: Text(
                    "Wind Speed",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "$windspeed",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.cloud,
                    size: 40,
                    color: Colors.blue[100],
                  ),
                  title: Text(
                    "Weather",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "$weather",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.cloudSunRain,
                    size: 40,
                    color: Colors.grey[900],
                  ),
                  title: Text(
                    "Humidity",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "$humidity",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
