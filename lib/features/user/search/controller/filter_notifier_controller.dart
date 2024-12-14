import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';

import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/place_model.dart';
import '../../restaurant/controller/places_controller.dart';
import '../widgets/sort_container.dart';
import '../widgets/status_container.dart';

final filterNotifierCtr =
    ChangeNotifierProvider((ref) => FilterNotifierController());

class FilterNotifierController extends ChangeNotifier {
  SortingOption? _selectedSortOption;
  StatusOption? _selectedStatus;
  int? _distanceValue;
  int? _distance = 25;
  bool _isLoading = true;
  List<PlaceModel>? _result;
  bool _nearBy = false;
  TextEditingController _searchController = TextEditingController();
  String? _nextPageLink;
  bool _nextPageLoading = false;
  int pageIndex = 0;

  SortingOption? get selectedSortOption => _selectedSortOption;

  StatusOption? get selectedStatus => _selectedStatus;

  int? get distanceValue => _distanceValue;

  int? get distance => _distance;

  bool get isLoading => _isLoading;

  bool get nearBy => _nearBy;

  String? get nextPageLink => _nextPageLink;

  bool get nextPageLoading => _nextPageLoading;

  List<PlaceModel>? get result => _result;

  TextEditingController get searchController => _searchController;

  void selectSortOption(SortingOption? option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void selectStatusOption(StatusOption? option) {
    _selectedStatus = option;
    notifyListeners();
  }

  void setDistanceValue(int value) {
    _distance = value;
    _distanceValue = value * 1609 > 100000 ? 100000 : value * 1609;
    // _distanceValue = value * 1000;
    notifyListeners();
  }

  void setSearchController(String value) {
    _searchController.text = value;
    notifyListeners();
  }

  void setNearBy(bool value) {
    _nearBy = value;
    notifyListeners();
  }

  search({required WidgetRef ref, String? query, required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();
    final placesAndLink  = await ref
        .read(placesControllerProvider.notifier)
        .getSearchPlacesQuery(query: query ?? _searchController.text, context: context);
    _result = placesAndLink.places;
    _nextPageLink = extractNextPageLink(placesAndLink.link);
    _isLoading = false;
    pageIndex = 0;
    notifyListeners();
  }


  void loadNextPage({required WidgetRef ref}) async {
    final isPrem = ref.read(authNotifierCtr).userModel?.subscriptionIsValid ?? false;
    if (_nextPageLink == null ||
        pageIndex >= (isPrem ? 5 : 3)) return;
    _nextPageLoading = true;
    notifyListeners();
    if(_nextPageLink != null){
    PlacesAndLink result = await ref
        .read(placesControllerProvider.notifier)
        .getNextPage(nextPage: _nextPageLink!);
      _result?.addAll(result.places ?? []);
      _nextPageLink = extractNextPageLink(result.link);
    }
    _nextPageLoading = false;
    pageIndex++;
    notifyListeners();
    }


  applyFilter(
      {required WidgetRef ref,
      required BuildContext context,
      bool? isPop}) async {
    _isLoading = true;
    notifyListeners();
    String query = searchController.text;
    if (_selectedSortOption != null) {
      query += '&sort=${selectedSortOption?.value}';
    }
    if (_selectedStatus != null && _selectedStatus?.value != 'all') {
      query += '&open_now=${_selectedStatus?.value}';
    }
    if (_distanceValue != null || nearBy) {
      query += '&radius=${nearBy ? '32186.9' : _distanceValue}';
    }
    final placesAndLink = await ref
        .read(placesControllerProvider.notifier)
        .getSearchPlacesQuery(query: query, context: context);
    _result = placesAndLink.places;
    _nextPageLink = extractNextPageLink(placesAndLink.link);
    if (isPop ?? true) {
      Navigator.of(context).pop();
    }
    _isLoading = false;
    notifyListeners();
  }

  disposeAll({required BuildContext context}) {
    _selectedSortOption = null;
    _selectedStatus = null;
    _distanceValue = null;
    _distance = 20;
    _nearBy = false;
    pageIndex = 0;
    Navigator.of(context).pop();
    notifyListeners();
  }
}
