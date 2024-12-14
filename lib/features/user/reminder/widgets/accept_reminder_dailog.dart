import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:uuid/uuid.dart';

import '../../../../commons/common_functions/padding.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../commons/common_widgets/custom_outline_button.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../models/reminder_model.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../controller/reminder_controller.dart';

class AcceptReminderDialog extends StatelessWidget {
  final ReminderModel reminderModel;

  const AcceptReminderDialog({Key? key, required this.reminderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: context.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.reminderCalenderIcon,
              width: 120.w,
              height: 120.h,
            ),
            padding8,
            Text('Shared Reminder',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size23)),
            padding12,
            Text('${reminderModel.userName} shared a reminder,',
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size13)),
            Text('Would you like to add to your calendar?',
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.5),
                    fontSize: MyFonts.size13)),
            padding24,
            Row(
              children: [
                Expanded(
                    child: CustomOutlineButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        buttonText: 'Cancel')),
                padding8,
                Expanded(child: Consumer(builder: (context, ref, child) {
                  return CustomButton(
                      onPressed: () {
                        final user = ref.read(authNotifierCtr).userModel;

                        if (user != null) {
                          ReminderModel updateReminder = reminderModel.copyWith(
                              id: Uuid().v4(),
                              userId: user.uid,
                              userName: user.userName);
                          ref
                              .read(reminderControllerProvider.notifier)
                              .addReminder(
                                context: context,
                                reminderModel: updateReminder,
                                isInvite: false,
                              );
                        } else {
                          showSnackBar(context, 'Login to accept invitation.');
                        }
                      },
                      isLoading: ref.watch(reminderControllerProvider),
                      buttonText: 'Accept');
                }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
