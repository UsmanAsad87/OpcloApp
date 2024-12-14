import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/alerts_extended/custom_widgets/custom_radio_button.dart';
import '../../../../../../commons/common_functions/padding.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/constants/assets_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../controller/alert_notifier.dart';
import '../../custom_widgets/buttons_row.dart';

class DineInOrDineThru extends StatefulWidget {
  const DineInOrDineThru({Key? key}) : super(key: key);

  @override
  State<DineInOrDineThru> createState() => _DineInOrDineThruState();
}

class _DineInOrDineThruState extends State<DineInOrDineThru> {
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
                  AppAssets.driveImage,
                  width: 106.w,
                  height: 106.h,
                ),
                padding16,
                Text(
                  'Dine-In / Drive-thru',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size20),
                )
              ],
            ),
            Consumer(
              builder: (context, ref, child) {
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
                          value: 'DineIn',
                          buttonName: 'Dine-in Close',
                          leadingIcon: AppAssets.dineInImage,
                          onChange: (value) {
                            setState(() {
                              ref.read(selectedAlertOptionNotifier.notifier)
                                  .setOption(option: AlertTypeEnum.dineInClosed /*'DineIn Closed'*/);
                              selectedRadioValue = 'DineIn';
                            });
                          }),
                      padding8,
                      CustomRadioButton(
                          selectedRadioValue: selectedRadioValue ?? '',
                          value: 'DriveThru',
                          buttonName: 'Drive-thru Close',
                          leadingIcon: AppAssets.dineThruImage,
                          onChange: (value) {
                            ref.read(selectedAlertOptionNotifier.notifier)
                                .setOption(option: AlertTypeEnum.driveThruClosed /*'DineThru Closed'*/);
                            setState(() {
                              selectedRadioValue = 'DriveThru';
                            });
                          }),
                    ]);
              }
            ),
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
