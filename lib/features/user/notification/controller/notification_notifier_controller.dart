import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';

final notificationNotifierCtr = ChangeNotifierProvider((ref) => NotificationNotifierController());
class NotificationNotifierController extends ChangeNotifier{


  int _totalNumberOfNotificationDisplayed = 0;

  int get TotalNumberOfNotificationDisplayed => _totalNumberOfNotificationDisplayed;

  setSelectedOption(int? value){
      _totalNumberOfNotificationDisplayed =  value ?? 0;
    notifyListeners();
  }
  increment(){
    _totalNumberOfNotificationDisplayed++;
    notifyListeners();
  }
}