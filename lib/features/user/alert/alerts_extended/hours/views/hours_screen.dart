import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/commons/common_widgets/custom_outline_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/alerts_extended/custom_widgets/buttons_row.dart';
import 'package:opclo/features/user/alert/controller/alert_notifier.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../custom_widgets/custom_radio.dart';
import '../../custom_widgets/custom_radio_button.dart';

class HoursScreen extends StatefulWidget {
  const HoursScreen({Key? key}) : super(key: key);

  @override
  State<HoursScreen> createState() => _HoursScreenState();
}

class _HoursScreenState extends State<HoursScreen> {
  String? selectedRadioValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.whiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.allPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image.asset(
                  AppAssets.hoursImage,
                  width: 106.w,
                  height: 106.h,
                ),
                padding16,
                Text(
                  'Hours',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size20),
                )
              ],
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Option',
                    style: getMediumStyle(
                        color: context.titleColor, fontSize: MyFonts.size14),
                  ),
                  padding16,
                  Consumer(builder: (context, ref, child) {
                    return CustomRadioButton(
                        selectedRadioValue: selectedRadioValue ?? '',
                        value: 'incorrectHours',
                        buttonName: 'Incorrect Hours',
                        leadingIcon: AppAssets.clockImage,
                        onChange: (value) {
                          ref.read(selectedAlertOptionNotifier.notifier)
                              .setOption(option: AlertTypeEnum.incorrectHour/*'Incorrect Hours'*/);
                          setState(() {
                            selectedRadioValue = 'incorrectHours';
                          });
                        });
                  }),
                ]),
            padding16,
            ButtonsRow(
                // cancelOnPress: () {},
               // saveOnpress: () {}
              )
          ],
        ),
      ),
    );
  }
}
