import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/alerts_extended/custom_widgets/buttons_row.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';

import '../../../../../../commons/common_enum/alert_type.dart';
import '../../../controller/alert_notifier.dart';
import '../../custom_widgets/custom_radio_button.dart';

class CovidScreen extends StatefulWidget {
  const CovidScreen({Key? key}) : super(key: key);

  @override
  State<CovidScreen> createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
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
                  AppAssets.covidImage,
                  width: 150.w,
                  height: 150.h,
                ),
                // padding16,
                Text(
                  'Covid',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size20),
                )
              ],
            ),
            Consumer(builder: (context, ref, child) {
              return Column(
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
                    CustomRadioButton(
                        selectedRadioValue: selectedRadioValue ?? '',
                        value: 'cardForVaccine',
                        buttonName: 'Card for Vaccine',
                        leadingIcon: AppAssets.cardImage,
                        onChange: (value) {
                          setState(() {
                            ref
                                .read(selectedAlertOptionNotifier.notifier)
                                .setOption(
                                    option: AlertTypeEnum.cardForVaccine);
                            selectedRadioValue = 'cardForVaccine';
                          });
                        }),
                    padding8,
                    CustomRadioButton(
                        selectedRadioValue: selectedRadioValue ?? '',
                        value: 'socialDistancing',
                        buttonName: 'Social Distancing',
                        leadingIcon: AppAssets.socialDistanceImage,
                        onChange: (value) {
                          ref
                              .read(selectedAlertOptionNotifier.notifier)
                              .setOption(
                                  option: AlertTypeEnum
                                      .socialDistancing);
                          setState(() {
                            selectedRadioValue = 'socialDistancing';
                          });
                        }),
                  ]);
            }),
            padding16,
            ButtonsRow(
            )
          ],
        ),
      ),
    );
  }
}
