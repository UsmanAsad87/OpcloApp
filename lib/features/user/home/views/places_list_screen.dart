import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/service_enabled.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../location/views/no_location.dart';
import '../../no_internet/views/no_connection.dart';
import '../../search/widgets/no_places_body.dart';
import '../../welcome/widgets/item_contaianer.dart';
import '../notifiers/places_notifier.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final String categoriesId;

  const PlacesListScreen({
    super.key,
    required this.categoryName,
    required this.categoriesId,
  });

  @override
  ConsumerState<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(placesProvider.notifier).clear();
      ref.read(placesProvider.notifier).getInitialPlaces(widget.categoriesId);
      _scrollController.addListener(_scrollListener);
    });
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(placesProvider.notifier).loadNextPage();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(placesProvider);
    return !state.isInternet
        ? NoConnection(
            onTap: () {
              ref
                  .read(placesProvider.notifier)
                  .getInitialPlaces(widget.categoriesId);
            },
          )
        : state.locationEnabled
            ? Scaffold(
                backgroundColor: context.whiteColor,
                appBar: AppBar(
                  backgroundColor: context.whiteColor,
                  elevation: 0,
                  leading: InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: context.titleColor,
                    ),
                  ),
                  title: Text(
                    widget.categoryName,
                    style: getSemiBoldStyle(
                        color: context.titleColor, fontSize: MyFonts.size16),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                ),
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0.h),
                    child: state.isLoading && state.places.isEmpty
                        ? const PlaceListShimmer(count: 5)
                        : state.places.isEmpty
                            ? const Center(child: NoPlaceWidget())
                            : Column(
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.places.length,
                                    itemBuilder: (context, index) {
                                      return ResturantItemContainer(
                                        placeModel: state.places[index],
                                      );
                                    },
                                  ),
                                  state.isLoading
                                      ? const PlaceListShimmer(count: 2)
                                      : const SizedBox(),
                                ],
                              ),
                  ),
                ),
              ) : NoLocation(onTap: () async {
                final isEnable = await enableService();
                if (isEnable) {
                  ref
                      .read(placesProvider.notifier)
                      .getInitialPlaces(widget.categoriesId);
                }
              });
  }
}
