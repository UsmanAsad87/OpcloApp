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

class TemporarilyColse extends StatefulWidget {
  const TemporarilyColse({Key? key}) : super(key: key);

  @override
  State<TemporarilyColse> createState() => _TemporarilyColseState();
}

class _TemporarilyColseState extends State<TemporarilyColse> {
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
                  AppAssets.closeImage,
                  width: 150,
                  height: 150,
                ),
                padding16,
                Text(
                  'Temporarily Close',
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
                  Consumer(
                    builder: (context, ref, child) {
                      return CustomRadioButton(
                        selectedRadioValue: selectedRadioValue ?? '',
                        value: 'Maintenance',
                        buttonName: 'Planned Maintenance',
                        leadingIcon: AppAssets.maintenanceImage,
                        onChange: (value) {
                          ref.read(selectedAlertOptionNotifier.notifier)
                              .setOption(option: AlertTypeEnum.maintenance);
                          setState(() {
                            selectedRadioValue = 'Maintenance';
                          });
                        },
                      );
                    }
                  ),
                  padding8,
                  Consumer(builder: (context, ref, child) {
                    return CustomRadioButton(
                        selectedRadioValue: selectedRadioValue ?? '',
                        value: 'Construction',
                        buttonName: 'Under Construction',
                        leadingIcon: AppAssets.constructionImage,
                        onChange: (value) {
                          ref.read(selectedAlertOptionNotifier.notifier)
                              .setOption(option: AlertTypeEnum.construction);
                          setState(() {
                            selectedRadioValue = 'Construction';
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
