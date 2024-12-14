import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';
import '../controller/filter_notifier_controller.dart';
import 'filter_bottom_sheet.dart';

class SortContainer extends StatelessWidget {

  const SortContainer({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final filterRef = ref.watch(filterNotifierCtr);
        return Row(
          children: [
            for (var option in sortingOptions)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChip(
                  label: Text(
                    option.name,
                    style: getMediumStyle(
                        color: filterRef.selectedSortOption?.value == option.value
                            ? context.whiteColor
                            : context.primaryColor,
                        fontSize: MyFonts.size11),
                  ),
                  side: BorderSide(color: context.primaryColor),
                  selectedColor: context.primaryColor,
                  disabledColor: context.primaryColor,
                  checkmarkColor: context.whiteColor,
                  selected: filterRef.selectedSortOption?.value == option.value,
                  onSelected: (selected) {
                    if (selected) {
                      filterRef.selectSortOption(option);
                    } else {
                      filterRef.selectSortOption(null);
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

final List<SortingOption> sortingOptions = [
  SortingOption(name: 'Relevance', value: 'RELEVANCE'), //relevance
  SortingOption(name: 'Distance', value: 'DISTANCE'), //distance
  SortingOption(name: 'Rating', value: 'RATING'), //rating
];

class SortingOption {
  final String name;
  final String value;

  SortingOption({required this.name, required this.value});
}
