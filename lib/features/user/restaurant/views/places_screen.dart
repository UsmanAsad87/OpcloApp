import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/restaurant/controller/places_controller.dart';
import 'package:opclo/features/user/welcome/widgets/item_contaianer.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../models/place_model.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  final String categoryIds;
  final String categoryName;
  final String? query;
  final double? radius;
  final bool isTopPlace;

  PlacesScreen({
    Key? key,
    required this.categoryIds,
    required this.categoryName,
    this.query,
    this.radius,
    this.isTopPlace = false,
  }) : super(key: key);

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  ScrollController _scrollController = ScrollController();

  List<PlaceModel> _places = [];
  String? _nextPageLink;
  bool isLoading = false;
  PermissionStatus? _permissionGranted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _getInitialPlaces();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getInitialPlaces() async {
    Location location = Location();
    _permissionGranted = await location.hasPermission();
    PlacesAndLink result;
    final ctr = ref.read(placesControllerProvider.notifier);
    if (widget.isTopPlace) {
      result = await ctr.getTopPlace(limit: 10);
    } else if (widget.radius != null) {
      result = await ctr.getSearchPlacesOpenNowQuery(radius: widget.radius);
    } else if (widget.query != null) {
      result = await ctr.getSearchPlacesOpenNowQuery(query: widget.query);
    } else if (widget.categoryIds == 'nearby') {
      result = await ctr.getSearchPlacesNearBy(
        radius: widget.radius ?? 1000,
      );
    } else {
      result = await ref
          .read(placesControllerProvider.notifier)
          .getSearchPlacesByCategories(
              categories: widget.categoryIds, openNow: true);
    }
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
  Widget build(
    BuildContext context,
  ) {
    // final filterModel = ref.watch(filterModelProvider);
    return Scaffold(
      backgroundColor: context.whiteColor,
      appBar: AppBar(
        backgroundColor: context.whiteColor,
        elevation: 0,
        title: Text(
          '${widget.categoryName}',
          style: getSemiBoldStyle(
              color: context.titleColor, fontSize: MyFonts.size16),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0.h),
                child: Column(
                  children: [
                    _places.isEmpty
                        ? PlaceListShimmer(count: 5)
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _places.length,
                            itemBuilder: (context, index) {
                              return ResturantItemContainer(
                                placeModel: _places[index],
                              );
                            },
                          ),
                    isLoading ? PlaceListShimmer(count: 2) : SizedBox(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
