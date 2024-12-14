import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/features/user/notification/api/notification_api.dart';
import '../../../../models/notification_model.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';

final notificationController =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationDatabaseApi = ref.watch(notificationApisProvider);
  final AuthDatabaseApi = ref.watch(authApisProvider);
  return NotificationController(
      notificationDatabaseApi: notificationDatabaseApi,
      authApis: AuthDatabaseApi);
});

final fetchAllNotificationProvider =
    StreamProvider((ref,) {
  final notificationCtr = ref.watch(notificationController.notifier);
  return notificationCtr.getAllNotification();
});

class NotificationController extends StateNotifier<bool> {
  final NotificationDatabaseApi _notificationDatabaseApi;
  final AuthApis _authAPis;

  NotificationController(
      {required NotificationDatabaseApi notificationDatabaseApi,
      required AuthApis authApis})
      : _authAPis = authApis,
        _notificationDatabaseApi = notificationDatabaseApi,
        super(false);

  Stream<List<NotificationModel>> getAllNotification() {
    final userId = _authAPis.getCurrUser()?.uid;
    return _notificationDatabaseApi.getNotificationList(userId: userId ?? '');
  }

  Future<void> addNotification({
    required NotificationModel model,
  }) async {
    state = true;
    final userId = _authAPis.getCurrUser()?.uid;
    final result = await _notificationDatabaseApi.addNotification(
        notification: model, userId: userId ?? '');
    result.fold((l) {
      state = false;
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      // showToast(msg: l.message);
    }, (r) {
      state = false;
      // showToast(msg:  ' Posted Successfully!');
    });
    state = false;
  }

  Future<void> deleteNotification({
    required NotificationModel model,
  }) async {
    state = true;
    final userId = _authAPis.getCurrUser()?.uid;
    final result = await _notificationDatabaseApi.deleteNotification(
        notification: model, userId: userId ?? '');
    result.fold((l) {
      state = false;
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      // showToast(msg: l.message);
    }, (r) {
      state = false;
      // showToast(msg:  ' Posted Successfully!');
    });
    state = false;
  }
}
