import 'dart:io';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/utils/constants/app_constants.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import '../../../../models/favorite_model.dart';
import '../../../../models/place_model.dart';
import '../../../../models/user_model.dart';
import '../../../../routes/route_manager.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import '../../restaurant/controller/places_controller.dart';
import '../widgets/item_contaianer.dart';

class FollowFavoritesScreen extends ConsumerStatefulWidget {
  FollowFavoritesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FollowFavoritesScreen> createState() =>
      _FollowFavoritesScreenState();
}

class _FollowFavoritesScreenState extends ConsumerState<FollowFavoritesScreen> {
  ScrollController _scrollController = ScrollController();
  List<PlaceModel> _places = [];
  String? _nextPageLink;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getInitialPlaces();
    _scrollController.addListener(_scrollListener);
    initialization();
  }

  /// Here in this method, we are initializing necessary methods
  initialization() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserModel? userModel =
          await ref.read(authControllerProvider.notifier).getCurrentUserInfo();
      ref.read(authNotifierCtr).setUserModelData(userModel);
      // List<FavoriteModel>? places = await ref
      //     .read(authControllerProvider.notifier)
      //     .getAllFavourites()
      //     .first;
      // ref.read(authNotifierCtr).setPlaces(places.map((e) => e.fsqId).toList());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getInitialPlaces() async {
    final user = ref.read(authNotifierCtr).userModel;
    PlacesAndLink result = await ref
        .read(placesControllerProvider.notifier)
        .getTopPlace(
          limit: 10,
          userLat: user?.homeAddress?.latitude ?? user?.workAddress?.latitude,
          userLng: user?.homeAddress?.longitude ?? user?.workAddress?.longitude,
        );
    setState(() {
      _places = result.places ?? [];
      _nextPageLink = extractNextPageLink(result.link); //result.link?[0];
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_nextPageLink != null) {
        setState(() {
          isLoading = true;
        });
        _loadNextPage();
      }
    }
  }

  void _loadNextPage() async {
    PlacesAndLink result = await ref
        .read(placesControllerProvider.notifier)
        .getNextPage(nextPage: _nextPageLink!);
    setState(() {
      _places.addAll(result.places ?? []);
      _nextPageLink = extractNextPageLink(result.link);
      isLoading = false;
    });
  }

  // /// get Next Page Page.
  // String? extractNextPageLink(List<String>? links) {
  //   if (links == null || links.isEmpty) {
  //     return null;
  //   }
  //   final link = links.firstWhere(
  //     (element) => element.contains('rel="next"'),
  //     orElse: () => '',
  //   );
  //   final startIndex = link.indexOf('<');
  //   final endIndex = link.indexOf('>');
  //   if (startIndex != -1 && endIndex != -1) {
  //     return link.substring(startIndex + 1, endIndex);
  //   }
  //   return null;
  // }

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
        actions: [
          Consumer(builder: (context, ref, child) {
            return ref.watch(favoritesStreamProvider).when(
                  data: (favourites) => TextButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        Navigator.pushNamed(
                            context, AppRoutes.conformationScreen);
                      } else {
                        Navigator.pushNamed(
                            context, AppRoutes.subscriptionScreenFromSignup);
                      }
                    },
                    child: Text(
                      favourites.isNotEmpty ? 'Next' : 'Skip',
                      style: getMediumStyle(
                          color: context.primaryColor,
                          fontSize: MyFonts.size16),
                    ),
                  ),
                  error: (e, s) => SizedBox(),
                  loading: () => Text(
                    'Skip',
                    style: getMediumStyle(
                        color: context.primaryColor, fontSize: MyFonts.size16),
                  ),
                );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.allPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Follow Your',
                style: getBoldStyle(
                    color: context.titleColor, fontSize: MyFonts.size30),
              ),
              Text(
                'Favorites',
                style: getBoldStyle(
                    color: context.primaryColor, fontSize: MyFonts.size30),
              ),
              Text(
                'Tell us which places you love, and we’ll help you get set up',
                style: getMediumStyle(
                    color: context.titleColor.withOpacity(.4.r),
                    fontSize: MyFonts.size14),
              ),
              SingleChildScrollView(
                controller: _scrollController,
                child: _places.isEmpty
                    ? PlaceListShimmer(count: 5)
                    : Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _places.length,
                            itemBuilder: (context, index) {
                              return ResturantItemContainer(
                                placeModel: _places[index],
                              );
                            },
                          ),
                          isLoading ? PlaceListShimmer(count: 3) : SizedBox()
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
