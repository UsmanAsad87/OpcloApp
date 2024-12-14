import 'package:google_sign_in/google_sign_in.dart';
import 'package:opclo/commons/common_imports/apis_commons.dart';
import 'package:opclo/commons/common_providers/global_providers.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authApisProvider = Provider<AuthApis>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthApis(auth: auth);
});

abstract class IAuthApis {
  // FutureEither<User> signInWithEmailAndPass(
  //     {required String email, required String password});
  FutureEitherVoid logout();

  Future<User?> getCurrentUser();

  String? getCurrentUserId();

  Stream<User?> getSigninStatusOfUser();

  FutureEither<UserCredential> signInWithApple();

  FutureEither<UserCredential> signInWithAppleNewMethod();
}

class AuthApis implements IAuthApis {
  final FirebaseAuth _auth;

  AuthApis({required FirebaseAuth auth}) : _auth = auth;

  @override
  FutureEitherVoid logout() async {
    try {
      final googleSignIn = GoogleSignIn();
      var isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn) await googleSignIn.signOut();
      final response = await _auth.signOut();
      return Right(response);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  // @override
  FutureEither<User> registerWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // User user = response.user!;
      // await user.sendEmailVerification();
      return Right(response.user!);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<UserCredential> signInWithApple() async {
    try {
      final appleAuthProvider = AppleAuthProvider();
      appleAuthProvider.addScope('email');
      appleAuthProvider.addScope('fullName');
      appleAuthProvider.addScope('name');
      appleAuthProvider.addScope('picture');
      final auth = await _auth.signInWithProvider(appleAuthProvider);
      print(auth);
      return Right(auth);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<UserCredential> signInWithAppleNewMethod() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      print("UsmanTest");
      print(credential);
      print(appleCredential);
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;
      return Right(authResult);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  User? getCurrUser() {
    return _auth.currentUser;
  }

  @override
  Stream<User?> getSigninStatusOfUser() {
    return _auth.authStateChanges();
  }

  FutureEither<User> signInStaffWithUsernameAndPass(
      {required String email, required String password}) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(response.user!);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid changePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      var user = _auth.currentUser!;
      var credentials = EmailAuthProvider.credential(
          email: _auth.currentUser!.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credentials);
      await _auth.currentUser!.updatePassword(newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid forgetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }
}
