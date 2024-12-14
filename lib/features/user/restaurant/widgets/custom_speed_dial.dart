import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/alert/controller/alert_notifier.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../commons/common_functions/check_user_exist.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_providers/shared_pref_helper.dart';
import '../../../../models/place_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../auth/view/auth_screen.dart';

class CustomSpeedDial extends ConsumerStatefulWidget {
  // const CustomSpeedDial({Key? key}) : super(key: key);
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  // final bool? mini;
  final bool? isSpeedDialOpen;
  final PlaceModel place;

  CustomSpeedDial({
    Key? key,
    this.onOpen,
    this.onClose,
    required this.place,
    this.isSpeedDialOpen,
  }) : super(key: key);

  @override
  ConsumerState<CustomSpeedDial> createState() =>
      _CustomSpeedDialState();
}

class _CustomSpeedDialState extends ConsumerState<CustomSpeedDial> {

  var mini = false;
  var rmicons = false;
  var useRAnimation = true;
  var buttonSize = Size(56.0.w, 56.0.h);
  var childrenButtonSize = Size(56.0.w, 56.0.h);

  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  bool showSpeedButton = true;

  Future<void> _checkSpeedButtonPreference() async {
    final result = await SharedPrefHelper.getSpeedButton();
    setState(() {
      showSpeedButton = result;
    });

    if (showSpeedButton) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_one, _two]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSpeedButtonPreference();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([_one, _two]);
    });
  }

  @override
  Widget build(BuildContext context,) {
    if (showSpeedButton){
      SharedPrefHelper.setSpeedButton(false);
      return Showcase(
        key: _one,
        title: "All in One",
        titleTextStyle: getSemiBoldStyle(
            color: context.whiteColor, fontSize: MyFonts.size20),
        showArrow: true,
        targetBorderRadius: BorderRadius.circular(50.r),
        descTextStyle:
        getMediumStyle(color: context.whiteColor, fontSize: MyFonts.size11),
        descriptionAlignment: TextAlign.left,
        description: 'Now you can set alerts, set reminders and take notes',
        tooltipBackgroundColor: Colors.transparent,
        child: speedDialButton(),
        disposeOnTap: true,
        onTargetClick: () {
          SharedPrefHelper.setSpeedButton(false);
          ShowCaseWidget.of(context).dismiss();
        },
      );
    }
    return speedDialButton();
  }

  speedDialButton(){
    return SpeedDial(
      renderOverlay: true,
      icon: Icons.add,
      activeBackgroundColor: MyColors.pizzaHutColor,
      activeIcon: Icons.close,
      spacing: 3.h,
      mini: mini,
      childPadding: EdgeInsets.all(5.r),
      spaceBetweenChildren: 4.h,
      buttonSize: buttonSize,
      iconTheme: IconThemeData(size: 26.r),
      childrenButtonSize: childrenButtonSize,
      backgroundColor: Colors.white,
      overlayColor: context.titleColor.withOpacity(.5),
      overlayOpacity: 0.5,
      useRotationAnimation: useRAnimation,
      foregroundColor: context.primaryColor,
      activeForegroundColor: context.whiteColor,
      elevation: 8.r,
      animationCurve: Curves.elasticInOut,
      isOpenOnStart: false,
      children: [
        SpeedDialChild(
            child: Image.asset(
              AppAssets.reminderIcon,
              width: 32.w,
              height: 32.h,
            ),
            labelWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'Set Reminder',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r)),
            onTap: () {
              if (!checkUserExist(ref: ref, context: context)) {
                return;
              }
              Navigator.pushNamed(context, AppRoutes.setReminderScreen,
                  arguments: {'placeModel': widget.place});
            }),
        SpeedDialChild(
            child: Image.asset(
              AppAssets.addNoteIcon,
              width: 32.w,
              height: 32.h,
            ),
            labelWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'Add Note',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r)),
            label: 'note',
            onTap: () {
              if (!checkUserExist(ref: ref, context: context)) {
                return;
              }
              Navigator.pushNamed(context, AppRoutes.addNoteScreen,
                  arguments: {'place': widget.place});
            }),
        SpeedDialChild(
            child: Image.asset(
              AppAssets.alertIcon,
              width: 28.w,
              height: 28.h,
            ),
            labelWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'Alert',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r)),
            onTap: () {
              if (!checkUserExist(ref: ref, context: context)) {
                return;
              }
              final alertNotRef = ref.read(selectedAlertOptionNotifier.notifier);
              alertNotRef.setFsqId(fsqId: widget.place.fsqId);
              alertNotRef.setplaceName(placeName: widget.place.placeName);
              Navigator.pushNamed(context, AppRoutes.alertScreen);
            }),
        SpeedDialChild(
            child: Image.asset(
              AppAssets.occasionIcon,
              width: 28.w,
              height: 28.h,
            ),
            labelWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'Occasions',
                style: getMediumStyle(
                    color: context.whiteColor, fontSize: MyFonts.size14),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r)),
            onTap: () {
              if (!checkUserExist(ref: ref, context: context)) {
                return;
              }
              Navigator.pushNamed(context, AppRoutes.occasionsScreen,
                  arguments: {'fsqId': widget.place.fsqId});
            }),
      ],
    );
  }
}
