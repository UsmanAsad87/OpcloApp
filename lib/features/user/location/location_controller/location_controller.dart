import 'package:opclo/features/user/location/model/location_detail.dart';
import 'package:opclo/features/user/location/model/location_model.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../location_api/location_api.dart';

final locationControllerProvider =
    StateNotifierProvider<LocationController, bool>((ref) {
  return LocationController(
    databaseApis: ref.watch(LocationApisProvider),
  );
});

final fetchLocationsProvider = StreamProvider.family((ref, String input) {
  final databaseProvider = ref.watch(locationControllerProvider.notifier);
  return databaseProvider.fetchLocations(
    input: input,
  );
});

class LocationController extends StateNotifier<bool> {
  final LocationApi _databaseApis;

  LocationController({required LocationApi databaseApis})
      : _databaseApis = databaseApis,
        super(false);

  Stream<List<LocationModel>> fetchLocations({required String input}) {
    return _databaseApis.fetchLocations(input);
  }

  Future<LocationDetails> fetchLocationDetail({required String id}) {
    return _databaseApis.fetchLocationDetails(id);
  }

  Future<LocationDetails> fetchLocationDetailFromLatAndLng(
      {required double latitude, required double longitude}) {
    return _databaseApis.fetchLocationFromLatLng(lat: latitude, lng: longitude);
  }
}
