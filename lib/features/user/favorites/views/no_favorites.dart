import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../utils/constants/font_manager.dart';

class NoFavorites extends StatelessWidget {
  final Function() startSearch;
  final bool showAppbar;

  const NoFavorites({Key? key,
    required this.startSearch,
    this.showAppbar = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: showAppbar ? AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: context.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'No Favorites',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size18),
        ),
      ) : null,
      body: Column(
        children: [
          padding64,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 32.r),
            child: Image.asset(
              AppAssets.noFavourites,
              width: 266.w,
             // height: 300.h,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Text(
                'Save places you love',
                style: getSemiBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size20),
              ),
            ),
          ),
          SizedBox(
            width: 210.w,
            child: Text(
              'Tap the heart on a listing to save it here!',
              textAlign: TextAlign.center,
              style: getMediumStyle(
                  color: context.titleColor.withOpacity(.5),
                  fontSize: MyFonts.size13),
            ),
          ),
          padding18,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.r),
            child: CustomButton(
                onPressed: startSearch,
                buttonWidth: 200.w,
                buttonHeight: 53.h,
                buttonText: 'Start Searching'),
          ),
        ],
      ),
    );
  }
}
