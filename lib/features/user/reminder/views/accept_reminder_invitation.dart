import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_functions/date_time_format.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/cached_circular_network_image.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_controller.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/reminder/controller/reminder_controller.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/loading.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../models/reminder_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../widgets/reminder_container.dart';

class AcceptReminderInvitation extends StatelessWidget {
  final ReminderModel reminderModel;

  const AcceptReminderInvitation({Key? key, required this.reminderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'Accept Reminder',
          style: getSemiBoldStyle(
            color: context.titleColor,
            fontSize: MyFonts.size18,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invitation Form',
              style: getSemiBoldStyle(
                color: context.titleColor,
                fontSize: MyFonts.size18,
              ),
            ),
            padding16,
            Consumer(builder: (context, ref, child) {
              return ref
                  .watch(userInfoByIdStreamProvider(reminderModel.userId))
                  .when(
                      data: (user) {
                        return Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                              color: context.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 11,
                                  color: context.titleColor.withOpacity(.05),
                                  offset: Offset(0, 4),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Row(
                            children: [
                              CachedCircularNetworkImageWidget(
                                  image: user?.profileImage ?? '', size: 65),
                              padding8,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name ?? '',
                                    style: getMediumStyle(
                                        color: context.titleColor,
                                        fontSize: MyFonts.size14),
                                  ),
                                  Text(
                                    user?.email ?? '',
                                    style: getRegularStyle(
                                        color: context.titleColor,
                                        fontSize: MyFonts.size12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      error: (error, stackTrace) => SizedBox(),
                      loading: () => LoadingWidget());
            }),
            padding16,
            Text(
              'Invitation',
              style: getSemiBoldStyle(
                color: context.titleColor,
                fontSize: MyFonts.size18,
              ),
            ),
            ReminderContainer(reminder: reminderModel),
            padding20,
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
                        if (ref.read(authNotifierCtr).userModel != null) {
                          ref
                              .read(reminderControllerProvider.notifier)
                              .addReminder(
                                  context: context,
                                  reminderModel: reminderModel.copyWith(
                                      id: Uuid().v4(),
                                      userId: ref
                                          .read(authNotifierCtr)
                                          .userModel!
                                          .uid), isInvite: false);
                        } else {
                          showSnackBar(context, 'Login to accept invitation.');
                        }
                      },
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
