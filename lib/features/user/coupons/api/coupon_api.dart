import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/commons/common_enum/coupons_category_enum/coupon_category.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_providers/global_providers.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/coupon_model.dart';
import '../../../../models/redemption_coupon_model/remdeption_coupon_model.dart';
import '../../../../models/wallet_coupon_model/wallet_coupon_model.dart';

final couponDatabaseApiProvider = Provider<AlertDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return AlertDatabaseApi(firebase: firebase, auth: FirebaseAuth.instance);
});

class AlertDatabaseApi {
  final FirebaseFirestore _firestore;
  final FirebaseAuth auth;

  AlertDatabaseApi({required FirebaseFirestore firebase, required this.auth})
      : _firestore = firebase;

  FutureEitherVoid addCoupon({required CouponModel couponModel}) async {
    try {
      CollectionReference couponRef =
      _firestore.collection(FirebaseConstants.newCouponCollection
        // FirebaseConstants.couponCollection
      );
      await couponRef.doc(couponModel.id).set(couponModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<CouponModel>> getAllCoupons() {
    try {
      final String currentDateIso = DateTime.now().toIso8601String();
      CollectionReference couponRef =
      _firestore.collection(FirebaseConstants.newCouponCollection);
      return couponRef
          .where('expiryDate', isGreaterThanOrEqualTo: currentDateIso)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return CouponModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<List<CouponModel>> getCategoryCoupons(String category) {
    try {
      final String currentDateIso = DateTime.now().toIso8601String();
      final couponRef = _firestore
          .collection(FirebaseConstants.newCouponCollection)
          .where('couponCategory', isEqualTo: category)
          .where('expiryDate', isGreaterThanOrEqualTo: currentDateIso);
      return couponRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return CouponModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  FutureEitherVoid updateLikesOrDislikes({required String couponId,
    List<String>? likes,
    List<String>? dislikes}) async {
    try {
      final ref = _firestore
          .collection(FirebaseConstants.newCouponCollection
        // FirebaseConstants.couponCollection)
      )
          .doc(couponId);
      if (dislikes != null) {
        await ref.update({'dislikes': dislikes});
      }
      if (likes != null) {
        await ref.update({'likes': likes});
      }
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid addCouponToWallet(
      {required WalletCouponModel walletCoupon}) async {
    try {
      CollectionReference walletRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(auth.currentUser!.uid)
          .collection(FirebaseConstants.walletCouponsCollection);
      await walletRef
          .doc(walletCoupon.id)
          .set(walletCoupon.copyWith(userId: auth.currentUser!.uid).toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid addRedemptionCoupon(
      {required RedemptionCouponModel redemptionModel}) async {
    try {
      CollectionReference redemptionRef =
      _firestore.collection(FirebaseConstants.redemptionCollection);
      await redemptionRef.doc(redemptionModel.id).set(redemptionModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid deleteCouponFromWallet(
      {required String couponId}) async {
    try {
      final walletRef = _firestore
          .collection(FirebaseConstants.userCollection)
          .doc(auth.currentUser!.uid)
          .collection(FirebaseConstants.walletCouponsCollection)
          .where('couponId', isEqualTo: couponId);

      final walletSnapshot = await walletRef.get();

      if (walletSnapshot.docs.isNotEmpty) {
        await walletSnapshot.docs.first.reference.delete();
      }
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<CouponModel>> getWalletCoupons() {
    final userRef = _firestore
        .collection(FirebaseConstants.userCollection)
        .doc(auth.currentUser!.uid);
    final couponRef =
    userRef.collection(FirebaseConstants.walletCouponsCollection);

    return couponRef.snapshots().asyncMap((docSnapshot) async {
      List<CouponModel> coupons = [];

      final user = await userRef.get();
      for (var doc in docSnapshot.docs) {
        final couponDoc = await _firestore
            .collection(FirebaseConstants.newCouponCollection)
            .doc(doc.data()['couponId'])
            .get();
        if (couponDoc.exists &&
            DateTime.parse(couponDoc.data()?['expiryDate']).isAfter(
                DateTime.now())) {
          if ((couponDoc.data()?['isPremium'] ?? false)) {
            if ((user.data()?['subscriptionIsValid'] ?? false)) {
              coupons.add(CouponModel.fromMap(couponDoc.data()!));
            }
          } else {
            coupons.add(CouponModel.fromMap(couponDoc.data()!));
          }
        }
      }
      return coupons;
    });
  }

  Stream<bool> couponExistInWallet({required String couponId}) {
    final userRef = _firestore
        .collection(FirebaseConstants.userCollection)
        .doc(auth.currentUser!.uid);
    final couponRef =
    userRef.collection(FirebaseConstants.walletCouponsCollection).where('couponId', isEqualTo: couponId);
    return couponRef.snapshots().map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Stream<CouponModel?> getCouponById({required String couponId}) {
    try {
      final couponRef = _firestore
          .collection(FirebaseConstants.newCouponCollection)
          .doc(couponId);
      return couponRef.snapshots().map((docSnapshot) {
        final data = docSnapshot.data();
        if (data != null) {
          return CouponModel.fromMap(data);
        } else {
          return null;
        }
      });
    } catch (error) {
      return Stream.empty();
    }
  }
}
