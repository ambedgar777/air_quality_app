class AirQuality {
  int aqi;
  String
      cityName; //both the variables are coming from API, that's why there are not using null-safety.

  String? message;
  String? emojiRef;

  AirQuality({
    required this.aqi,
    required this.cityName,
    this.message,
    this.emojiRef,
  });

  //from Json method for creating air quality instance from a map.
  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
        aqi: json['data']['aqi'] as int,
        cityName: json['data']['city']['name'] as String);
  }
}
