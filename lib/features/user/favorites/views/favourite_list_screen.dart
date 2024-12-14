import 'package:flutter/material.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/favorites/views/no_favorites.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../models/favorite_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../restaurant/controller/places_controller.dart';
import '../../welcome/widgets/item_contaianer.dart';

class FavouriteListScreen extends StatelessWidget {
  final String? groupId;

  const FavouriteListScreen({Key? key, this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        backgroundColor: context.whiteColor,
        elevation: 0,
        leading: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () {
            Navigator.of(context).pop();
          },
          splashColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
          'Favorites',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size16),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer(builder: (context, ref, child) {
        return ref.watch(favoritesStreamProvider).when(
            data: (placesId) {
              List<FavoriteModel> filterPlaces;
              if (groupId != null) {
                filterPlaces = placesId
                    .where((place) => place.groupId == groupId)
                    .toList();
              } else {
                filterPlaces = placesId;
              }
              return filterPlaces.isEmpty
                  ? NoFavorites(
                showAppbar: false,
                  startSearch: () {
                      Navigator.of(context).pop();
                    })
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filterPlaces.length,
                      itemBuilder: (context, index) {
                        return ref
                            .watch(getPlacesByIdProvider(
                                filterPlaces[index].fsqId))
                            .when(
                                data: (place) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppConstants.horizontalPadding),
                                    child: ResturantItemContainer(
                                      placeModel: place,
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    SizedBox(),
                                loading: () => LoadingWidget());
                      },
                    );
            },
            error: (error, stackTrace) => SizedBox(),
            loading: () => Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalPadding),
                  child: PlaceListShimmer(count: 5),
                ));
      }),
    );
  }
}
