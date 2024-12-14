import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_providers/global_providers.dart';
import '../../../../../../core/constants/firebase_constants.dart';
import '../../../../models/alert_comment_model/alert_comment_model.dart';
import '../../../../models/alert_model.dart';

final alertDatabaseApiProvider = Provider<AlertDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return AlertDatabaseApi(firebase: firebase);
});

class AlertDatabaseApi {
  final FirebaseFirestore _firestore;

  AlertDatabaseApi({required FirebaseFirestore firebase})
      : _firestore = firebase;

  FutureEitherVoid addAlert({required AlertModel alertModel}) async {
    try {
      CollectionReference alertRef =
      _firestore.collection(FirebaseConstants.alertCollection);
      await alertRef.doc(alertModel.id).set(alertModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<AlertModel>> getAllAlerts({required String fsqId}) {
    try {
      CollectionReference alertRef =
      _firestore.collection(FirebaseConstants.alertCollection);
      return alertRef
          .where('fsqId', isEqualTo: fsqId)
          .where('date', isGreaterThan: DateTime.now().toIso8601String())
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AlertModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Future<AlertModel?> getMatchAlertAlerts({
        required String fsqId,
        required AlertTypeEnum alertType}
      ) async {
    try {
      final alertRef = _firestore.collection(FirebaseConstants.alertCollection);
      final alerts = await alertRef
          .where('fsqId', isEqualTo: fsqId)
          .where('option', isEqualTo: alertType.type)
          .get();
      return AlertModel.fromMap(alerts.docs.first.data());
    } catch (error) {}
    return null;
  }

  FutureEitherVoid deleteAlert({required String alertId}) async {
    try {
      CollectionReference alertRef =
      _firestore.collection(FirebaseConstants.alertCollection);
      await alertRef.doc(alertId).delete();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  /// get distance
  Future<int?> getDistance() async {
    try {
      final alertRef =
      _firestore.collection(FirebaseConstants.distanceCollection);
      final alerts = await alertRef.get();
      if (alerts.docs.isNotEmpty) {
        final data = alerts.docs.first.data();
        return data['distance'] as int;
      }
    } catch (error) {}
    return null;
  }

  /// add alert comment

  FutureEitherVoid addAlertComment(
      {required AlertCommentModel alertCommentModel}) async {
    try {
      CollectionReference alertCommentRef = _firestore
          .collection(FirebaseConstants.alertCollection)
          .doc(alertCommentModel.alertId)
          .collection(FirebaseConstants.alertCommentCollection);
      await alertCommentRef
          .doc(alertCommentModel.id)
          .set(alertCommentModel.toMap());
      _checkAndExtendAlertExpiration(alertId: alertCommentModel.alertId, isComment: true, );
      // _checkAndExtendAlertExpirationOnComment(alertCommentModel.alertId);
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<AlertCommentModel>> getAllAlertComments({required String fsqId}) {
    try {
      CollectionReference alertCommentRef = _firestore
          .collection(FirebaseConstants.alertCollection)
          .doc(fsqId)
          .collection(FirebaseConstants.alertCommentCollection);
      return alertCommentRef
          .orderBy('date', descending: false)
          .limit(25)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AlertCommentModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  /// thumbsUp

  FutureEitherVoid addThumbsUp(
      {required String alertId, required String userId}) async {
    try {
      final alertRef =
      _firestore.collection(FirebaseConstants.alertCollection).doc(alertId);
      final thumbsUpRef = alertRef
          .collection(FirebaseConstants.alertThumbsUpCollection)
          .doc(userId);

      final thumbsUpSnapshot = await thumbsUpRef.get();

      if (!thumbsUpSnapshot.exists) {
        await thumbsUpRef.set({'timestamp': FieldValue.serverTimestamp()});
        await alertRef.update({
          'thumbsUpCount': FieldValue.increment(1),
        });
        await _checkAndExtendAlertExpiration(alertId: alertId, isComment: false);
      } else {
        return Left(
            Failure('You has already given a thumbs-up to this alert', null));
        // print("You has already given a thumbs-up to this alert.");
      }
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Future<void> _checkAndExtendAlertExpiration({required String alertId, required bool isComment}) async {
    final alertRef =
    _firestore.collection(FirebaseConstants.alertCollection).doc(alertId);
    final thumbsUpRef =
    alertRef.collection(FirebaseConstants.alertThumbsUpCollection);
    final commentRef =
    alertRef.collection(FirebaseConstants.alertCommentCollection);
    final alertSnapshot = await alertRef.get();
    if (alertSnapshot.exists && alertSnapshot.data() != null) {
      final data = alertSnapshot.data()!;
      final DateTime currentExpiration = DateTime.parse(data['date']);
      final DateTime expirationDateTime = currentExpiration;
      final oneDayAgo =
      Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 24)));
      final recentThumbsUps =
      await thumbsUpRef.where('timestamp', isGreaterThan: oneDayAgo).get();

      final recentComments =
      await commentRef.where('date', isGreaterThan: DateTime.now().subtract(Duration(hours: 24)).toIso8601String()).get();

      final bool condition = isComment ?
      recentComments.size == 1 && recentComments.size <= 2
          : recentThumbsUps.size == 2 && recentComments.size < 1;
      // if (recentThumbsUps.size == 2 && recentComments.size < 1) {
      if (condition) {
        final newExpiration = expirationDateTime.add(const Duration(hours: 24));
        await alertRef.update({'date': newExpiration.toIso8601String()});
      }
    }
  }

  // Future<void> _checkAndExtendAlertExpirationOnComment(String alertId) async {
  //   final alertRef =
  //       _firestore.collection(FirebaseConstants.alertCollection).doc(alertId);
  //   final alertSnapshot = await alertRef.get();
  //   if (alertSnapshot.exists && alertSnapshot.data() != null) {
  //     final data = alertSnapshot.data()!;
  //     final DateTime currentExpiration = DateTime.parse(data['date']);
  //     final DateTime expirationDateTime = currentExpiration;
  //
  //     final thumbsUpRef =
  //         alertRef.collection(FirebaseConstants.alertThumbsUpCollection);
  //     final commentRef =
  //         alertRef.collection(FirebaseConstants.alertCommentCollection);
  //
  //     final oneDayAgo =
  //         Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 24)));
  //     final recentThumbsUps =
  //         await thumbsUpRef.where('timestamp', isGreaterThan: oneDayAgo).get();
  //
  //     final recentComments =
  //         await commentRef.where('date', isGreaterThan: oneDayAgo).get();
  //
  //     if (recentComments.size == 1 && recentComments.size <= 2) {
  //       final newExpiration = expirationDateTime.add(const Duration(hours: 24));
  //       await alertRef.update({'date': newExpiration.toIso8601String()});
  //     }
  //   }
  // }

  Stream<int> thumbUp({required String alertId}) {
    final alertRef =
    _firestore.collection(FirebaseConstants.alertCollection).doc(alertId);
    final thumbsUpRef =
    alertRef.collection(FirebaseConstants.alertThumbsUpCollection);

    return thumbsUpRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.length;
    });
  }
}
