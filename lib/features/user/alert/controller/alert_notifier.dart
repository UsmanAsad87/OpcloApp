import 'package:opclo/commons/common_enum/alert_type.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';

final selectedAlertOptionNotifier =
    ChangeNotifierProvider<SelectedAlertOption>((ref) => SelectedAlertOption());

class SelectedAlertOption extends ChangeNotifier {
  AlertTypeEnum _selectedAlertOption = AlertTypeEnum.dineInClosed;
  String _selectedFsqId = '';
  String _selectedPlaceName = '';

  AlertTypeEnum get selectedAlertOption => _selectedAlertOption;

  String get selectedFsqId => _selectedFsqId;

  String get selectedPlaceName => _selectedPlaceName;

  void setOption({
    required AlertTypeEnum option,
  }) {
    _selectedAlertOption = option;
    notifyListeners();
  }

  void setFsqId({required String fsqId}) {
    _selectedFsqId = fsqId;
    notifyListeners();
  }
  void setplaceName({required String placeName}) {
    _selectedPlaceName = placeName;
    notifyListeners();
  }
}
