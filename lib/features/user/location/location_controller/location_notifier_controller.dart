

import 'package:opclo/features/user/location/model/location_detail.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';

final locationDetailNotifierCtr = ChangeNotifierProvider((ref) => LocationNotifierController());

class LocationNotifierController extends ChangeNotifier{

  LocationDetails? _locationDetail;
  LocationDetails? get locationDetail => _locationDetail;

  setLocationDetail(LocationDetails? model){
    _locationDetail = model;
    notifyListeners();
  }
}