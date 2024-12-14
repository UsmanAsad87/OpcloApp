import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_widgets/custom_button.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/assets_manager.dart';

import '../../../../commons/common_functions/check_conectivity.dart';
import '../../../../commons/common_functions/show_login.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../main_menu/controller/main_menu_controller.dart';
import '../../no_internet/views/no_connection.dart';
import 'favorites.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  final bool pop;

  const FavouritesScreen({
    super.key,
    required this.pop,
  });

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  bool isInternet = true;
  bool userExist = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final userModel = ref.watch(authNotifierCtr).userModel;
      isInternet = await isInternetConnected();
      userExist = userModel != null;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isInternet
        ? NoConnection(
            onTap: () {
              setState(() {
                isInternet = true;
              });
              init();
            },
          )
        : userExist
            ? Favorites(
                pop: widget.pop,
              )
            : Scaffold(
                backgroundColor: context.whiteColor,
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: context.whiteColor,
                  elevation: 0,
                  leading: IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      widget.pop
                          ? Navigator.pop(context)
                          : ref.read(mainMenuProvider).setIndex(0);
                      // Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: context.titleColor,
                    ),
                  ),
                  title: Text(
                    'Favorites',
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size18),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.all(AppConstants.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(AppAssets.noFavourites, width: 230.w,),
                          padding18,
                          Text(
                            'Login to add favorites',
                            style: getSemiBoldStyle(
                                color: context.titleColor, fontSize: MyFonts.size18),
                          ),
                        ],
                      ),
                      CustomButton(onPressed: () {
                        showLogInBottomSheet(context: context);
                      }, buttonText: 'LogIn'),
                    ],
                  ),
                ),
              );
  }
}
