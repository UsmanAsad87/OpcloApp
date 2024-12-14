import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:opclo/features/auth/data/auth_apis/auth_apis.dart';
import 'package:opclo/features/auth/data/auth_apis/database_apis.dart';
import 'package:opclo/features/user/restaurant/api/places_api.dart';
import 'package:opclo/models/photo_model.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../models/place_model.dart';
import '../../../../models/user_model.dart';

/// for notification
final placesControllerProviderForNotification =
    Provider<PlacesController>((ref) {
  return PlacesController(
    placesApis: ref.watch(placesApisProvider),
    databaseApis: ref.watch(databaseApisProvider),
  );
});

final placesControllerProvider =
    StateNotifierProvider<PlacesController, bool>((ref) {
  return PlacesController(
      placesApis: ref.watch(placesApisProvider),
      databaseApis: ref.watch(databaseApisProvider));
});

// final placesQueryStreamProvider = StreamProvider.autoDispose<List<PlaceModel>?>((ref) {
//   final databaseProvider = ref.watch(placesControllerProvider.notifier);
//   return databaseProvider.getSearchPlacesQuery();
// });

final topPlacesStreamProvider = FutureProvider.family((ref, int limit) {
  final databaseProvider = ref.watch(placesControllerProvider.notifier);
  return databaseProvider.getTopPlace(limit: limit);
});

final getPlacesByIdProvider =
    FutureProvider.autoDispose.family((ref, String fsq) {
  final databaseProvider = ref.watch(placesControllerProvider.notifier);
  return databaseProvider.getPlaceById(fsq: fsq);
});

final getPhotosProvider = FutureProvider.family((ref, String fsq) {
  final databaseProvider = ref.watch(placesControllerProvider.notifier);
  return databaseProvider.getphoto(
    fsqId: fsq,
  );
});

final getNearPlaceProvider = FutureProvider((ref) {
  final databaseProvider = ref.watch(placesControllerProvider.notifier);
  return databaseProvider.getSearchPlacesNearBy(
    radius: 500,
  );
});

final getOpenNowPlaceProvider = FutureProvider.family((ref, String categoryId) {
  final databaseProvider = ref.watch(placesControllerProvider.notifier);
  return databaseProvider.getSearchPlacesByCategories(
      categories: categoryId, openNow: true);
});

class PlacesController extends StateNotifier<bool> {
  final PlacesApi _placesApis;
  final DatabaseApis _database;

  PlacesController(
      {required PlacesApi placesApis, required DatabaseApis databaseApis})
      : _placesApis = placesApis,
        _database = databaseApis,
        super(false);

  List<PlaceModel> _convertToPlaceModels(
    List<Map<String, dynamic>>? places,
  ) {
    // print(places);
    if (places == null) {
      return [];
    }
    return places.map((placeMap) => PlaceModel.fromJson(placeMap)).toList();
  }

  Future<PlacesAndLink> _handlePlacesAndLinkResult(
    Either<String, Map<String, dynamic>> result,
  ) async {
    return result.fold<PlacesAndLink>(
      (error) => PlacesAndLink([], []),
      (data) => PlacesAndLink(
        _convertToPlaceModels(data['places']),
        data['link'] == '' ? [] : data['link'],
      ),
    );
  }

  Future<PlacesAndLink> getSearchPlacesQuery(
      {required BuildContext context, required String query}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final UserModel? user =
        uid == null ? null : await _database.getUserInfoByUid(uid ?? '').first;
    final isPremium = user?.subscriptionIsValid ?? false;
    final result = await _placesApis.searchPlacesWithOnlyQuery(
        query: query, context: context, isPrem: isPremium);
    return _handlePlacesAndLinkResult(result);
  }

  Future<PlacesAndLink> getSearchPlacesByCategories({
    required String categories,
    required bool openNow,
  }) async {
    final result = await _placesApis.searchPlacesByCategory(
        categories: categories, openNow: openNow);
    return _handlePlacesAndLinkResult(result);
  }

  // Future<PlacesAndLink> getSearchPlacesOpenNow(
  //     {required String categories}) async {
  //   final result = await _databaseApis.searchPlacesOpenNow(categories);
  //   return _handlePlacesAndLinkResult(result);
  // }

  Future<PlacesAndLink> storeUsingChainId({required String chainId}) async {
    state = true;
    final result = await _placesApis.storeUsingChainId(chainId);
    state = false;
    return _handlePlacesAndLinkResult(result);
  }

  Future<PlacesAndLink> getSearchPlacesOpenNowQuery(
      {double? radius, String? query, bool? openNow}) async {
    state = true;
    final result = await _placesApis.searchPlacesOpenNowQuery(
        query: query, radius: radius, openNow: openNow);
    state = false;
    return _handlePlacesAndLinkResult(result);
  }

  Future<PlacesAndLink> getSearchPlacesOpenNowQueryWithoutState(
      {double? radius, String? query, bool? openNow}) async {
    final result = await _placesApis.searchPlacesOpenNowQuery(
        query: query, radius: radius, openNow: openNow);
    return _handlePlacesAndLinkResult(result);
  }

  Future<PlacesAndLink> getSearchPlacesNearBy(
      {required double radius, LocationData? location}) async {
    final result = await _placesApis.searchNearByPlaces(
      location: location,
      radius: radius,
    );
    return _handlePlacesAndLinkResult(result);
  }

  Future<PlacesAndLink> getTopPlace({
    required int limit,
    double? userLat,
    double? userLng,
  }) async {
    final result = await _placesApis.searchTopPlaces(
      limit: limit,
      userLat: userLat,
      userLng: userLng,
    );
    return _handlePlacesAndLinkResult(result);
  }

  Future<PlaceModel?> getPlaceById({
    required String fsq,
  }) async {
    final result = await _placesApis.searchPlaceById(
      fsq: fsq,
    );
    return result.fold((l) => null, (r) => PlaceModel.fromJson(r));
    // return _handlePlacesAndLinkResult(result);
  }

  Future<PlacesAndLink> getNextPage({required String nextPage}) async {
    final result = await _placesApis.getNextPage(nextPage);
    return _handlePlacesAndLinkResult(result);
  }

  Future<List<PhotoModel>> getphoto({required String fsqId}) async {
    final result = await _placesApis.getPhotos(fsqId: fsqId);
    return result.fold((l) => [], (r) => r);
  }
}

class PlacesAndLink {
  final List<PlaceModel>? places;
  final List<String>? link;

  PlacesAndLink(this.places, this.link);
}
