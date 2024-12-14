import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:opclo/features/user/location/location_controller/location_notifier_controller.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/photo_model.dart';
import '../../location/model/location_detail.dart';

final quickAccessPlacesApisProvider = Provider<QuickAccessPlacesApi>((ref) {
  final notifier = ref.watch(locationDetailNotifierCtr);
  return QuickAccessPlacesApi(notifier);
});

class QuickAccessPlacesApi {
  final LocationNotifierController locationNotifier;

  QuickAccessPlacesApi(this.locationNotifier);

  final String baseUrl = 'https://api.foursquare.com/v3/places';
  final String baseUrlOfAutoComplete =
      'https://api.foursquare.com/v3/autocomplete';

  final String apiKey = 'fsq3IBkf7P5+zYIH6LVqXyrP9QjPtEYZNYSpcgn+vwx1CxQ=';
  final String fields =
      'fields=website%2Cphotos%2Cname%2Crating%2Ctel%2Cwebsite%2Crating%2Cfsq_id%2Cgeocodes%2Ccategories%2Cdistance%2Chours%2Clocation%2Cclosed_bucket%2C';

  // Dio initialization method
  Dio _getDioInstance() {
    final dio = Dio();
    dio.options.headers['Authorization'] = apiKey;
    dio.options.headers['accept'] = 'application/json';
    return dio;
  }
  Future<LocationData?> locationCheck() async {
    Location location = new Location();
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // return null;
      }
    }
    bool _serviceEnabled = false;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        //  return null;
      }
    }
    return await location.getLocation();
  }

  Future<LocationDetails?> getLocationDetails() async {
    try {
      LocationDetails? locationDetail = locationNotifier.locationDetail;
      if (locationDetail == null) {
        LocationData? currentLocation = await locationCheck();
        if (currentLocation == null) {
          return null;
        }
        return LocationDetails(
          latitude: currentLocation.latitude!,
          longitude: currentLocation.longitude!,
          name: '',
        );
      }
      return locationDetail;
    } catch (e) {
      debugPrint('Error getting location details: $e');
      return null;
    }
  }

  Future<Either<String, Map<String, dynamic>>> searchPlaceById({
    required String fsq,
  }) async {
    final endpoint = '$fsq?$fields';
    final dio = _getDioInstance();
    final response = await dio.get('$baseUrl/$endpoint');
    if (response.statusCode == 200) {
      return Right(response.data);
    } else {
      return Left('Failed to load places');
    }
  }

}
