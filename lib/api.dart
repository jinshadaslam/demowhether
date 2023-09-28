import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import 'wheather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fech extends ChangeNotifier {
  String current_time = DateFormat('EEE, M/d/y hh:mm a').format(DateTime.now());
  double latitude = 0;
  double longitude = 0;
  bool ActiveConnection = false;
  Whethermodal? data;
  String apiKey = dotenv.env['API_KEY'].toString();
  String todaydate = DateFormat('EEE, M/d/y').format(DateTime.now());

  void getCurrentLocation() async {
    Position position = await _determinePosition();

    latitude = position.latitude;

    longitude = position.longitude;
    _fetchWeather();
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
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

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _fetchWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiid = 'https://api.openweathermap.org/data/2.5/weather';
    String apiKey = '520ec85e1561c778950d0ef77837b926';

    final response = await http.get(
      Uri.parse(
          '$apiid?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      data = whethermodalFromJson(response.body);
      await prefs.setString('date', todaydate);

      Map<String, dynamic> datastring = jsonDecode(whethermodalToJson(data!));
      final weatherEncode = jsonEncode(datastring);
      prefs.setString('weatherData', json.encode(weatherEncode));
      notifyListeners();
    } else {
      print('Failed to fetch weather data');
      notifyListeners();
    }
  }

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ActiveConnection = true;
      }
    } on SocketException catch (_) {
      ActiveConnection = false;
    }
    notifyListeners();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String olddate = prefs.getString('date') ?? '';
    String olddataString = prefs.getString('weatherData') ?? '';
    if (olddate == todaydate && olddataString.isNotEmpty) {
      data = whethermodalFromJson(json.decode(olddataString));
      print(olddataString);

      notifyListeners();
    } else {
      await CheckUserConnection();
      if (ActiveConnection == true) {
        getCurrentLocation();
        print('object');
        notifyListeners();
      }
    }
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  getCurrentTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    current_time = DateFormat('EEE, d/M/y hh:mm a').format(DateTime.now());
    todaydate = DateFormat('EEE, M/d/y').format(DateTime.now());
    String olddate = prefs.getString('date') ?? '';
    if (olddate != todaydate) {
      check();
      notifyListeners();
    }

    notifyListeners();
  }
}
