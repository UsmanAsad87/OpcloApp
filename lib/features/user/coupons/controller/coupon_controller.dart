import 'package:image_picker/image_picker.dart';
import 'package:opclo/commons/common_functions/upload_image_to_firebase.dart';
import 'package:opclo/core/constants/firebase_constants.dart';
import 'package:opclo/features/user/coupons/api/coupon_api.dart';
import 'package:opclo/firebase_analytics/firebase_analytics.dart';
import 'package:opclo/models/coupon_model.dart';
import 'package:opclo/models/redemption_coupon_model/remdeption_coupon_model.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../models/wallet_coupon_model/wallet_coupon_model.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';

final couponControllerProvider =
    StateNotifierProvider<CouponsController, bool>((ref) {
  return CouponsController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(couponDatabaseApiProvider),
  );
});

final getAllCouponsProvider = StreamProvider((
  ref,
) {
  final couponCtr = ref.watch(couponControllerProvider.notifier);
  return couponCtr.getAllCoupons();
});

final getWalletCouponsProvider = StreamProvider((
  ref,
) {
  final couponCtr = ref.watch(couponControllerProvider.notifier);
  return couponCtr.getWalletCoupons();
});

final isCouponExistProvider = StreamProvider.family((
  ref, String couponId
) {
  final couponCtr = ref.watch(couponControllerProvider.notifier);
  return couponCtr.couponExistInWallet(couponId: couponId);
});

final getCouponByIdProvider = StreamProvider.family((ref, String couponId) {
  final couponCtr = ref.watch(couponControllerProvider.notifier);
  return couponCtr.getCouponById(couponId: couponId);
});

final getCategoryCouponsProvider =
    StreamProvider.family((ref, String category) {
  final couponCtr = ref.watch(couponControllerProvider.notifier);
  return couponCtr.getCategoryCoupons(category);
});

class CouponsController extends StateNotifier<bool> {
  final AlertDatabaseApi _databaseApis;
  final AuthApis _authApis;

  CouponsController({
    required AlertDatabaseApi databaseApis,
    required AuthApis authApis,
  })  : _databaseApis = databaseApis,
        _authApis = authApis,
        super(false);

  Future<void> addCoupon({
    required BuildContext context,
    required CouponModel couponModel,
  }) async {
    state = true;
    final logoPath = await uploadXImage(
      XFile(couponModel.logo),
      storageFolderName: FirebaseConstants.couponStorage,
    );
    final updatedCoupon = couponModel.copyWith(logo: logoPath);
    final result = await _databaseApis.addCoupon(couponModel: updatedCoupon);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Coupon added successfully');
      Navigator.of(context).pop();
    });
  }

  Stream<List<CouponModel>> getAllCoupons() {
    try {
      Stream<List<CouponModel>> coupons = _databaseApis.getAllCoupons();
      return coupons;
    } catch (error) {
      return const Stream.empty();
      // Handle the error as needed
    }
  }

  Stream<List<CouponModel>> getWalletCoupons() {
    try {
      Stream<List<CouponModel>> coupons =
          _databaseApis.getWalletCoupons();
      return coupons;
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<bool> couponExistInWallet({required String couponId}) {
    try {
      return _databaseApis.couponExistInWallet(couponId: couponId);
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<List<CouponModel>> getCategoryCoupons(String category) {
    try {
      Stream<List<CouponModel>> coupons =
          _databaseApis.getCategoryCoupons(category);
      return coupons;
    } catch (error) {
      return const Stream.empty();
      // Handle the error as needed
    }
  }

  Future<void> updateFavorites({
    required BuildContext context,
    required WidgetRef ref,
    required CouponModel couponModel,
    required bool isLike,
  }) async {
    state = true;
    final userId = _authApis.getCurrentUserId();
    List<String>? dislikes;
    List<String>? likes;
    if (isLike) {
      bool isLikeExist = couponModel.likes?.contains(userId) ?? false;
      if (isLikeExist) {
        couponModel.likes?.remove(userId);
        likes = couponModel.likes;
      } else {
        couponModel.likes?.add(userId!);
        likes = couponModel.likes;
        bool isExist = couponModel.dislikes?.contains(userId) ?? false;
        if (isExist) {
          couponModel.dislikes?.remove(userId);
          dislikes = couponModel.dislikes;
        }
      }
    } else {
      bool isDislikeExist = couponModel.dislikes?.contains(userId) ?? false;
      if (isDislikeExist) {
        couponModel.dislikes?.remove(userId);
        dislikes = couponModel.dislikes;
      } else {
        couponModel.dislikes?.add(userId!);
        dislikes = couponModel.dislikes;
        bool isExist = couponModel.likes?.contains(userId) ?? false;
        if (isExist) {
          couponModel.likes?.remove(userId);
          likes = couponModel.likes;
        }
      }
    }
    final result1 = await _databaseApis.updateLikesOrDislikes(
      couponId: couponModel.id,
      likes: likes,
      dislikes: dislikes,
    );
    result1.fold((l) {
      state = false;
      print(l.message);
      showSnackBar(context, l.message);
    }, (r) {
      state = false;
      showToast(
        msg: isLike ? 'Liked Successfully' : 'DisLiked Successfully',
      );
    });
  }

  Future<void> addCouponToWallet({
    required BuildContext context,
    required WalletCouponModel walletCoupon,
    required CouponModel couponModel,
  }) async {
    final result =
        await _databaseApis.addCouponToWallet(walletCoupon: walletCoupon);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      RedemptionCouponModel redemptionModel = RedemptionCouponModel(
          id: Uuid().v4(),
          userId: _authApis.getCurrUser()?.uid ?? '',
          couponId: walletCoupon.couponId,
          date: walletCoupon.date);
      _databaseApis.addRedemptionCoupon(redemptionModel: redemptionModel);
      showSnackBar(context, 'Coupon Added successfully');
      AnalyticsHelper.logCouponRedeemed(couponModel: couponModel);
    });
  }

  Future<void> deleteCouponFromWallet({
    required BuildContext context,
    required String couponId,
  }) async {
    final result = await _databaseApis.deleteCouponFromWallet(
        couponId: couponId);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Coupon Removed successfully');
      //Navigator.of(context).pop();
    });
  }

  // Future<void> deleteCouponFromWallet({
  //   required String couponId,
  // }) async {
  //   List<String> couponsIds = await _databaseApis.getWalletCoupons().first;
  //   couponsIds.remove(couponId);
  //   final result = await _databaseApis.addCouponToWallet(couponIds: couponsIds);
  //   result.fold((l) {
  //     state = false;
  //     showToast(msg: l.message);
  //   }, (r) async {
  //     state = false;
  //     showToast(msg: 'deleted successfully');
  //   });
  // }

  Stream<CouponModel?> getCouponById({required String couponId}) {
    try {
      Stream<CouponModel?> coupons =
      _databaseApis.getCouponById(couponId: couponId);
      return coupons;
    } catch (error) {
      return const Stream.empty();
    }
  }
}
