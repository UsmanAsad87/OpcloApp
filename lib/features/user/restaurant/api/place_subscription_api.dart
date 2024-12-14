import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_providers/global_providers.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/place_subscription_model.dart';

final placeSubDatabaseApiProvider =
    Provider<PlaceSubscriptionDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return PlaceSubscriptionDatabaseApi(
    firebase: firebase,
  );
});

class PlaceSubscriptionDatabaseApi {
  final FirebaseFirestore _firestore;

  PlaceSubscriptionDatabaseApi({
    required FirebaseFirestore firebase,
  }) : _firestore = firebase;

  // FutureEitherVoid addUserIdInPlaceSub({
  //   required String placeId,
  //   required List<String> userIds,
  // }) async {
  //   try {
  //     CollectionReference placeSubRef =
  //         _firestore.collection(FirebaseConstants.placeSubCollection);
  //     await placeSubRef.doc(placeId).set({'userIds': userIds});
  //     return const Right(null);
  //   } on FirebaseException catch (e, stackTrace) {
  //     return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
  //   } catch (e, stackTrace) {
  //     return Left(Failure(e.toString(), stackTrace));
  //   }
  // }

  FutureEitherVoid addUserIdInPlaceSub({
    required String placeId,
    required PlaceSubscriptionModel subModel,
  }) async {
    try {
      CollectionReference placeSubRef =
          _firestore.collection(FirebaseConstants.placeSubCollection);
      await placeSubRef
          .doc(placeId)
          .collection('userIds')
          .doc(subModel.userId)
          .set(subModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid removeUserIdInPlaceSub({
    required String placeId,
    required PlaceSubscriptionModel subModel,
  }) async {
    try {
      CollectionReference placeSubRef =
      _firestore.collection(FirebaseConstants.placeSubCollection);
      await placeSubRef
          .doc(placeId)
          .collection('userIds')
          .doc(subModel.userId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid updateUserIdInPlaceSub({
    required String placeId,
    required PlaceSubscriptionModel subModel,
  }) async {
    try {
      CollectionReference placeSubRef =
          _firestore.collection(FirebaseConstants.placeSubCollection);
      await placeSubRef
          .doc(placeId)
          .collection('userIds')
          .doc(subModel.userId)
          .update(subModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<String>> getUserIdsInPlaceSub({required String placeId}) {
    try {
      final placeSubRef = _firestore
          .collection(FirebaseConstants.placeSubCollection)
          .doc(placeId)
          .collection('userIds');
      return placeSubRef
          .where('date', isLessThan: DateTime.now().toIso8601String())
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.docs.isNotEmpty) {
          final List<String> userIds = [];
          for (final docSnapshot in docSnapshot.docs) {
            final data = docSnapshot.data();
            final placeSubModel = PlaceSubscriptionModel.fromMap(data);
            userIds.add(placeSubModel.userId);
          }
          return userIds;
          // final data = docSnapshot.data() as Map<String, dynamic>;
          // final List<String> userIds = List<String>.from(data['userIds'] ?? []);
          // return userIds;
        } else {
          return [];
        }
      });
    } catch (error) {
      return Stream.empty();
    }
  }

  // Stream<List<String>> getUserIdsInPlaceSub({required String placeId}) {
  //   try {
  //     final placeSubRef = _firestore
  //         .collection(FirebaseConstants.placeSubCollection)
  //         .doc(placeId);
  //
  //     return placeSubRef.snapshots().map((docSnapshot) {
  //       if (docSnapshot.exists) {
  //         // Extract the list of coupon IDs from the document data
  //         final data = docSnapshot.data() as Map<String, dynamic>;
  //         final List<String> userIds = List<String>.from(data['userIds'] ?? []);
  //         return userIds;
  //       } else {
  //         return [];
  //       }
  //     });
  //   } catch (error) {
  //     return Stream.empty();
  //   }
  // }

  Future<List<String>> fetchFcmTokensForUserIds(List<String> userIds) async {
    List<String> fcmTokens = [];
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection(FirebaseConstants.userCollection);

    for (String userId in userIds) {
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
      if (userDoc.exists) {
        String? fcmToken = userDoc['notificationToken'];
        if (fcmToken != null) {
          fcmTokens.add(fcmToken);
        }
      }
    }
    return fcmTokens;
  }

  Future<bool> checkUserExistsInPlaceSubscription(
      {required String placeId, required String currentUserId}) async {
    try {
      final placeSubRef = _firestore
          .collection(FirebaseConstants.placeSubCollection)
          .doc(placeId)
          .collection('userIds');
      final docSnapshot =
          await placeSubRef.where('userId', isEqualTo: currentUserId).get();
      if (docSnapshot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

// Future<bool> checkUserExistsInPlaceSubscription(
//     {required String placeId, required String currentUserId}) async {
//   try {
//     // Reference to the Firestore collection 'placeSubscription'
//     CollectionReference placeSubscriptionCollection = FirebaseFirestore
//         .instance
//         .collection(FirebaseConstants.placeSubCollection);
//     DocumentSnapshot userDoc =
//         await placeSubscriptionCollection.doc(placeId).get();
//     final data = userDoc;
//     final List<String> userIds = List<String>.from(data['userIds'] ?? []);
//     return userIds.contains(currentUserId);
//   } catch (e) {
//     return false;
//   }
// }
}
