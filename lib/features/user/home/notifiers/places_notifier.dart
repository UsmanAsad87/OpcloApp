import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';

import '../../../../commons/common_functions/check_conectivity.dart';
import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../commons/common_functions/service_enabled.dart';
import '../../../../models/place_model.dart';
import '../../restaurant/controller/places_controller.dart';


final placesProvider =
StateNotifierProvider<PlacesNotifier, PlacesState>((ref) {
  return PlacesNotifier(ref);
});


class PlacesNotifier extends StateNotifier<PlacesState> {
  final Ref ref;

  PlacesNotifier(this.ref) : super(PlacesState.initial());

  Future<void> getInitialPlaces(String categoriesId) async {
    final isPrem =
        ref.read(authNotifierCtr).userModel?.subscriptionIsValid ?? false;
    state = state.copyWith(
        isLoading: true,
        isInternet: true,
        locationEnabled: true,
        isPremium: isPrem);

    final isInternet = await isInternetConnected();
    if (!isInternet) {
      state = state.copyWith(isInternet: false, isLoading: false);
      return;
    }

    final locationEnabled = await serviceEnabled();

    if (!locationEnabled) {
      state = state.copyWith(
        locationEnabled: false,
        isLoading: false,
      );
      return;
    }

    final ctr = ref.read(placesControllerProvider.notifier);
    final result = categoriesId == 'nearby'
        ? await ctr.getSearchPlacesNearBy(radius: 10000)
        : await ctr.getSearchPlacesByCategories(
            categories: categoriesId,
            openNow: false,
          );

    state = state.copyWith(
      places: result.places ?? [],
      isLoading: false,
      nextPageLink: extractNextPageLink(result.link),
      pageIndex: 1,
    );
  }

  Future<void> loadNextPage() async {
    if (state.nextPageLink == null ||
        state.pageIndex >= (state.isPremium ? 5 : 3)) return;

    final result = await ref
        .read(placesControllerProvider.notifier)
        .getNextPage(nextPage: state.nextPageLink!);

    state = state.copyWith(
      places: [...state.places, ...(result.places ?? [])],
      nextPageLink: extractNextPageLink(result.link),
      isLoading: false,
      pageIndex: state.pageIndex + 1,
    );
  }

  clear() {
    state = state.copyWith(
      isLoading: true,
      isInternet: true,
      locationEnabled: true,
      places: [],
      nextPageLink: null,
      pageIndex: 0,
      isPremium: false,
    );
  }
}

class PlacesState {
  final bool isLoading;
  final bool isInternet;
  final bool locationEnabled;
  final List<PlaceModel> places;
  final String? nextPageLink;
  final int pageIndex;
  final bool isPremium;

  PlacesState({
    required this.isLoading,
    required this.isInternet,
    required this.locationEnabled,
    required this.places,
    required this.nextPageLink,
    required this.pageIndex,
    required this.isPremium,
  });

  factory PlacesState.initial() {
    return PlacesState(
      isLoading: true,
      isInternet: true,
      locationEnabled: true,
      places: [],
      nextPageLink: null,
      pageIndex: 0,
      isPremium: false,
    );
  }

  PlacesState copyWith({
    bool? isLoading,
    bool? isInternet,
    bool? locationEnabled,
    List<PlaceModel>? places,
    String? nextPageLink,
    int? pageIndex,
    bool? isPremium,
  }) {
    return PlacesState(
      isLoading: isLoading ?? this.isLoading,
      isInternet: isInternet ?? this.isInternet,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      places: places ?? this.places,
      nextPageLink: nextPageLink ?? this.nextPageLink,
      pageIndex: pageIndex ?? this.pageIndex,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

