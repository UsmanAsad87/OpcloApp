import 'dart:math';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opclo/commons/common_enum/account_type/account_type.dart';
import 'package:opclo/core/constants/subcription_constants.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/main_menu/controller/main_menu_controller.dart';

import '../../../commons/common_enum/signup_type/signup_type.dart';
import '../../../commons/common_functions/upload_image_to_firebase.dart';
import '../../../commons/common_imports/apis_commons.dart';
import '../../../commons/common_imports/common_libs.dart';
import '../../../commons/common_widgets/show_toast.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../firebase_analytics/firebase_analytics.dart';
import '../../../firebase_messaging/firebase_messaging_class.dart';
import '../../../models/favorite_model.dart';
import '../../../models/user_model.dart';
import '../../../routes/route_manager.dart';
import '../../user/location/model/location_detail.dart';
import '../data/auth_apis/auth_apis.dart';
import '../data/auth_apis/database_apis.dart';

//
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(databaseApisProvider),
  );
});

final userStateStreamProvider = StreamProvider((ref) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.getSigninStatusOfUser();
});

final userInfoByIdStreamProvider = StreamProvider.family((ref, String userId) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.getUserInfoByUid(userId);
});

final currentUserAuthProvider = FutureProvider((ref) {
  final authCtr = ref.watch(authControllerProvider.notifier);
  return authCtr.currentUser();
});

final currentUserModelData = FutureProvider((ref) {
  final authCtr = ref.watch(authControllerProvider.notifier);
  return authCtr.getCurrentUserInfo();
});

final getFavouriteByFsq = StreamProvider.family((ref, String fsq) {
  final favouriteCtr = ref.watch(authControllerProvider.notifier);
  return favouriteCtr.getFavoriteById(fsqId: fsq);
});

/// quick access

final quickAccessStreamProvider =
    StreamProvider.family((ref, BuildContext context) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.getAllQuickAccess(context);
});

final quickAccessFutureStreamProvider =
    FutureProvider.family((ref, BuildContext context) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.getAllQuickAccessFuture(context);
});

/// Favorites

final favoritesStreamProvider = StreamProvider.autoDispose((
  ref,
) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.getAllFavourites();
});

class AuthController extends StateNotifier<bool> {
  final AuthApis _authApis;
  final DatabaseApis _databaseApis;

  AuthController(
      {required AuthApis authApis, required DatabaseApis databaseApis})
      : _authApis = authApis,
        _databaseApis = databaseApis,
        super(false);

  Future<User?> currentUser() async {
    return _authApis.getCurrentUser();
  }

  Future<void> registerWithEmailAndPassword({
    required String name,
    required String uname,
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = true;
    final result = await _authApis.registerWithEmailPassword(
        email: email, password: password);

    result.fold((l) {
      state = false;
      print('error" ${l.message}');
      showSnackBar(context, l.message);
      showToast(msg: l.message);
    }, (r) async {
      UserModel userModel = UserModel(
        uid: r.uid,
        name: name,
        email: email,
        profileImage: '',
        createdAt: DateTime.now(),
        userName: uname,
        notificationToken: await MessagingFirebase().getFcmToken(),
        // homeAddress: '',
        // workAddress: '',
        signupTypeEnum: SignupTypeEnum.email,
        subscriptionId: SubscriptionConstants.opcloFree,
        subscriptionAdded: DateTime.now(),
        subscriptionApproved: false,
        subscriptionIsValid: false,
        subscriptionName: SubscriptionConstants.opcloFreeName,
        subscriptionExpire: DateTime.now().add(const Duration(days: 30)),
        accountType: AccountTypeEnum.user,
      );

      final result2 = await _databaseApis.saveUserInfo(userModel: userModel);
      // await _databaseApis.getCurrentUserInfo(uid: r.uid);
      result2.fold((l) {
        state = false;
        showToast(msg: l.message);
      }, (r) async {
        state = false;
        setUserFcmToken();
        AnalyticsHelper.logUserSignup(user: userModel);
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.homeAndWorkScreen, (route) => false);

        // Navigator.pushNamedAndRemoveUntil(
        //     context, AppRoutes.mainMenuScreen, (route) => false);
        // ref.read(mainMenuProvider).setIndex(0);
        // Navigator.pushNamed(context, AppRoutes.staffPortalHomeScreen);
        showToast(msg: 'Account Created Successfully!');
      });
    });
  }

  //google sign in
  Future<void> signInWithGoogle(
      {required BuildContext context, required WidgetRef ref}) async {
    try {
      state = true;

      final GoogleSignInAccount? googleUser =
          Theme.of(context).platform == TargetPlatform.iOS
              ? await GoogleSignIn(
                  clientId:
                      "1096174460927-ohheg08msvcqev4juoeo21fpcjg8bv79.apps.googleusercontent.com",
                  scopes: ['email', 'profile'],
                  hostedDomain: "",
                ).signIn()
              : await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // if (!isValidEmailFormat(googleUser!.email)) {
      //   showToast(msg: "Email format didn't match", long: true);
      //   state = false;
      //   return;
      // }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          final name = userCredential.additionalUserInfo!.profile!['name'];
          String userName = generateUserName(name);
          bool isUnique = await checkUserNameUniqueness(userName);
          while (!isUnique) {
            userName = generateUserName(name);
            isUnique = await checkUserNameUniqueness(userName);
          }
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.additionalUserInfo!.profile!['name'],
            email: userCredential.additionalUserInfo!.profile!['email'],
            profileImage:
                userCredential.additionalUserInfo!.profile!['picture'],
            createdAt: DateTime.now(),
            userName: userName,
            notificationToken: await MessagingFirebase().getFcmToken(),
            // homeAddress: '',
            // workAddress: '',
            signupTypeEnum: SignupTypeEnum.google,
            subscriptionId: SubscriptionConstants.opcloFree,
            subscriptionAdded: DateTime.now(),
            subscriptionApproved: false,
            subscriptionIsValid: false,
            subscriptionName: SubscriptionConstants.opcloFreeName,
            subscriptionExpire: DateTime.now().add(const Duration(days: 30)),
            accountType: AccountTypeEnum.user,
          );

          final result2 =
              await _databaseApis.saveUserInfo(userModel: userModel);
          result2.fold((l) {
            state = false;
            debugPrintStack(stackTrace: l.stackTrace);
            debugPrint(l.message);
            showToast(msg: l.message);
          }, (r) async {
            state = false;
            setUserFcmToken();
            AnalyticsHelper.logUserSignup(user: userModel);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.homeAndWorkScreen, (route) => false);
          });
        } else {
          // setUserState(true);
          state = false;
          setUserFcmToken();
          // Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.mainMenuScreen, (route) => false);
          ref.read(mainMenuProvider).setIndex(0);
          return;
        }
      }
      state = false;
    } on FirebaseAuthException catch (e, st) {
      debugPrintStack(stackTrace: st);
      debugPrint(e.toString());
      state = false;
      if (e.toString() == 'Null check operator used on a null value') {
        return;
      }
      showSnackBar(context, e.message!);
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      debugPrint(e.toString());
      state = false;
      if (e.toString() == 'Null check operator used on a null value') {
        return;
      }
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInWithApple({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = true;
    final credential = await _authApis.signInWithAppleNewMethod();
    credential.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message.toString());
      state = false;
      if (l.message.toString() == 'Null check operator used on a null value') {
        return;
      }
    }, (userCredential) async {
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? true) {
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? "user@apple.com",
            profileImage: '',
            createdAt: DateTime.now(),
            userName: userCredential.user!.displayName != null
                ? userCredential.user!.displayName! + "423"
                : 'user782',
            notificationToken: await MessagingFirebase().getFcmToken(),
            signupTypeEnum: SignupTypeEnum.apple,
            subscriptionId: SubscriptionConstants.opcloFree,
            subscriptionAdded: DateTime.now(),
            subscriptionApproved: false,
            subscriptionIsValid: false,
            subscriptionName: SubscriptionConstants.opcloFreeName,
            subscriptionExpire: DateTime.now().add(const Duration(days: 30)),
            accountType: AccountTypeEnum.user,
          );
          final result2 =
              await _databaseApis.saveUserInfo(userModel: userModel);
          result2.fold((l) {
            state = false;
            debugPrintStack(stackTrace: l.stackTrace);
            debugPrint(l.message);
            showToast(msg: l.message);
          }, (r) async {
            state = false;
            setUserFcmToken();
            AnalyticsHelper.logUserSignup(user: userModel);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.homeAndWorkScreen, (route) => false);
          });
          state = false;
        } else {
          state = false;
          setUserFcmToken();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.mainMenuScreen, (route) => false);
          ref.read(mainMenuProvider).setIndex(0);
          return;
        }
      }
      state = false;
    });
  }

  /// Generate Random User Name
  String generateUserName(String name) {
    String userName = name.toLowerCase().replaceAll(' ', '');
    int randomSuffix = Random().nextInt(9000) + 1000;
    userName += randomSuffix.toString();
    return userName;
  }

  Future<bool> checkUserNameUniqueness(String userName) async {
    return await _databaseApis.checkUserName(userName: userName);
  }

  // Login Staff
  Future<void> signInWithUsernameAndPassword(
      {required String email,
      required String password,
      required BuildContext context,
      required WidgetRef ref}) async {
    state = true;
    final result = await _authApis.signInStaffWithUsernameAndPass(
        email: email, password: password);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
      showToast(msg: l.message);
    }, (r) async {
      // final userId = await _authApis.getCurrentUser();
      // userId!.uid;
      setUserFcmToken();
      // setUserState(true);
      state = false;
      ref.read(mainMenuProvider).setIndex(0);
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.mainMenuScreen, (route) => false);
    });
  }

  Future<UserModel?> getCurrentUserInfo() async {
    final userId = await _authApis.getCurrentUser();
    if (userId == null) {
      return null;
    }
    final result = await _databaseApis.getCurrentUserInfo(uid: userId.uid);
    UserModel userModel =
        UserModel.fromMap(result.data() as Map<String, dynamic>);
    return userModel;
  }

  Future<UserModel> getUserInfoByUidFuture(String uid) async {
    final result = await _databaseApis.getCurrentUserInfo(uid: uid);
    UserModel userModel =
        UserModel.fromMap(result.data() as Map<String, dynamic>);
    return userModel;
  }

  Stream<UserModel?> getUserInfoByUid(String userId) {
    return _databaseApis.getUserInfoByUid(userId);
  }

  // LogOut User
  Future<void> logout({
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authApis.logout();
    state = false;
    result.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, AppRoutes.mainMenuScreen, (route) => false);
    });
  }

  // void setUserState(bool isOnline) async {
  //   final userId = await _authApis.getCurrentUser();
  //   await _databaseApis.setUserState(isOnline: isOnline, uid: userId!.uid);
  // }

  void setUserFcmToken() async {
    try{
      final fcmToken = await MessagingFirebase().getFcmToken();
      final userId = await _authApis.getCurrentUser();
      await _databaseApis.setFcmToken(fcmToken: fcmToken, uid: userId!.uid);
    }catch(e){
      print("Exception in SetFCM: "+e.toString());
    }
  }

  Future<void> fcmTokenUpload({required UserModel userModel}) async {
    try{
      MessagingFirebase messagingFirebase = MessagingFirebase();
      String token = await messagingFirebase.getFcmToken();
      if (userModel.notificationToken == token || token.isEmpty) {
        return; // if will return if device token and token on firebase are same
      }
      final result =
      await _databaseApis.setFcmToken(fcmToken: token, uid: userModel.uid);
      result.fold((l) {
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message.toString());
      }, (r) async {
        debugPrint("Fcm Updated");
      });
    }catch(e){
      print("Exception in SetFCM: "+e.toString());
    }
  }

  // getSigninStatusOfUser
  Stream<User?> getSigninStatusOfUser() {
    return _authApis.getSigninStatusOfUser();
  }

  Future<bool> getSignMethodGoogle() async {
    final userId = await _authApis.getCurrentUser();
    UserInfo userInfo = userId!.providerData[0];
    if (userInfo.providerId == 'google.com') {
      return true;
    }
    return false;
  }

  // Update User Information
  Future<void> updateCurrentUserInfo(
      {required BuildContext context,
      required UserModel userModel,
      required WidgetRef ref,
      required String oldUserName,
      String? imagePath}) async {
    state = true;
    if (oldUserName != userModel.userName) {
      bool isUnique =
          await _databaseApis.checkUserName(userName: userModel.userName);
      if (isUnique) {
      } else {
        state = false;
        showSnackBar(context, 'UserName already exist');
        return;
      }
    }
    UserModel updateUserModel;
    String? image = imagePath != null
        ? await uploadXImage(XFile(imagePath),
            storageFolderName: FirebaseConstants.userAuthStorage)
        : userModel.profileImage;
    updateUserModel = userModel.copyWith(profileImage: image);
    final result2 =
        await _databaseApis.updateCurrentUserInfo(userModel: updateUserModel);
    result2.fold((l) {
      state = false;
      showSnackBar(context, l.message);
      debugPrintStack(stackTrace: l.stackTrace);
    }, (r) {
      state = false;
      ref.read(authNotifierCtr).setUserModelData(updateUserModel);
      Navigator.of(context).pop();
      showSnackBar(context, 'Profile Updated Successfully');
    });
  }

  Future<void> updateSubscriptionInfo({
    required UserModel userModel,
    required WidgetRef ref,
  }) async {
    state = true;
    UserModel user = await getUserInfoByUidFuture(userModel.uid);
    ref.read(authNotifierCtr).setUserModelData(user);
    state = false;

    // final result2 =
    // await _databaseApis.updateCurrentUserInfo(userModel: userModel);
    // result2.fold((l) {
    //   state = false;
    //   debugPrintStack(stackTrace: l.stackTrace);
    //   debugPrint(l.message);
    // }, (r) {
    //   state = false;
    //   ref.read(authNotifierCtr).setUserModelData(userModel);
    // });
  }

  Future<void> updateUserHomeAddress(
      {required BuildContext context,
      required LocationDetails address,
      required bool isHomeAddress,
      required WidgetRef ref,
      required bool isSignUp}) async {
    state = true;
    final result2;
    if (isHomeAddress) {
      result2 = await _databaseApis.updateUserHomeAddress(
          userId: _authApis.getCurrUser()!.uid, homeAddress: address);
    } else {
      result2 = await _databaseApis.updateUserWorkAddress(
          userId: _authApis.getCurrUser()!.uid, workAddress: address);
    }
    final userMap = await _databaseApis.getCurrentUserInfo(
        uid: _authApis.getCurrUser()!.uid);
    final user = UserModel.fromMap(userMap.data() as Map<String, dynamic>);
    ref.read(authNotifierCtr).setUserModelData(user);
    result2.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      if (isSignUp) {
        if (user.homeAddress != null && user.workAddress != null) {
          state = false;
          Navigator.pushNamed(context, AppRoutes.followFavoriteScreen);
          return;
        }
      }
      state = false;
      Navigator.of(context).pop();
      showSnackBar(context, 'Address Updated Successfully');
    });
  }

  Future<void> changeUserPassword({
    required String currentPass,
    required String newPass,
    required BuildContext context,
  }) async {
    state = true;
    final result = await _authApis.changePassword(
        currentPassword: currentPass, newPassword: newPass);
    state = false;
    result.fold((l) {
      showToast(msg: l.message);
    }, (r) {
      Navigator.pop(context);
      showToast(msg: 'Password changed successfully!');
    });
  }

  Future<void> forgetPassword({required String email}) async {
    state = true;
    final result = await _authApis.forgetPassword(email: email);
    result.fold((l) {
      state = false;
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      showToast(msg: l.message);
    }, (r) {
      state = false;
      showToast(msg: 'Password reset link sent to your email!');
    });
  }

  Future<void> deleteAccount(
      {required BuildContext context,
      String? password,
      required bool isGoogle}) async {
    state = true;
    final user = await _authApis.getCurrentUser();
    if (user == null) {
      state = false;
      return;
    }
    final uid = user.uid;
    final result2 = await _databaseApis.deleteAccount(
        uid: uid, isGoogle: isGoogle, password: password);

    result2.fold((l) {
      state = false;
      showSnackBar(context, l.message);
      return;
    }, (r) {
      state = false;
      showSnackBar(context, 'Account Deleted Successfully!');
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.splashScreen, (route) => false);
    });
  }

  /// quick access methods.
  Future<void> updateQuickAccess(
      {required BuildContext context, required String newId}) async {
    state = true;
    final userId = _authApis.getCurrentUserId();
    if (userId == null) {
      return;
    }
    List<String> placesId = await getAllQuickAccess(context).first;
    if (placesId.contains(newId)) {
      placesId.remove(newId);
    } else {
      placesId.add(newId);
    }
    final result1 = await _databaseApis.updateQuickAccess(
        quickAccess: placesId, userId: userId);
    result1.fold((l) {
      state = false;
      print(l.message);
      showSnackBar(context, l.message);
    }, (r) {
      state = false;
      if (placesId.contains(newId)) {
        Navigator.of(context).pop();
        showSnackBar(context, 'Place added Successfully');
      } else {
        showSnackBar(context, 'Place removed Successfully');
      }
    });
  }

  Stream<List<String>> getAllQuickAccess(
    BuildContext context,
  ) {
    try {
      final user = _authApis.getCurrentUserId();
      Stream<List<String>> placesId = _databaseApis.getAllQuickAccess(user!);
      return placesId;
    } catch (error) {
      showSnackBar(context, 'Error getting items: $error');
      return const Stream.empty();
    }
  }

  Future<List<String>> getAllQuickAccessFuture(
    BuildContext context,
  ) async {
    try {
      final user = _authApis.getCurrentUserId();
      Future<List<String>> placesId =
          _databaseApis.getAllQuickAccessFuture(user!);
      return placesId;
    } catch (error) {
      showSnackBar(context, 'Error getting items: $error');
      return [];
    }
  }

  /// Favourites methods.
  Future<void> updateFavorites({
    required BuildContext context,
    required WidgetRef ref,
    required FavoriteModel favoriteModel,
  }) async {
    state = true;
    final userId = _authApis.getCurrentUserId();

    // List<String>? places = ref.read(authNotifierCtr).likePlaces;
    if (userId == null) {
      return;
    }
    final place = await _databaseApis
        .getFavouritesById(userId: userId, fsqId: favoriteModel.fsqId)
        .first;
    bool isContain = place != null;

    dynamic result1;
    if (isContain) {
      result1 = await _databaseApis.removeFromFavourites(
        favourite: favoriteModel,
      );
      // places.remove(favoriteModel.fsqId);
    } else {
      result1 = await _databaseApis.addToFavourites(
          favourite: favoriteModel, userId: userId);
      // places?.add(favoriteModel.fsqId);
    }
    // ref.read(authNotifierCtr).setPlaces(places);
    result1.fold((l) {
      state = false;
      print(l.message);
      showSnackBar(context, l.message);
    }, (r) {
      state = false;
      showToast(
        msg: !isContain ? 'Liked Successfully' : 'Removed Successfully',
      );
      if (!isContain) {
        Navigator.of(context).pop();
      }
    });
  }

  Stream<List<FavoriteModel>> getAllFavourites() {
    try {
      final user = _authApis.getCurrentUserId();
      if (user == null) {
        return const Stream.empty();
      }
      final Stream<List<Map<String, dynamic>>> places =
          _databaseApis.getAllFavourites(user);

      return places.map((List<Map<String, dynamic>> favoritesData) {
        return favoritesData
            .map((data) => FavoriteModel.fromMap(data))
            .toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<FavoriteModel?> getFavoriteById({required String fsqId}) {
    try {
      final user = _authApis.getCurrentUserId();
      if (user == null) {
        return Stream.value(null);
      }

      final Stream<Map<String, dynamic>?> place =
          _databaseApis.getFavouritesById(userId: user, fsqId: fsqId);
      return place.map(
          (place1) => place1 == null ? null : FavoriteModel.fromMap(place1));
    } catch (error) {
      return  Stream.value(null);
    }
  }

  Future<bool> updateEmailAddress(
      {required String newEmail,
        required String pass}) async {
    state = true;
    final result =
        await _databaseApis.updateEmailAddress(newEmail: newEmail, pass: pass);
    return result.fold((l) {
      state = false;
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      showToast(msg: l.message);
      return false;
    }, (r) {
      return true;
    });
  }

  Future<String> getEmailForFeedback() async {
    final result =
        await _databaseApis.getEmailForFeedback();
    return result;
  }
}
