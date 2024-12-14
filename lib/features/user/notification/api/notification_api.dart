import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/models/notification_model.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_providers/global_providers.dart';
import '../../../../core/constants/firebase_constants.dart';

final notificationApisProvider = Provider<NotificationDatabaseApi>((ref) {
  final fireStoreProvider = ref.watch(firebaseDatabaseProvider);
  return NotificationDatabaseApi(fireStore: fireStoreProvider);
});

class NotificationDatabaseApi {
  final FirebaseFirestore _fireStore;

  NotificationDatabaseApi({required FirebaseFirestore fireStore})
      : _fireStore = fireStore;

  Stream<List<NotificationModel>> getNotificationList(
      {required String userId,}) {
    return _fireStore
        .collection(FirebaseConstants.userCollection)
        .doc(userId)
        .collection(FirebaseConstants.notificationCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      List<NotificationModel> models = [];
      for (var document in event.docs) {
        var model = NotificationModel.fromMap(document.data());
        models.add(model);
      }
      return models;
    });
  }

  FutureEitherVoid addNotification(
      {required String userId,
        required NotificationModel notification}) async {
    try {
      await _fireStore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.notificationCollection)
          .doc(notification.notificationId)
          .set(notification.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }


  FutureEitherVoid deleteNotification(
      {required String userId, required NotificationModel notification}) async {
    try {
      await _fireStore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.notificationCollection)
          .doc(notification.notificationId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }
}
