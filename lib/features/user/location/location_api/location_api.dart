import 'package:dio/dio.dart';
import 'package:opclo/features/user/location/model/location_detail.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../model/location_model.dart';

final LocationApisProvider = Provider<LocationApi>((ref) {
  return LocationApi();
});

class LocationApi {
  final baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final apiKey = 'AIzaSyCK_fk5wxqwPd2NF9SPUd-y7OtZHh-c5Fo';
  final geoCode = 'https://maps.googleapis.com/maps/api/geocode/json';

  Stream<List<LocationModel>> fetchLocations(String input) async* {
    final url = '$baseUrl/autocomplete/json?input=$input&key=$apiKey';

    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      final predictions = data['predictions'];
      List<LocationModel> places = [];
      for (var prediction in predictions) {
        places.add(LocationModel.fromJson(prediction));
      }
      yield places;
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<LocationDetails> fetchLocationDetails(String placeId) async {
    final url =
        '$baseUrl/details/json?place_id=$placeId&fields=name,geometry&key=$apiKey';
    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      final result = data['result'];

      return LocationDetails.fromJson(result);
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Future<LocationDetails> fetchLocationFromLatLng(
      {required double lat,required  double lng}) async {
    final url = '$geoCode?latlng=$lat,$lng&key=$apiKey';
    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      final results = data['results'];
        return LocationDetails.fromDetailJson(results[0]);
    } else {
      throw Exception('Failed to load location');
    }
  }
}
