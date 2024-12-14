import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/assets_manager.dart';
import '../../../../utils/constants/font_manager.dart';

class CustomFeedbackProgressBar extends StatelessWidget {
  final int selectedStep;
  final ValueChanged<int> onValueChanged;

  CustomFeedbackProgressBar({
    Key? key,
    required this.selectedStep,
    required this.onValueChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => buildStepValue(index),
          ),
        ),
        padding4,
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            LinearProgressIndicator(
              value: (selectedStep) / 5,
              backgroundColor: context.containerColor,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00BFF3)),
              borderRadius: BorderRadius.circular(50.r),
              minHeight: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => buildStep(index),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Needs Improvement',
              style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size11),
            ),
            Text(
              'Extremely Satisfied',
              style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size11),
            ),
          ],
        )
      ],
    );
  }

  Widget buildStepValue(
    int step,
  ) {
    return GestureDetector(
      onTap: (){
        onValueChanged(step);
      },
      //     () {
      //   setState(() {
      //     widget.selectedStep = step;
      //   });
      // },
      child: Text((step).toString(),
          style: getMediumStyle(
              color: Color(0xff00BFF3), fontSize: MyFonts.size13)),
    );
  }

  Widget buildStep(int step) {
    return GestureDetector(
      onTap:  (){
        onValueChanged(step);
      },
      //     () {
      //   setState(() {
      //     widget.selectedStep = step;
      //   });
      // },
      child: step == selectedStep
          ? Image.asset(
              AppAssets.progressIcon,
              width: 25,
              height: 25,
            )
          : Container(
              width: 30,
              height: 30,
              color: Colors.transparent,
            ),
    );
  }
}
