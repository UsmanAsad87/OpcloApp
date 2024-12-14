import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';

final sheetHeightProvider = ChangeNotifierProvider((ref) => QuickSheetController());

class QuickSheetController extends ChangeNotifier{
  double _height = 40;
  double? get height => _height;
  bool _isClosed = true;
  bool get isClosed=> _isClosed;

  setHeight(double height){
    _height = height;
    notifyListeners();
  }
  setClosed(bool isClosed){
    _isClosed = isClosed;
    notifyListeners();
  }

  bool _isOpen = false;
  bool get isOpen => _isOpen;
  setSheetStatus(bool val){
    _isOpen = val;
    notifyListeners();
  }

}