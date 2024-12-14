import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../commons/common_functions/padding.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/constants/assets_manager.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../../controller/alert_notifier.dart';
import '../../custom_widgets/buttons_row.dart';
import '../../custom_widgets/custom_radio_button.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(AppConstants.allPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    AppAssets.recommendationsImage,

                    width: 106.w,
                    height: 106.h,
                  ),
                  padding16,
                  Text(
                    'Recommendations',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size20),
                  )
                ],
              ),
              padding16,
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
                            value: 'new',
                            buttonName: 'New Alerts',
                            leadingIcon: AppAssets.newAlertImage,
                            onChange: (value) {
                              ref.read(selectedAlertOptionNotifier.notifier)
                                  .setOption(option: AlertTypeEnum.newAlert/*'New Alert'*/);
                              setState(() {
                                selectedRadioValue = 'new';
                              });
                            }),
                        padding8,
                        CustomRadioButton(
                            selectedRadioValue: selectedRadioValue ?? '',
                            value: 'existing',
                            buttonName: 'existing Alerts',
                            leadingIcon: AppAssets.alertImage,
                            onChange: (value) {
                              ref.read(selectedAlertOptionNotifier.notifier)
                                  .setOption(option: AlertTypeEnum.existingAlert /*'Existing Alert'*/);
                              setState(() {
                                selectedRadioValue = 'existing';
                              });
                            }),
                      ]);
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
              padding16,
              ButtonsRow(
                // cancelOnPress: () {},
                // saveOnpress: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
