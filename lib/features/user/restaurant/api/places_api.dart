import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:opclo/commons/common_functions/show_login.dart';
import 'package:opclo/features/user/location/location_controller/location_notifier_controller.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/photo_model.dart';
import '../../location/model/location_detail.dart';
import '../../search/controller/search_limit.dart';

final placesApisProvider = Provider<PlacesApi>((ref) {
  final notifier = ref.watch(locationDetailNotifierCtr);
  return PlacesApi(notifier);
});

class PlacesApi {
  final LocationNotifierController locationNotifier;

  PlacesApi(this.locationNotifier);

  final String baseUrl = 'https://api.foursquare.com/v3/places';

  // final String baseUrlOfAutoComplete =
  //     'https://api.foursquare.com/v3/autocomplete';

  final String apiKey = 'fsq3AHrBACITJb9wAaajO3ZCjKHUxP+hh7QpP5J0m4z3rtM=';
  final String fields =
      'fields=website%2Cphotos%2Cname%2Crating%2Ctel%2Cwebsite%2Crating%2Cfsq_id%2Cgeocodes%2Ccategories%2Cdistance%2Chours%2Clocation%2Cclosed_bucket%2C';

  // Dio initialization method
  Dio _getDioInstance() {
    final dio = Dio();
    dio.options.headers['Authorization'] = apiKey;
    dio.options.headers['accept'] = 'application/json';
    return dio;
  }

  // get current location and location permission check method
  Future<LocationData?> locationCheck() async {
    Location location = new Location();
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }
    return await location.getLocation();
  }

  // check for location_notifier and if null check current location
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

  Future<Either<String, Map<String, dynamic>>> _handleResponse(
    Response response,
  ) async {
    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> places =
          List<Map<String, dynamic>>.from(response.data['results']);
      final linkHeader = response.headers['link'] ?? '';
      final data = {'places': places, 'link': linkHeader};
      return Right(data);
    } else {
      return const Left('Failed to load places');
    }
  }

  Future<Either<String, Map<String, dynamic>>> _searchPlaces(
    String endpoint,
  ) async {
    try {
      final dio = _getDioInstance();
      final response = await dio.get('$baseUrl/$endpoint');
      return _handleResponse(response);
    } catch (e) {
      return Left('Exception: $e');
    }
  }

  Future<Either<String, Map<String, dynamic>>> searchPlacesByCategory({
    required String categories,
    bool openNow = false,
  }) async {
    LocationDetails? locationDetail = await getLocationDetails();
    final lat = locationDetail?.latitude;
    final lng = locationDetail?.longitude;
    final openNowParam = openNow ? '&open_now=true' : '';
    final endpoint =
        'search?sort=DISTANCE&ll=${lat}%2C${lng}$openNowParam&categories=$categories&$fields';
    return _searchPlaces(endpoint);
  }

  Future<Either<String, Map<String, dynamic>>> storeUsingChainId(
    String chainId,
  ) async {
    LocationDetails? locationDetail = await getLocationDetails();
    final lat = locationDetail?.latitude;
    final lng = locationDetail?.longitude;
    final endpoint =
        'search?sort=DISTANCE&ll=${lat}%2C${lng}&chains=$chainId&$fields';
    return _searchPlaces(endpoint);
  }

  Future<Either<String, Map<String, dynamic>>> searchPlacesWithOnlyQuery(
      {String? query,
      required BuildContext context,
      required bool isPrem}) async {
    if (!isPrem) {
      final canSearch = await SearchLimiter.canSearch();
      if (!canSearch) {
        final remainingTime = await SearchLimiter.timeRemainingToSearch();
        showLimitDialog(
          context: context,
          description:
              'You\'ve reached your limit for today. More access will be available in $remainingTime. Want unlimited access? Upgrade now!',
        );
        return const Left('Limit Exceeded');
      }
    }

    LocationDetails? locationDetail = await getLocationDetails();
    final lat = locationDetail?.latitude;
    final lng = locationDetail?.longitude;
    final String endpoint = 'search?ll=$lat%2C$lng&query=$query';
    return _searchPlaces('$endpoint&$fields');
  }

  Future<Either<String, Map<String, dynamic>>> searchPlacesOpenNowQuery(
      {double? radius, String? query, bool? openNow}) async {
    LocationDetails? locationDetail = await getLocationDetails();
    final lat = locationDetail?.latitude;
    final lng = locationDetail?.longitude;

    final endpoint = openNow ?? false
        ? 'search?sort=DISTANCE&ll=${lat}%2C${lng}&query=$query'
        : radius == null
            ? 'search?sort=DISTANCE&ll=$lat%2C$lng&open_now=${openNow ?? true}&query=$query'
            : 'search?sort=DISTANCE&ll=$lat%2C$lng&open_now=true&radius=${radius.toInt()}';
    return _searchPlaces('$endpoint&$fields');
  }

  Future<Either<String, Map<String, dynamic>>> searchNearByPlaces({
    required double radius,
    LocationData? location,
  }) async {
    // LocationData? location2 = location ?? await locationCheck();
    LocationDetails? locationDetail = await getLocationDetails();
    final endpoint =
        'search?sort=DISTANCE&ll=${locationDetail?.latitude}%2C${locationDetail?.longitude}&radius=${radius.toInt()}&limit=5&$fields';
    return _searchPlaces(endpoint);
  }

  Future<Either<String, Map<String, dynamic>>> searchTopPlaces({
    required int limit,
    double? userLat,
    double? userLng,
  }) async {
    LocationDetails? locationDetail = await getLocationDetails();
    final lat = userLat ?? locationDetail?.latitude;
    final lng = userLng ?? locationDetail?.longitude;
    final endpoint =
        'search?sort=DISTANCE&ll=${lat}%2C${lng}&sort=RATING&limit=$limit&$fields';
    return _searchPlaces(endpoint);
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
      return const Left('Failed to load places');
    }
  }

  Future<Either<String, Map<String, dynamic>>> getNextPage(
      String nextPage) async {
    final dio = _getDioInstance();
    final response = await dio.get(nextPage);
    return _handleResponse(response);
  }

  // api for photos

  Future<Either<String, List<PhotoModel>>> getPhotos({
    required String fsqId,
  }) async {
    final api = 'https://api.foursquare.com/v3/places/${fsqId}/photos';
    final dio = _getDioInstance();
    final response = await dio.get(api);

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> placesData =
          List<Map<String, dynamic>>.from(response.data);
      final List<PhotoModel> photos = placesData
          .map((photoData) => PhotoModel.fromJson(photoData))
          .toList();
      return Right(photos);
    } else {
      return Left('Failed to load photos');
    }
  }
}
