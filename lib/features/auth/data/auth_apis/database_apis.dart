import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/commons/common_imports/apis_commons.dart';
import 'package:opclo/commons/common_providers/global_providers.dart';
import 'package:opclo/core/constants/firebase_constants.dart';
import 'package:opclo/models/favorite_model.dart';
import '../../../../models/user_model.dart';
import '../../../user/location/model/location_detail.dart';

final databaseApisProvider = Provider<DatabaseApis>((ref) {
  final fireStore = ref.watch(firebaseDatabaseProvider);
  return DatabaseApis(firestore: fireStore);
});

abstract class IDatabaseApis {
  // User Functions
  FutureEitherVoid saveUserInfo({required UserModel userModel});

  Future<DocumentSnapshot> getCurrentUserInfo({required String uid});
}

class DatabaseApis extends IDatabaseApis {
  final FirebaseFirestore _firestore;

  DatabaseApis({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  FutureEitherVoid saveUserInfo({required UserModel userModel}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userModel.uid)
          .set(userModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Future<bool> checkUserName({required String userName}) async {
    CollectionReference users =
        _firestore.collection(FirebaseConstants.userCollection);
    QuerySnapshot querySnapshot =
        await users.where('userName', isEqualTo: userName).get();
    return querySnapshot.docs.isEmpty;
  }

  @override
  Future<DocumentSnapshot> getCurrentUserInfo({required String uid}) async {
    final DocumentSnapshot document = await _firestore
        .collection(FirebaseConstants.userCollection)
        .doc(uid)
        .get();
    return document;
  }

  Stream<UserModel?> getUserInfoByUid(String userId) {
    return _firestore
        .collection(FirebaseConstants.userCollection)
        .doc(userId)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(
            event.data() ?? {},
          ),
        );
  }

  // @override
  // Future<DocumentSnapshot> getsStaffInfo() async {
  //   final DocumentSnapshot document = await _firestore
  //       .collection(FirebaseConstants.staffCollection)
  //       .doc(FirebaseConstants.staffDocument)
  //       .get();
  //   return document;
  // }

  // FutureEitherVoid setUserState(
  //     {required bool isOnline, required String uid}) async {
  //   try {
  //     await _firestore
  //         .collection(FirebaseConstants.userCollection)
  //         .doc(uid)
  //         .update({
  //       'isOnline': isOnline,
  //     });
  //     return const Right(null);
  //   } on FirebaseException catch (e, stackTrace) {
  //     return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
  //   } catch (e, stackTrace) {
  //     return Left(Failure(e.toString(), stackTrace));
  //   }
  // }

  FutureEitherVoid setFcmToken(
      {required String fcmToken, required String uid}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(uid)
          .update({
        'notificationToken': fcmToken,
      });
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  // updateAccountType() async {
  //   print('ggggg');
  //   final usersData =
  //       await _firestore.collection(FirebaseConstants.userCollection).get();
  //   final List<UserModel> users =  usersData.docs.map(
  //     (e) => UserModel.fromMap(
  //       e.data(),
  //     ),
  //   ).toList();
  //    for(int i  = 0 ; i< users.length; i++){
  //
  //      print(users[i].uid);
  //      final updatedUser =  users[i].copyWith(accountType: AccountTypeEnum.user);
  //      final result = await updateCurrentUserInfo(
  //         userModel: updatedUser);
  //      print(result);
  //    }
  //
  //   print('end');
  // }

  FutureEitherVoid updateCurrentUserInfo({
    required UserModel userModel,
  }) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userModel.uid)
          .update(userModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid updateUserHomeAddress(
      {required LocationDetails homeAddress, required String userId}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .update({'homeAddress': homeAddress.toMap()});
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid updateUserWorkAddress(
      {required LocationDetails workAddress, required String userId}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .update({'workAddress': workAddress.toMap()});
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  /// quick access methods
  FutureEitherVoid updateQuickAccess(
      {required List<String> quickAccess, required String userId}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.quickAccessCollection)
          .doc(userId)
          .set({'quickAccess': quickAccess});
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<String>> getAllQuickAccess(String userId) {
    try {
      final userRef = _firestore
          .collection(FirebaseConstants.quickAccessCollection)
          .doc(userId);
      return userRef.snapshots().map((snapshot) {
        final data = snapshot.data();
        if (data != null && data.containsKey('quickAccess')) {
          final quickAccess = data['quickAccess'] as List<dynamic>;
          return quickAccess.cast<String>().toList();
        } else {
          return [];
        }
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Future<List<String>> getAllQuickAccessFuture(String userId) async {
    try {
      final userRef = _firestore
          .collection(FirebaseConstants.quickAccessCollection)
          .doc(userId);
      final snapshot = await userRef.get();
      final data = snapshot.data();
      if (data != null && data.containsKey('quickAccess')) {
        final quickAccess = data['quickAccess'] as List<dynamic>;
        return quickAccess.cast<String>().toList();
      } else {
        return [];
      }
    } catch (error) {
      // Handle the error appropriately, perhaps logging it or returning a specific value
      return [];
    }
  }

  /// Favorites access methods
  FutureEitherVoid addToFavourites(
      {required FavoriteModel favourite, required String userId}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(favourite.userId)
          .collection(FirebaseConstants.favouriteCollection)
          .doc(favourite.fsqId)
          .set(favourite.toMap());

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid removeFromFavourites({
    required FavoriteModel favourite,
  }) async {
    try {
      await _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(favourite.userId)
          .collection(FirebaseConstants.favouriteCollection)
          .doc(favourite.fsqId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<Map<String, dynamic>>> getAllFavourites(String userId) {
    try {
      final userRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.favouriteCollection);
      return userRef.snapshots().map((querySnapshot) {
        final List<Map<String, dynamic>> favorites = [];
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          favorites.add(data);
                }
        // print(favorites);
        return favorites;
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<Map<String, dynamic>?> getFavouritesById({
    required String userId,
    required String fsqId,
  }) {
    try {
      final userRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(userId)
          .collection(FirebaseConstants.favouriteCollection).doc(fsqId);
      return userRef.snapshots().map((snapshot) {
        return snapshot.data();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }
  /// ////////////////
  Future<Either<Failure, void>> deleteAccount(
      {String? password, required bool isGoogle, required String uid}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (isGoogle) {
          final providerData = user.providerData.first;

          if (AppleAuthProvider().providerId == providerData.providerId) {
            await user.reauthenticateWithProvider(AppleAuthProvider());
          } else if (GoogleAuthProvider().providerId ==
              providerData.providerId) {
            await user.reauthenticateWithProvider(GoogleAuthProvider());
          }
        } else {
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password!,
          );
          await user.reauthenticateWithCredential(credential);
        }

        /// delete user
        await _firestore
            .collection(FirebaseConstants.userCollection)
            .doc(uid)
            .delete();

        /// delete user reminders
        await deleteDocsByUserId(
            collectionName: FirebaseConstants.reminderCollection,
            uid: user.uid);

        /// delete user notes
        await deleteDocsByUserId(
            collectionName: FirebaseConstants.noteCollection, uid: user.uid);

        /// delete user favourite
        await deleteDocsByUserId(
            collectionName: FirebaseConstants.favouriteCollection,
            uid: user.uid);

        /// delete user alerts
        await deleteDocsByUserId(
            collectionName: FirebaseConstants.alertCollection, uid: user.uid);
        await user.delete();
        return Right(null);
      } else {
        return Left(Failure('No user signed in.', StackTrace.current));
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Future<void> deleteDocsByUserId({
    required String collectionName,
    required String uid,
  }) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);
      QuerySnapshot querySnapshot =
          await collection.where('userId', isEqualTo: uid).get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
      }
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }

  FutureEitherVoid updateEmailAddress({required String newEmail, required String pass}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser!;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email!,
              password: pass)
          .then((userCredential) async {
       await userCredential.user?.updateEmail(newEmail);
      });
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }


  Stream<String> getEmailForFeedbackStream() {
    return _firestore
        .collection(FirebaseConstants.emailCollection)
        .doc('email')
        .snapshots()
        .map((documentSnapshot) {
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return documentSnapshot.data()!['email'] as String;
      }
      return '';
    });
  }
  Future<String> getEmailForFeedback() async {
    final documentSnapshot = await _firestore
        .collection(FirebaseConstants.emailCollection)
        .doc('email')
        .get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      return documentSnapshot.data()!['email'] as String;
    }
    return '';
  }
}
