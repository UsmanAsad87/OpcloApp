import 'package:opclo/features/user/restaurant/api/place_subscription_api.dart';
import 'package:opclo/firebase_messaging/firebase_messaging_class.dart';
import 'package:opclo/models/place_subscription_model.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';

final placeSubControllerProvider =
    StateNotifierProvider<PlaceSubscriptionController, bool>((ref) {
  return PlaceSubscriptionController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(placeSubDatabaseApiProvider),
  );
});

final alertSubUserIdProvider = FutureProvider.family((ref, String placeId) {
  final databaseProvider = ref.watch(placeSubControllerProvider.notifier);
  return databaseProvider.getAlertSubUserIds(placeId: placeId);
});

final checkUserExistsInPlaceSubscriptionProvider =
    FutureProvider.family((ref, String placeId) {
  final databaseProvider = ref.watch(placeSubControllerProvider.notifier);
  return databaseProvider.checkUserExistsInPlaceSubscription(placeId: placeId);
});

class PlaceSubscriptionController extends StateNotifier<bool> {
  final PlaceSubscriptionDatabaseApi _databaseApis;
  final AuthApis _authApis;

  PlaceSubscriptionController({
    required PlaceSubscriptionDatabaseApi databaseApis,
    required AuthApis authApis,
  })  : _databaseApis = databaseApis,
        _authApis = authApis,
        super(false);

  // Stream<List<String>> getWalletCoupons({required String placeId}) {
  //   try {
  //     Stream<List<String>> userIds = _databaseApis.getUserIdsInPlaceSub(placeId: placeId);
  //     return userIds;
  //   } catch (error) {
  //     return const Stream.empty();
  //     // Handle the error as needed
  //   }
  // }

  Future<List<String>> getAlertSubUserIds({required String placeId}) async {
    try {
      List<String> userIds =
          await _databaseApis.getUserIdsInPlaceSub(placeId: placeId).first;
      return userIds;
    } catch (error) {
      return [];
    }
  }

  Future<List<String>> fetchFcmTokensForUserIds(
      {required List<String> userIds}) async {
    try {
      List<String> fcmToken =
          await _databaseApis.fetchFcmTokensForUserIds(userIds);
      return fcmToken;
    } catch (error) {
      return [];
    }
  }

  Future<void> addUserIdInPlaceSub({
    // required BuildContext context,
    required String placeId,
    // required String userId
  }) async {
    List<String> userIds = await _databaseApis
        .getUserIdsInPlaceSub(
          placeId: placeId,
        )
        .first;
    final result;
    final userId = _authApis.getCurrUser()!.uid;
    final exist = userIds.contains(userId);
    if (exist) {
      userIds.remove(userId);
      MessagingFirebase().unSubscribeFrom(topicName: placeId);
      result = await _databaseApis.removeUserIdInPlaceSub(
          subModel:
              PlaceSubscriptionModel(userId: userId, date: DateTime.now()),
          placeId: placeId);
    } else {
      userIds.add(userId);
      MessagingFirebase().subscribeTo(topicName: placeId);
      result = await _databaseApis.addUserIdInPlaceSub(
          subModel: PlaceSubscriptionModel(userId: userId, date: DateTime.now()), placeId: placeId);
    }
    result.fold((l) {
      state = false;
      // showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showToast(
          msg: exist ? 'Successfully unsubscribed' : 'Successfully subscribed');
      // showSnackBar(context, 'added successfully');
      // Navigator.of(context).pop();
    });
    // }
  }

  Future<void> updateUserIdInPlaceSub({
    required String placeId,
    required DateTime date,
  }) async {
    state = true;
    // List<String> userIds = await _databaseApis
    //     .getUserIdsInPlaceSub(
    //       placeId: placeId,
    //     )
    //     .first;
    final result;
    final userId = _authApis.getCurrUser()!.uid;
    result = await _databaseApis.updateUserIdInPlaceSub(
        subModel:
        PlaceSubscriptionModel(userId: userId, date: date),
        placeId: placeId);
    result.fold((l) {
      state = false;
      // showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showToast(
          msg: 'Mute Successfully');
      // showSnackBar(context, 'added successfully');
      // Navigator.of(context).pop();
    });
    // }
  }

  Future<bool> checkUserExistsInPlaceSubscription(
      {required String placeId}) async {
    final userId = _authApis.getCurrUser()?.uid;
    if (userId == null) {
      return false;
    }
    return _databaseApis.checkUserExistsInPlaceSubscription(
        currentUserId: userId, placeId: placeId);
  }
}
