import 'package:location/location.dart';
import 'package:opclo/features/user/restaurant/api/places_api.dart';
import 'package:opclo/models/photo_model.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/place_model.dart';
import '../../location/model/location_detail.dart';
import '../api/quick_acess_places_api.dart';


final quickAccessPlacesControllerProvider =
    StateNotifierProvider<QuickAccessPlacesController, bool>((ref) {
  return QuickAccessPlacesController(
    databaseApis: ref.watch(quickAccessPlacesApisProvider),
  );
});

final getQuickAccessPlacesByIdProvider = FutureProvider.family((ref, String fsq) {
  final databaseProvider = ref.watch(quickAccessPlacesControllerProvider.notifier);
  return databaseProvider.getPlaceById(fsq: fsq);
});


class QuickAccessPlacesController extends StateNotifier<bool> {
  final QuickAccessPlacesApi _databaseApis;

  QuickAccessPlacesController({required QuickAccessPlacesApi databaseApis})
      : _databaseApis = databaseApis,
        super(false);

  Future<LocationDetails?> getLocationDetails() async {
    try {
      LocationDetails? locationDetail = await _databaseApis.getLocationDetails();
      return locationDetail;
    } catch (e) {
      debugPrint('Error getting location details: $e');
      return null;
    }
  }

  Future<PlaceModel?> getPlaceById({
    required String fsq,
  }) async {
    final result = await _databaseApis.searchPlaceById(
      fsq: fsq,
    );
    return result.fold((l) => null, (r) => PlaceModel.fromJson(r));
    // return _handlePlacesAndLinkResult(result);
  }

}

class PlacesAndLink {
  final List<PlaceModel>? places;
  final List<String>? link;

  PlacesAndLink(this.places, this.link);
}
