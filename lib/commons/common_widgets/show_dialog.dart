
import '../common_imports/common_libs.dart';

showCustomDialog({
  required BuildContext context,
  required Widget content,
  Alignment alignment = Alignment.center,
}) {
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: MyColors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(alignment: alignment, child: content);
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  );
}
