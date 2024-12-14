import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../../commons/common_functions/padding.dart';
import '../../../../../commons/common_imports/common_libs.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/assets_manager.dart';
import '../../../../../utils/constants/font_manager.dart';
import '../../controller/alert_notifier.dart';
import '../custom_widgets/buttons_row.dart';
import '../custom_widgets/custom_radio_button.dart';

class BlackOrWomenOwned extends StatefulWidget {
  const BlackOrWomenOwned({Key? key}) : super(key: key);

  @override
  State<BlackOrWomenOwned> createState() => _BlackOrWomenOwnedState();
}

class _BlackOrWomenOwnedState extends State<BlackOrWomenOwned> {
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
                  AppAssets.womenImage,

                  width: 106.w,
                  height: 106.h,
                ),
                padding16,
                Text(
                  'Black Or Women Owned',
                  style: getSemiBoldStyle(
                      color: context.titleColor, fontSize: MyFonts.size18),
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
                        style: getSemiBoldStyle(color: context.titleColor),
                      ),
                      padding16,
                      CustomRadioButton(
                          selectedRadioValue: selectedRadioValue ?? '',
                          value: 'black',
                          buttonName: 'Black Owned',
                          leadingIcon: AppAssets.blackOwnedImage,
                          onChange: (value) {
                            ref.read(selectedAlertOptionNotifier.notifier)
                                .setOption(option: AlertTypeEnum.blackOwned/*'Black Owned'*/);
                            setState(() {
                              selectedRadioValue = 'black';
                            });
                          }),
                      padding8,
                      CustomRadioButton(
                          selectedRadioValue: selectedRadioValue ?? '',
                          value: 'women',
                          buttonName: 'Women Owned',
                          leadingIcon: AppAssets.womenOwnedImage,
                          onChange: (value) {
                            ref.read(selectedAlertOptionNotifier.notifier)
                                .setOption(option: AlertTypeEnum.womenOwned /*'Women Owned'*/);
                            setState(() {
                              selectedRadioValue = 'women';
                            });
                          }),
                    ]);
              }
            ),
            padding16,
            ButtonsRow(
                // saveOnpress: () {}
            )
          ],
        ),
      ),
    );
  }
}
