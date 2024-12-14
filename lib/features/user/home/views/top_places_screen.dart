import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opclo/commons/common_shimmer/place_shimmers/place_list_shimmer.dart';
import 'package:opclo/core/extensions/color_extension.dart';

import '../../../../commons/common_functions/extract_next_page.dart';
import '../../../../models/place_model.dart';
import '../../../../utils/constants/font_manager.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/thems/styles_manager.dart';
import '../../restaurant/controller/places_controller.dart';
import '../../welcome/widgets/item_contaianer.dart';

class TopPlacesScreen extends ConsumerStatefulWidget {
  const TopPlacesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TopPlacesScreen> createState() => _TopPlacesScreenState();
}

class _TopPlacesScreenState extends ConsumerState<TopPlacesScreen> {
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
    PlacesAndLink result = await ref
        .read(placesControllerProvider.notifier)
        .getTopPlace(limit: 10);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: context.titleColor,
          ),
        ),
        title: Text(
         'Top places for you',
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _places.length,
                itemBuilder: (context, index) {
                  return ResturantItemContainer(
                    placeModel: _places[index],
                  );
                },
              ),
              isLoading ? PlaceListShimmer(count: 3)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}