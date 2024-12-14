// import 'package:flutter/material.dart';
// import '../../../../commons/common_imports/apis_commons.dart';
//
// class FilterModel extends ChangeNotifier {
//   List<bool> selectedStates = [true, false, false,false, false, false,false, false];
//
//   void selectChip(int index) {
//     for (int i = 0; i < selectedStates.length; i++) {
//       selectedStates[i] = (i == index);
//     }
//     notifyListeners();
//   }
// }
//
// final filterModelProvider = ChangeNotifierProvider<FilterModel>((ref) {
//   return FilterModel();
// });