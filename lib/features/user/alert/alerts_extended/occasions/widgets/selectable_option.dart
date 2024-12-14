import 'package:opclo/commons/common_enum/occasion_option_enum/occasion_option_enum.dart';
import 'package:opclo/commons/common_enum/occassion_type_enum/occasion_type_enum.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../utils/constants/font_manager.dart';
import '../../custom_widgets/custom_radio.dart';

final selectedOptionProvider =
    ChangeNotifierProvider<SelectedOption>((ref) => SelectedOption());

class SelectedOption extends ChangeNotifier {

  OccasionOptionEnum? _selectedOption;
  OccasionTypeEnum? _selectedOccasion;

  OccasionOptionEnum? get selectedOption => _selectedOption;
  OccasionTypeEnum? get selectedOccasion => _selectedOccasion;

  void setSelection(OccasionOptionEnum option, OccasionTypeEnum occasion) {
    _selectedOption = option;
    _selectedOccasion = occasion;
    notifyListeners();
  }

}

class SelectableOption extends StatelessWidget {
  final int index;
  final String label;
  final Function(bool?) onTap;
  final bool isSelected;

  const SelectableOption(
      {required this.onTap,
      required this.isSelected,
      required this.index,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 24.w,
            ),
            child: CustomRadio(
                isSelected: isSelected, // isSelected,
                size: 18.r,
                onChanged: onTap),
          ),
          Text(
            label,
            style: getMediumStyle(
                fontSize: MyFonts.size15, color: context.titleColor),
          ),
        ],
      ),
    );
  }
}
