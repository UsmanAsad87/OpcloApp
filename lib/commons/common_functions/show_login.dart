import '../../features/auth/view/auth_screen.dart';
import '../../features/user/search/dialog/search_limit_dialog.dart';
import '../common_imports/common_libs.dart';
import '../common_widgets/show_dialog.dart';

showLogInBottomSheet({required BuildContext context, bool enableDrag = true}) {
  showModalBottomSheet(
      context: context,
      enableDrag: enableDrag,
      //true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AuthScreen(isSignIn: true);
      });
}

showLimitDialog({required BuildContext context, required description}) {
  showCustomDialog(
      context: context,
      content: SearchLimitDialog(
        description: description,
      ));
}
