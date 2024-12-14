import '../../features/auth/controller/auth_notifier_controller.dart';
import '../../features/auth/view/auth_screen.dart';
import '../common_imports/apis_commons.dart';
import '../common_imports/common_libs.dart';


bool checkUserExist({required WidgetRef ref, required context}) {
  if (ref.read(authNotifierCtr).userModel == null) {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const AuthScreen(isSignIn: true);
        });

    return false;
  } else {
    return true;
  }
}