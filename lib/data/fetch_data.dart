import 'dart:convert';
import 'dart:developer';
import 'package:air_quality_app/data/air_quality.dart';
import 'package:air_quality_app/data/api_key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<AirQuality?> fetchData() async {
  try {
    bool serviceEnabled;
    LocationPermission locationPermission;

    //Test if the permission is enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Locations permissions are denied');
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      //when permissions are denied forever
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions');
    }

    ///When we reach here, we have the device location,
    /// and we can continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();

    var url = Uri.parse(
        'https://api.waqi.info/feed/geo:${position.latitude};${position.longitude}/?token=$API_KEY');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      AirQuality airQuality = AirQuality.fromJson(jsonDecode(response.body));
      if (airQuality.aqi >= 0 && airQuality.aqi <= 50) {
        airQuality.message =
            "Air quality is considered satisfactory, and air pollution poses little or no risk	";
        airQuality.emojiRef = "1.png";
      } else if (airQuality.aqi >= 51 && airQuality.aqi <= 100) {
        airQuality.message =
            "Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people who are unusually sensitive to air pollution.";
        airQuality.emojiRef = "2.png";
      } else if (airQuality.aqi >= 101 && airQuality.aqi <= 150) {
        airQuality.message =
            "Members of sensitive groups may experience health effects. The general public is not likely to be affected.";
        airQuality.emojiRef = "3.png";
      } else if (airQuality.aqi >= 151 && airQuality.aqi <= 200) {
        airQuality.message =
            "Everyone may begin to experience health effects; members of sensitive groups may experience more serious health effects";
        airQuality.emojiRef = "4.png";
      } else if (airQuality.aqi >= 201 && airQuality.aqi < 300) {
        airQuality.message =
            "Health warnings of emergency conditions. The entire population is more likely to be affected.";
        airQuality.emojiRef = "5.png";
      } else if (airQuality.aqi >= 300) {
        airQuality.message =
            "Health alert: everyone may experience more serious health effects";
        airQuality.emojiRef = "6.png";
      }

      print(airQuality);
      return airQuality;
    }
    return null;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}
