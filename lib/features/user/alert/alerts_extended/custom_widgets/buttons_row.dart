import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/alert/controller/alert_controller.dart';
import 'package:opclo/features/user/alert/controller/alert_notifier.dart';
import 'package:opclo/firebase_analytics/firebase_analytics.dart';
import 'package:opclo/models/alert_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../commons/common_enum/alert_type.dart';
import '../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../commons/common_widgets/custom_button.dart';
import '../../../../../commons/common_widgets/custom_outline_button.dart';

class ButtonsRow extends StatelessWidget {
  // final cancelOnPress;
  final Function()? saveOnpress;
  final bool? isLoading;

  const ButtonsRow(
      {Key? key,
      //   required this.cancelOnPress,
      this.saveOnpress,
      this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(8.r),
          child: CustomOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              buttonText: 'Cancel'),
        )),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Consumer(builder: (context, ref, child) {
            return CustomButton(
                isLoading: isLoading ?? ref.watch(alertControllerProvider),
                onPressed: saveOnpress ??
                    () {
                      final selection = ref.read(selectedAlertOptionNotifier);
                      AlertModel alertModel = AlertModel(
                        id: Uuid().v4(),
                        fsqId: selection.selectedFsqId,
                        option: selection.selectedAlertOption,
                        userId: ref.read(authNotifierCtr).userModel!.uid,
                        uploadDate: DateTime.now(),
                        date: DateTime.now().add(Duration(
                            days: getExpireHours(selection.selectedAlertOption)
                        )
                        ),
                        placeName: selection.selectedPlaceName,
                      );
                      AnalyticsHelper.logAlertViewed(
                        alertType: selection.selectedAlertOption.type,
                        locationName: selection.selectedPlaceName,
                        fsqId: selection.selectedFsqId,
                      );
                      ref.read(alertControllerProvider.notifier).addAlert(
                          context: context, alertModel: alertModel, ref: ref);
                    },
                buttonText: 'Send');
          }),
        )),
      ],
    );
  }

  int getExpireHours(AlertTypeEnum option) {
    switch (option) {
      case AlertTypeEnum.womenOwned:
      case AlertTypeEnum.blackOwned:
      case AlertTypeEnum.incorrectHour:
      case AlertTypeEnum.dineInClosed:
      case AlertTypeEnum.driveThruClosed:
        return 7;
      case AlertTypeEnum.movedLocation:
        return 60;
      case AlertTypeEnum.maintenance:
      case AlertTypeEnum.construction:
        return 2;
      case AlertTypeEnum.cardForVaccine:
      case AlertTypeEnum.socialDistancing:
        return 30;
      default:
        return 7;
    }
  }
}
