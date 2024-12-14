import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_enum/occassion_type_enum/occasion_type_enum.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/auth/controller/auth_notifier_controller.dart';
import 'package:opclo/features/user/alert/alerts_extended/custom_widgets/buttons_row.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/api/occasion_api.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/controller/occasion_controller.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/widgets/dropDown.dart';
import 'package:opclo/models/occasion_model.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../commons/common_enum/occasion_option_enum/occasion_option_enum.dart';
import '../widgets/selectable_option.dart';

class OccasionsScreen extends ConsumerStatefulWidget {
  final String fsqId;

  const OccasionsScreen({Key? key, required this.fsqId}) : super(key: key);

  @override
  ConsumerState<OccasionsScreen> createState() => _OccasionsScreenState();
}

class _OccasionsScreenState extends ConsumerState<OccasionsScreen> {
  String? selectedRadioValue;

  @override
  Widget build(BuildContext context) {
    final selectedProvider = ref.watch(selectedOptionProvider);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      AppAssets.occasionImage,
                      width: 150.w,
                      height: 150.h,
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Text(
                        'Occasions',
                        style: getSemiBoldStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size20),
                      ),
                    ),
                  )
                ],
              ),
              padding16,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    padding8,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Select Option',
                        style: getMediumStyle(
                            color: context.titleColor,
                            fontSize: MyFonts.size16),
                      ),
                    ),
                  ],
                ),
              ]),
              padding4,
              DropDown(
                title: 'Holidays',
                icon: AppAssets.giftBoxImage,
                items: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: holidayOptions.length,
                  itemBuilder: (context, index) {
                    return SelectableOption(
                      index: index,
                      label: holidayOptions[index].type,
                      onTap: (value) {
                        selectedProvider.setSelection(
                            holidayOptions[index], OccasionTypeEnum.holidays);
                      },
                      isSelected: selectedProvider.selectedOption ==
                              holidayOptions[index] &&
                          selectedProvider.selectedOccasion ==
                              OccasionTypeEnum.holidays,
                    );
                  },
                ),
              ),
              DropDown(
                title: 'Birthdays',
                icon: AppAssets.birthDayImage,
                items: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SelectableOption(
                      index: index,
                      label: options[index].type,
                      onTap: (value) {
                        selectedProvider.setSelection(
                            options[index], OccasionTypeEnum.birthdays);
                      },
                      isSelected:
                          selectedProvider.selectedOption == options[index] &&
                              selectedProvider.selectedOccasion ==
                                  OccasionTypeEnum.birthdays,
                    );
                  },
                ),
              ),
              DropDown(
                title: 'Anniversaries',
                icon: AppAssets.valentinesDayImage,
                items: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SelectableOption(
                      index: index,
                      label: options[index].type,
                      onTap: (value) {
                        selectedProvider.setSelection(
                            options[index], OccasionTypeEnum.anniversaries);
                      },
                      isSelected:
                          selectedProvider.selectedOption == options[index] &&
                              selectedProvider.selectedOccasion ==
                                  OccasionTypeEnum.anniversaries,
                    );
                  },
                ),
              ),
              DropDown(
                title: 'Weddings',
                icon: AppAssets.weddingImage,
                items: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return SelectableOption(
                      index: index,
                      label: options[index].type,
                      onTap: (value) {
                        selectedProvider.setSelection(
                            options[index], OccasionTypeEnum.weddings);
                      },
                      isSelected:
                          selectedProvider.selectedOption == options[index] &&
                              selectedProvider.selectedOccasion ==
                                  OccasionTypeEnum.weddings,
                    );
                  },
                ),
              ),
              DropDown(
                title: 'Graduations',
                icon: AppAssets.graduationImage,
                items: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return SelectableOption(
                      index: index,
                      label: options[index].type,
                      onTap: (value) {
                        selectedProvider.setSelection(
                            options[index], OccasionTypeEnum.graduations);
                      },
                      isSelected:
                          ref.watch(selectedOptionProvider).selectedOption ==
                                  options[index] &&
                              selectedProvider.selectedOccasion ==
                                  OccasionTypeEnum.graduations,
                    );
                  },
                ),
              ),
              ButtonsRow(
                  isLoading: ref.watch(occasionControllerProvider),
                  saveOnpress: () {
                    final ctr = ref.read(selectedOptionProvider);
                    if (ctr.selectedOccasion == null ||
                        ctr.selectedOption == null) {
                      showSnackBar(context, 'Select option please.');
                      return;
                    }
                    OccasionModel occasionModel = OccasionModel(
                        id: Uuid().v4(),
                        fsqId: widget.fsqId,
                        userId: ref.read(authNotifierCtr).userModel!.uid,
                        occasionType: ctr.selectedOccasion!,
                        option: ctr.selectedOption!,
                        date: DateTime.now());
                    ref.read(occasionControllerProvider.notifier).addOccasion(
                        context: context, occasionModel: occasionModel);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  List<OccasionOptionEnum> options = [
    OccasionOptionEnum.forHer,
    OccasionOptionEnum.forHim,
    // "For her",
    // "For him",
  ];

  List<OccasionOptionEnum> holidayOptions = [
    OccasionOptionEnum.valentineDay,
    OccasionOptionEnum.mothersDay,
    OccasionOptionEnum.fathersDay,
    OccasionOptionEnum.halloween,
    OccasionOptionEnum.christmas,
    // "Valentine’s Day",
    // "Mother’s Day",
    // "Father’s Day",
    // "Halloween",
    // "Christmas",
  ];
}
