import 'package:opclo/models/favorite_model.dart';

import '../../../commons/common_imports/apis_commons.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../../../models/user_model.dart';

final authNotifierCtr = ChangeNotifierProvider((ref) => AuthNotifierController());
class AuthNotifierController extends ChangeNotifier{


  UserModel? _userModel;
  UserModel? get userModel=> _userModel;
  bool? _isLoggedIn;
  bool? get isLoggedIn=> _isLoggedIn;

  setUserModelData(UserModel? model){
    _userModel = model;
    notifyListeners();
  }

  setLoggedIn(bool isLoggedIn){
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  bool _isShown = false;

  bool get isShown => _isShown;

  setShown({required isShown}) {
    _isShown = isShown;
    notifyListeners();
  }
}