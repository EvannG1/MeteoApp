import 'package:flutter/material.dart';
import 'package:MeteoApp/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() => runApp(
  MaterialApp(
    title: "MeteoApp",
    home: Home(),
  )
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var city;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather(city) async {
    http.Response response = await http.get("http://api.openweathermap.org/data/2.5/weather?q=$city&units=$units&lang=$lang&appid=$apiKey");
    var results = jsonDecode(response.body);
    if(results['cod'] != 200) {
      cityController.text = 'Ville introuvable';
    } else {
      setState(() {
        this.city = city;
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windSpeed = results['wind']['speed'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather('Nancy');
  }

  final cityController = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    city != null ? city.toString() : "Chargement...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "°" : "Chargement...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    currently != null ? currently.toString() : "Chargement...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Température"),
                    trailing: Text(temp != null ? temp.toString() + "°" : "Chargement..."),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Temps actuel"),
                    trailing: Text(description != null ? description.toString() : "Chargement..."),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.water),
                    title: Text("Humidité"),
                    trailing: Text(humidity != null ? humidity.toString() + "%" : "Chargement..."),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Vitesse du vent"),
                    trailing: Text(windSpeed != null ? windSpeed.toString() + " km/h" : "Chargement..."),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        hintText: "Entrer une ville..."
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      getWeather(cityController.text);                  
                    },
                    child: Text(
                      "Rechercher"
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}