import 'package:opclo/commons/common_providers/shared_pref_helper.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/favorites/views/favorites_screen.dart';
import 'package:opclo/features/user/home/views/home_screen.dart';
import 'package:opclo/features/user/location/views/location_screen.dart';
import 'package:opclo/features/user/notification/views/notification_screen.dart';
import 'package:opclo/features/user/profile/views/profile_screen.dart';
import 'package:opclo/features/user/restaurant/views/places_screen.dart';
import 'package:opclo/features/user/savings/views/saving_screen.dart';
import 'package:opclo/features/user/search/views/explore_screen.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../alert/widgets/thanks_dialog.dart';
import '../../feedback/views/enjoy_feedback.dart';
import '../../friends/views/friends.dart';

final mainMenuProvider = ChangeNotifierProvider((ref) => MainMenuController());

class MainMenuController extends ChangeNotifier {
  List<Widget> screens = [
    const HomeScreen(),
    const FavouritesScreen(pop: false,),
    SavingScreen(),
    // PlacesScreen(),
    const FriendsScreen(),
    const ProfileScreen()
  ];

  int _index = 0;

  int get index => _index;

  setIndex(int id) {
    _index = id;
    notifyListeners();
  }

  // Function to show the review popup if necessary
  Future<void> showReviewPopupIfNeeded(BuildContext context) async {
    if (await SharedPrefHelper.getReviewDoneStatus()) {
      return;
    }
    final installationTime = await SharedPrefHelper.trackInstallationTime();

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = currentTime - installationTime!;
    if (timeDifference >= 24 * 60 * 60 * 1000) {
      showDialog(
        context: context,
        barrierColor: context.titleColor.withOpacity(.5),
        builder: (context) {
          return const EnjoyFeedback();
        },
      );
    }
  }
}
