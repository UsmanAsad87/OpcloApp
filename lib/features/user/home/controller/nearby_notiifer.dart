import 'package:location/location.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import '../../../../commons/common_functions/is_alert_exprire.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_providers/shared_pref_helper.dart';
import '../../../../models/alert_model.dart';
import '../../../../models/place_model.dart';
import '../../alert/controller/alert_controller.dart';
import '../../main_menu/widgets/custom_dialog.dart';
import '../../restaurant/controller/places_controller.dart';

class NearByController {
  final PlacesController _placesController;
  final AlertController _alertController;
  final LocationService _locationService = LocationService();
  List<AlertModel> _alerts = [];
  List<PlaceModel> _places = [];
  PlaceModel? _selectedPlace;
  List<DisplayedDialog> displayedDialogs = [];

  NearByController(
      {required PlacesController placesController,
      required AlertController alertController})
      : _placesController = placesController,
        _alertController = alertController;

  Future<void> init({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final locationData = await _locationService.locationStream.first;
      if (await isAlertNearby(locationData) &&
          !ref.watch(authNotifierCtr).isShown) {
        ref.watch(authNotifierCtr).setShown(isShown: true);
        // if (ModalRoute.of(context)?.isCurrent ?? false) {
        displayedDialogs.add(DisplayedDialog(
          fsqId: _selectedPlace!.fsqId,
          displayedTime: DateTime.now(),
        ));
        showDialog(
          context: context,
          barrierColor: MyColors.black.withOpacity(.2),
          builder: (context) {
            Future.delayed(const Duration(seconds: 5), () {
              if (context.mounted &&
                  (ModalRoute.of(context)?.isCurrent ?? false)) {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            });
            return CustomDialog(
              place: _selectedPlace!,
              alert: _alerts.isNotEmpty ? _alerts[0] : null,
            );
          },
        );
        // }
      }
    } catch (e) {
      debugPrint('exception $e');
    }
  }

  Future<bool> isAlertNearby(LocationData locationData) async {
    final int distance = await _alertController.getDistance() ?? 500;
    final result = await _placesController.getSearchPlacesNearBy(
        radius: distance.toDouble(), location: locationData);

    _places = await result.places ?? [];

    if (_places.isEmpty) {
      return false;
    }

    for (int i = 0; i < _places.length; i++) {
      final place = _places[i];
      if (hasPlaceDisplayed(place.fsqId)) {
        _selectedPlace = null;
        continue;
      }
      _selectedPlace = place;
      SharedPrefHelper.setPlaceFsqId(_selectedPlace!.fsqId);
      SharedPrefHelper.setNotificationTime(DateTime.now());
      try {
        final alerts = await _alertController
            .getAllAlerts(fsqId: _selectedPlace!.fsqId)
            .first;
        _alerts = alerts.isEmpty
            ? []
            : alerts; //[alerts.firstWhere((alert) => !isAlertExpired(alert))];
      } catch (e) {
        _alerts = [];
      }
      break;
    }
    return _selectedPlace != null;
  }

  bool hasPlaceDisplayed(String fsqId) {
    for (final dialog in displayedDialogs) {
      if (dialog.fsqId == fsqId) {
        return true;
      }
    }
    return false;
  }
}

class LocationService {
  final Location _location = Location();

  Stream<LocationData> get locationStream => _location.onLocationChanged;
}

class DisplayedDialog {
  final String fsqId;
  final DateTime displayedTime;

  DisplayedDialog({required this.fsqId, required this.displayedTime});
}
