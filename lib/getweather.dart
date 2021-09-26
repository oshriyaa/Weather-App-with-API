import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/fetch.dart';
import 'package:weather_app/model/weather.dart';

class StyleText {
  static const textStyle1 =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown);
  static const textStyle2 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown);
  static const textStyle3 =
      TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white);
  static const textStyle4 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown);
}

class DisplayWeather extends StatefulWidget {
  final Function(String?)? onsubmitted;
  DisplayWeather({this.onsubmitted});

  @override
  _DisplayWeatherState createState() => _DisplayWeatherState();
}

class _DisplayWeatherState extends State<DisplayWeather> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController? controller = TextEditingController();
  String? city_name;
  bool ispressed = false;

  Future<Weather?>? getw;
  @override
  void initState() {
    getw = FetchWeather.getWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.brown.shade100,
        appBar: AppBar(
          backgroundColor: Colors.brown.shade400,
          title: ispressed == false
              ? Text("Today's weather")
              : Container(
                  height: 40,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.brown.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Search City',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ispressed = false;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                      onChanged: (data) {
                        city_name = data;
                        print(city_name);
                      },
                    ),
                  ),
                ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (ispressed == true) {
                    if (_formKey.currentState!.validate()) {
                      getw = FetchWeather.getWeather(query: city_name)
                          .whenComplete(() {
                        setState(() {
                          ispressed = false;
                        });
                      });
                    }
                  }
                  setState(() {
                    ispressed = true;
                  });
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: FutureBuilder<Weather?>(
                  future: getw,
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      print(snapshot.data?.current?.toJson());
                      return Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${snapshot.data?.location?.name}",
                                style: StyleText.textStyle1,
                              ),
                            ),
                            Text(
                              "${snapshot.data?.location?.country}",
                              style: StyleText.textStyle2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(
                                child: Container(
                                  // color: Colors.amber,
                                  height: 150,
                                  width: 200,
                                  child: Image.network(
                                    "http:${snapshot.data?.current?.condition?.icon}",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${snapshot.data?.current?.tempC} °C",
                              style: StyleText.textStyle3,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("${snapshot.data?.current?.condition?.text}",
                                style: StyleText.textStyle4),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Humidity: ${snapshot.data?.current?.humidity} %",
                                style: StyleText.textStyle4),
                          ],
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
