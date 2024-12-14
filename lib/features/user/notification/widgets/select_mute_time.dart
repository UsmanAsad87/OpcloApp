import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../alert/alerts_extended/custom_widgets/custom_radio.dart';

final selectMuteTimeProvider =
    ChangeNotifierProvider<SelectedMuteTime>((ref) => SelectedMuteTime());

class SelectedMuteTime extends ChangeNotifier {
  String _selectedIndex = '1 Day';

  String get selectedIndex => _selectedIndex;

  void selectIndex(String label, BuildContext context) {
    _selectedIndex = label;
    notifyListeners();
    Navigator.of(context).pop();
  }
}

class SelectableMuteOption extends ConsumerWidget {
  final int index;
  final String label;
  final Function() onTap;

  const SelectableMuteOption(
      {required this.index, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectMuteTimeProvider).selectedIndex == label;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 16.w,
                    ),
                    child: CustomRadio(
                      isSelected: isSelected,
                      // isSelected,
                      size: 24.r,
                      borderWidth: 3.r,
                      padding: 3.r,
                      onChanged: (value) {
                        ref
                            .watch(selectMuteTimeProvider)
                            .selectIndex(label, context);
                        onTap();
                      },
                    ),
                  ),
                  Text(
                    label,
                    style: getMediumStyle(
                        fontSize: MyFonts.size16, color: context.titleColor),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 18.r,
                  color: context.titleColor,
                  weight: 30,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Divider(
              color: context.titleColor.withOpacity(.3),
            ),
          ),
        ],
      ),
    );
  }
}
