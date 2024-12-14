import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_providers/global_providers.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/favorite_model.dart';
import '../../../../models/like_group_model.dart';

final likeGroupDatabaseApiProvider = Provider<LikeGroupDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return LikeGroupDatabaseApi(firebase: firebase, auth: FirebaseAuth.instance);
});

class LikeGroupDatabaseApi {
  final FirebaseFirestore _firestore;
  final FirebaseAuth auth;

  LikeGroupDatabaseApi(
      {required FirebaseFirestore firebase, required this.auth})
      : _firestore = firebase;

  FutureEitherVoid addLikeGroup(
      {required LikeGroupModel likeModel, required String userId}) async {
    try {
      CollectionReference couponRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.likeGroupCollection);
      await couponRef.doc(likeModel.id).set(likeModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid updateLikeGroupName(
      {required String groupName,
      required String groupId,
      required String userId}) async {
    try {
      CollectionReference likeGroupRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.likeGroupCollection);
      await likeGroupRef.doc(groupId).update({'groupName': groupName});
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid updateOrderIndex({
        required List<LikeGroupModel> groups,
        required String userId}) async {
    try {
      CollectionReference likeGroupRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.likeGroupCollection);
      final batch = FirebaseFirestore.instance.batch();
      for (var i = 0; i < groups.length; i++) {
        final item = groups[i];
        final docRef = likeGroupRef.doc(item.id);
        batch.update(docRef, {'orderIndex': i});
      }
      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<LikeGroupModel>> getAllLikeGroups({required String userId}) {
    try {
      CollectionReference couponRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.likeGroupCollection);
      return couponRef.orderBy('orderIndex').snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return LikeGroupModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  FutureEitherVoid deleteLikeGroup(
      {required String groupId, required String userId}) async {
    try {
      final  likeGroup = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.likeGroupCollection).doc(groupId);
      await likeGroup.delete();
      ///
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.favouriteCollection)
          .where('groupId', isEqualTo: groupId)
          .get();
      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid removeGroupFromFavourites({
    required String userId,
    required String groupId,
  }) async {
    try {
      // Get all documents where the groupId matches
      final querySnapshot = await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.favouriteCollection)
          .where('groupId', isEqualTo: groupId)
          .get();
      print(querySnapshot.docs.map((d) => print(d.id)));
      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }
}
