import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../commons/common_imports/common_libs.dart';

final subscriptionNotifierCtr = ChangeNotifierProvider((ref) => SubscriptionNotifierController());
class SubscriptionNotifierController extends ChangeNotifier{
  bool _isSubscriptionTapped = false;

  bool get isSubscriptionTapped => _isSubscriptionTapped;

  setSubscriptionTap({required isSubsTapped}) {
    _isSubscriptionTapped = isSubsTapped;
    notifyListeners();
  }
}