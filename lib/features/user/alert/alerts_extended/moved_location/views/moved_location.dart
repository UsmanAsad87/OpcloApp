import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/alert/alerts_extended/custom_widgets/custom_radio_button.dart';

import '../../../../../../commons/common_functions/padding.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/constants/assets_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../controller/alert_notifier.dart';
import '../../custom_widgets/buttons_row.dart';
import '../../custom_widgets/custom_radio.dart';

class MovedLocation extends StatefulWidget {
  const MovedLocation({Key? key}) : super(key: key);

  @override
  State<MovedLocation> createState() => _MovedLocationState();
}

class _MovedLocationState extends State<MovedLocation> {
  String? selectedRadioValue;
  TextEditingController locationController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    AppAssets.locationImage,
                    width: 106.w,
                    height: 106.h,
                  ),
                  Text(
                    'Moved Location',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size20),
                  )
                ],
              ),
            ),
            // padding64,
            Column(
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
                      value: 'isMoved',
                      buttonName: 'Moved Location',
                      leadingIcon: AppAssets.redLocationImage,
                      onChange: (value) {
                        ref.read(selectedAlertOptionNotifier.notifier)
                            .setOption(option: AlertTypeEnum.movedLocation/*'Moved Location'*/);
                        setState(() {
                          selectedRadioValue = 'isMoved';
                        });
                      },
                    );
                  }
                ),
                padding16,
                Container(
                  decoration: BoxDecoration(
                    color: context.containerColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      fillColor: context.containerColor,
                      hintText: 'Add a comment here..',
                      hintStyle: getMediumStyle(
                          fontSize: MyFonts.size16,
                          color: context.titleColor.withOpacity(.4)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
            // padding64,
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
