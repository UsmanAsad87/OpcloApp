import 'dart:math';
import 'package:location/location.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../models/place_model.dart';
import '../../../../models/user_model.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../location/location_controller/location_notifier_controller.dart';


final distanceNotifierProvider =
StateNotifierProvider<DistanceNotifier, Map<String, double>>((ref) {
  return DistanceNotifier(ref);
});

final calculateDistanceNotifierProvider = FutureProvider.family((ref, PlaceModel place) {
  return DistanceNotifier(ref).distanceInMilesInDouble(place);
});


class DistanceNotifier extends StateNotifier<Map<String, double>> {
  final Ref ref;
  DistanceNotifier(this.ref) : super({}){
    _initializeLocation();
  }

  double lat1 = 37.4219983;
  double lon1 = -122.084;


  Future<void> _initializeLocation() async {
    final locationRef = ref.read(locationDetailNotifierCtr).locationDetail;
    final UserModel? user = ref.read(authNotifierCtr).userModel;

     if (locationRef != null) {
       lat1 = locationRef.latitude;
       lon1 = locationRef.longitude;
     } else {
       final location = await locationCheck();
       lat1 = location?.latitude ??
           user?.homeAddress?.latitude ??
           user?.workAddress?.latitude ??
           0;
       lon1 = location?.longitude ??
           user?.homeAddress?.longitude ??
           user?.workAddress?.longitude ??
           0; // Fix here
     }

  }


  Future<double> distanceInMilesInDouble(PlaceModel place,) async {
    const earthRadiusMiles = 3958.8;

    double dLat = degreesToRadians(place.lat - lat1);
    double dLon = degreesToRadians(place.lon - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(place.lat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadiusMiles * c;

    return distance;
  }

  Future<LocationData?> locationCheck() async {
    Location location = Location();
    return await location.getLocation();
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

}