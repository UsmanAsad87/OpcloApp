import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../models/place_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../restaurant/controller/places_controller.dart';
import '../../welcome/widgets/item_contaianer.dart';

class PlacesQueryScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final String query;

  const PlacesQueryScreen(
      {Key? key, required this.categoryName, required this.query})
      : super(key: key);

  @override
  ConsumerState<PlacesQueryScreen> createState() => _PlacesQueryScreenState();
}

class _PlacesQueryScreenState extends ConsumerState<PlacesQueryScreen> {
  ScrollController _scrollController = ScrollController();
  List<PlaceModel> _places = [];
  String? _nextPageLink;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _getInitialPlaces();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getInitialPlaces() async {
    // PlacesAndLink result = await ref
    //     .read(placesControllerProvider.notifier)
    //     .getSearchPlacesCategories(categories: widget.query);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    PlacesAndLink result = await ref
        .read(placesControllerProvider.notifier)
        .getSearchPlacesOpenNowQuery(query: widget.query,openNow: true);
    setState(() {
      _places = result.places ?? [];
      _nextPageLink = extractNextPageLink(result.link); //result.link?[0];
    });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('Calling ...');
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
  //         (element) => element.contains('rel="next"'),
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
        backgroundColor: context.whiteColor,
        elevation: 0,
        leading: InkWell(
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
            child: _places.isEmpty
                ? PlaceListShimmer(count: 5)
                : Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _places.length,
                  itemBuilder: (context, index) {
                    return ResturantItemContainer(
                      placeModel: _places[index],
                    );
                  },
                ),
                isLoading
                    ? PlaceListShimmer(count: 2)
                    : SizedBox()
              ],
            )
        ),
      ),
    );
  }
}