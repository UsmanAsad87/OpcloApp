import 'package:flutter/material.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../models/place_model.dart';

final selectedLocationProvider = ChangeNotifierProvider.autoDispose<SelectedLocation>((ref) {
  return SelectedLocation();
});

class SelectedLocation extends ChangeNotifier {
  PlaceModel? _selectedPlace;

  PlaceModel? get selectedPlace => _selectedPlace;

  void selectPlace(PlaceModel? placeModel) {
    _selectedPlace = placeModel;
    notifyListeners();
  }
}

// class SelectedLocation extends ChangeNotifier {
//   int _selectedIndex = -1;
//
//   int get selectedIndex => _selectedIndex;
//
//   void selectIndex(int index) {
//     _selectedIndex = index;
//     notifyListeners();
//   }
// }