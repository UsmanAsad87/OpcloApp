import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opclo/commons/common_functions/padding.dart';
import 'package:opclo/commons/common_functions/show_login.dart';
import 'package:opclo/commons/common_imports/common_libs.dart';
import 'package:opclo/commons/common_widgets/CustomTextFields.dart';
import 'package:opclo/commons/common_widgets/show_toast.dart';
import 'package:opclo/core/extensions/color_extension.dart';
import 'package:opclo/features/user/favorites/controller/like_controller.dart';
import 'package:opclo/features/user/restaurant/widgets/favourite_item_container.dart';
import 'package:opclo/models/like_group_model.dart';
import 'package:opclo/utils/constants/font_manager.dart';
import 'package:uuid/uuid.dart';
import '../../../../commons/common_widgets/custom_button.dart';
import '../../../../commons/common_widgets/custom_outline_button.dart';
import '../../../../models/favorite_model.dart';
import '../../../../models/place_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_notifier_controller.dart';
import 'like_group_shimmer_list.dart';

class FavoriteBottomSheet extends ConsumerStatefulWidget {
  final PlaceModel placeModel;

  const FavoriteBottomSheet({
    Key? key,
    required this.placeModel,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteBottomSheet> createState() =>
      _FavoriteBottomSheetState();
}

class _FavoriteBottomSheetState extends ConsumerState<FavoriteBottomSheet> {
  bool isCreate = false;
  bool isEdit = false;
  String selectedGroupId = '';
  TextEditingController nameController = TextEditingController();
  String selectedGroup = '';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Container(
        height: MediaQuery.of(context).viewInsets.bottom + 430.h, //430.h,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: context.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(children: [
          padding12,
          Container(
            width: 80.w,
            height: 8.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: context.titleColor.withOpacity(.2),
            ),
          ),
          padding4,
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              'Save List',
              style: getSemiBoldStyle(
                  color: context.titleColor, fontSize: MyFonts.size18),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
            child: Divider(
              color: context.titleColor.withOpacity(.3),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.padding),
              child: isCreate || isEdit
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? 'Edit Group Name' : 'Create Favorite Group',
                          style: getSemiBoldStyle(
                              color: context.titleColor,
                              fontSize: MyFonts.size12),
                        ),
                        padding4,
                        CustomTextField(
                            controller: nameController,
                            hintText: 'group name',
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {},
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () async {
                              UserModel? user =
                                  ref.watch(authNotifierCtr).userModel;
                              if (user != null) {
                                /// create like group
                                isCreate ? createGroup() : editGroupName();
                              } else {
                                showSnackBar(context, 'LogIn to Like');
                              }
                            },
                            obscure: false)
                      ],
                    )
                  : ref.watch(getAllLikeGroupsProvider).when(
                      data: (groups) {
                        return groups.isEmpty
                            ? Center(
                                child: Text(
                                  'No Group List Found',
                                  style: getSemiBoldStyle(
                                      color: context.titleColor,
                                      fontSize: MyFonts.size16),
                                ),
                              )
                            : ReorderableListView.builder(
                                itemCount: groups.length,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                buildDefaultDragHandles: true,
                                dragStartBehavior: DragStartBehavior.down,
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final item = groups.removeAt(oldIndex);
                                    groups.insert(newIndex, item);
                                  });
                                  ref
                                      .read(
                                          likeGroupControllerProvider.notifier)
                                      .updateOrderIndex(groups: groups);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return ReorderableDragStartListener(
                                      key: ValueKey('$index'),
                                      index: index,
                                      enabled: false,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedGroup = groups[index].id;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            FavouriteItemContainer(
                                              title: groups[index].groupName,
                                              id: groups[index].id,
                                              subtitle: getSubTitle(
                                                  groups: groups, index: index),
                                              isSelected: selectedGroup ==
                                                  groups[index].id,
                                              editName: () {
                                                setState(() {
                                                  isEdit = true;
                                                  nameController.text =
                                                      groups[index].groupName;
                                                  selectedGroupId =
                                                      groups[index].id;
                                                });
                                              },
                                            ),
                                            padding4,
                                            Divider(
                                              color: context.titleColor
                                                  .withOpacity(.3),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              );
                      },
                      error: (error, stackTrace) => SizedBox(),
                      loading: () => LikeGroupShimmerList()),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 14.r,
                left: AppConstants.horizontalPadding,
                right: AppConstants.horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: CustomOutlineButton(
                    onPressed: () {
                      if (isEdit) {
                        setState(() {
                          isEdit = false;
                        });
                      } else {
                        setState(() {
                          isCreate = !isCreate;
                        });
                      }
                    },
                    buttonText: isCreate || isEdit ? 'Cancel' : 'Create New',
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: CustomButton(
                      onPressed: () async {
                        UserModel? user = ref.watch(authNotifierCtr).userModel;
                        if (user != null) {
                          if (isCreate) {
                            await createGroup();
                            return;
                          }
                          if (isEdit) {
                            await editGroupName();
                            return;
                          }
                          if (selectedGroup == '') {
                            showToast(msg: 'Select group');
                            return;
                          }

                          final isPremUser = ref
                                  .watch(authNotifierCtr)
                                  .userModel
                                  ?.subscriptionIsValid ??
                              false;
                          if (!isPremUser) {
                            final fav = await ref
                                .read(authControllerProvider.notifier)
                                .getAllFavourites()
                                .first;
                            final int count = fav
                                .where((element) =>
                                    element.groupId == selectedGroup)
                                .length;
                            if (count >= 7) {
                              showLimitDialog(
                                  context: context,
                                  description:
                                      'You\'v reached the limit for adding favorites in this group, the max allow in free version is $count. Want unlimited access? Upgrade now!');
                              return;
                            }
                          }

                          FavoriteModel favorite = FavoriteModel(
                            id: const Uuid().v4(),
                            fsqId: widget.placeModel.fsqId,
                            userId: user.uid,
                            groupId: selectedGroup,
                            placeName: widget.placeModel.placeName,
                            locationName: widget.placeModel.locationName,
                            date: DateTime.now(),
                          );
                          ref
                              .read(authControllerProvider.notifier)
                              .updateFavorites(
                                  context: context,
                                  favoriteModel: favorite,
                                  ref: ref);
                        } else {
                          showSnackBar(context, 'LogIn to Like');
                        }
                        // Navigator.pop(context);
                      },
                      isLoading: ref.watch(authControllerProvider) ||
                          ref.watch(likeGroupControllerProvider),
                      buttonText: isEdit ? 'Edit' : 'Done'),
                ))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  String getSubTitle({required groups, required index}) {
    return ref.watch(favoritesStreamProvider).when(
        data: (favorite) =>
            'Total ${favorite.where((element) => element.groupId == groups[index].id).length} Items',
        error: (error, stackTrace) => '',
        loading: () => '');
  }

  createGroup() async {
    if (nameController.text == '') {
      showSnackBar(context, 'Group name is empty');
      return;
    }
    final List<LikeGroupModel> groups = await ref
        .read(likeGroupControllerProvider.notifier)
        .getAllLikeGroups()
        .first;
    final isPremUser =
        ref.watch(authNotifierCtr).userModel?.subscriptionIsValid ?? false;
    if (!isPremUser) {
      if (groups.length >= 5) {
        showLimitDialog(
            context: context,
            description:
                'You\'v reached the limit for creating favorite groups, the max allow in free version is ${groups.length}. Want unlimited access? Upgrade now!');
        return;
      }
    }
    await ref.read(likeGroupControllerProvider.notifier).addLikeGroup(
        context: context,
        likeGroupModel: LikeGroupModel(
          id: const Uuid().v4(),
          groupName: nameController.text,
          likePlaces: [widget.placeModel.fsqId],
          createdAt: DateTime.now(),
          orderIndex: groups.length + 1,
        ));
    setState(() {
      isCreate = false;
    });
    nameController.text = '';
    return;
  }

  editGroupName() async {
    if (nameController.text == '') {
      showSnackBar(context, 'Group name is empty');
      return;
    }
    await ref.read(likeGroupControllerProvider.notifier).updateLikeGroupName(
        context: context,
        groupId: selectedGroupId,
        groupName: nameController.text);
    setState(() {
      isEdit = false;
    });
    nameController.text = '';
    selectedGroupId = '';
    return;
  }
}
