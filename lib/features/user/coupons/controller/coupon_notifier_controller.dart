import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';

final couponNotifierCtr = ChangeNotifierProvider((ref) => CouponNotifierController());
class CouponNotifierController extends ChangeNotifier{


  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  setSelectedOption(int? value){
      _selectedIndex =  value ?? 0;
    notifyListeners();
  }
}