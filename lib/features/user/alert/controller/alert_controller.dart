import 'package:opclo/commons/common_enum/notification_enum.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/api/occasion_api.dart';
import 'package:opclo/features/user/restaurant/controller/place_subscription_controller.dart';
import 'package:opclo/models/notification_model.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/show_toast.dart';
import '../../../../commons/common_enum/alert_type.dart';
import '../../../../firebase_messaging/firebase_messaging_class.dart';
import '../../../../main.dart';
import '../../../../models/alert_comment_model/alert_comment_model.dart';
import '../../../../models/alert_model.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';
import '../api/alert_api.dart';
import '../widgets/thanks_dialog.dart';

/// for notification
final alertControllerProviderForNotification = Provider<AlertController>((ref) {
  return AlertController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(alertDatabaseApiProvider),
  );
});

final alertControllerProvider =
    StateNotifierProvider<AlertController, bool>((ref) {
  return AlertController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(alertDatabaseApiProvider),
  );
});

final getAllAlertsProvider = StreamProvider.family((ref, String fsqId) {
  final customerCtr = ref.watch(alertControllerProvider.notifier);
  return customerCtr.getAllAlerts(fsqId: fsqId);
});

/// alert comments

final getAllAlertCommentsProvider = StreamProvider.family((ref, String fsqId) {
  final customerCtr = ref.watch(alertControllerProvider.notifier);
  return customerCtr.getAllAlertComments(fsqId: fsqId);
});


final getThumbsUpCountProvider = StreamProvider.family((ref, String alertId) {
  final customerCtr = ref.watch(alertControllerProvider.notifier);
  return customerCtr.thumbUpCount(alertId: alertId);
});


class AlertController extends StateNotifier<bool> {
  final AuthApis _authApis;
  final AlertDatabaseApi _databaseApis;

  AlertController({
    required AuthApis authApis,
    required AlertDatabaseApi databaseApis,
  })  : _authApis = authApis,
        _databaseApis = databaseApis,
        super(false);

  Future<void> addAlert({
    required BuildContext context,
    required WidgetRef ref,
    required AlertModel alertModel,
  }) async {
    state = true;
    final userId = _authApis.getCurrentUserId();
    final oldAlert = await _databaseApis.getMatchAlertAlerts(
        fsqId: alertModel.fsqId, alertType: alertModel.option);
    final result;
    if (oldAlert != null) {
      final expiryDate = DateTime.now().add(Duration(
          days: getExpireHours(oldAlert.option)
      ));
      print(expiryDate);
      final updateAlert = oldAlert.copyWith(
        uploadDate: DateTime.now(),
        date: expiryDate,
        userId: userId,
      );
      result = await _databaseApis.addAlert(alertModel: updateAlert);
    } else {
      final updateAlert = alertModel.copyWith(userId: userId);
      result = await _databaseApis.addAlert(alertModel: updateAlert);
    }
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      NotificationModel notificationModel = NotificationModel(
          title: 'Opclo Alert',
          notificationId: Uuid().v4(),
          description: 'New alert for ${alertModel.placeName}',
          createdAt: DateTime.now(),
          notificationType: NotificationEnum.alert,
          placeId: alertModel.fsqId,
          placeName: alertModel.placeName,
          alertType: alertModel.option);
      ref.read(notificationProvider).pushNotificationsGroupDevice(
            ref: ref,
            context: context,
            model: notificationModel,
            // registerIds: fcmTokens
          );
      Navigator.of(context).pop();
      showDialog(
        context: navigatorKey.currentContext!,
        barrierColor: Colors.transparent,
        builder: (_) {
          return const ThanksDialog();
        },
      );
      Future.delayed(const Duration(seconds: 2), () {
        navigatorKey.currentState?.pop(); // Dismiss the dialog
      });
    });
  }

  int getExpireHours(AlertTypeEnum option) {
    switch (option) {
      case AlertTypeEnum.womenOwned:
      case AlertTypeEnum.blackOwned:
      case AlertTypeEnum.incorrectHour:
      case AlertTypeEnum.dineInClosed:
      case AlertTypeEnum.driveThruClosed:
        return 7;
      case AlertTypeEnum.movedLocation:
        return 60;
      case AlertTypeEnum.maintenance:
      case AlertTypeEnum.construction:
        return 2;
      case AlertTypeEnum.cardForVaccine:
      case AlertTypeEnum.socialDistancing:
        return 30;
      default:
        return 7;
    }
  }

  Stream<List<AlertModel>> getAllAlerts({required String fsqId}) {
    try {
      Stream<List<AlertModel>> alerts = _databaseApis.getAllAlerts(
        fsqId: fsqId,
      );
      return alerts;
    } catch (error) {
      return const Stream.empty();
    }
  }

  Future<void> deleteAlert({
    required BuildContext context,
    required String alertId,
  }) async {
    state = true;
    final result = await _databaseApis.deleteAlert(alertId: alertId);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Alert deleted successfully');
      Navigator.of(context).pop();
    });
  }

  /// get distance
  Future<int?> getDistance() async {
    try {
      return _databaseApis.getDistance();
    } catch (error) {}
    return null;
  }

  ///   add alert comment

  Future<void> addAlertComment({
    required BuildContext context,
    required AlertCommentModel alertCommentModel,
  }) async {
    state = true;
    final result = await _databaseApis.addAlertComment(
        alertCommentModel: alertCommentModel);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showToast(msg: 'Comment added successfully');
      // Navigator.of(context).pop();
    });
  }

  Stream<List<AlertCommentModel>> getAllAlertComments({required String fsqId}) {
    try {
      Stream<List<AlertCommentModel>> alerts =
          _databaseApis.getAllAlertComments(
        fsqId: fsqId,
      );
      return alerts;
    } catch (error) {
      return const Stream.empty();
    }
  }

  /// add thumbsUp

  Future<void> addThumbsUp(
      {required BuildContext context, required String alertId}) async {
    state = true;
    final userId = _authApis.getCurrentUserId();
    final result =
        await _databaseApis.addThumbsUp(userId: userId ?? '', alertId: alertId);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showToast(msg: 'Liked successfully');
    });
  }

  Stream<int> thumbUpCount({required String alertId}) {
    try {
      return _databaseApis.thumbUp(alertId: alertId);
    } on Exception catch (e) {
      return Stream.empty();
    }
  }
}
