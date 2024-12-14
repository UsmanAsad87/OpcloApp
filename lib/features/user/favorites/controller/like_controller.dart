import 'package:opclo/features/user/favorites/api/like_api.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../../models/like_group_model.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';

final likeGroupControllerProvider =
    StateNotifierProvider<LikeGroupController, bool>((ref) {
  return LikeGroupController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(likeGroupDatabaseApiProvider),
  );
});

final getAllLikeGroupsProvider = StreamProvider((
  ref,
) {
  final couponCtr = ref.watch(likeGroupControllerProvider.notifier);
  return couponCtr.getAllLikeGroups();
});

class LikeGroupController extends StateNotifier<bool> {
  final LikeGroupDatabaseApi _databaseApis;
  final AuthApis _authApis;

  LikeGroupController({
    required LikeGroupDatabaseApi databaseApis,
    required AuthApis authApis,
  })  : _databaseApis = databaseApis,
        _authApis = authApis,
        super(false);

  Future<void> addLikeGroup({
    required BuildContext context,
    required LikeGroupModel likeGroupModel,
  }) async {
    state = true;
    final user = _authApis.getCurrUser();
    final result = await _databaseApis.addLikeGroup(
        likeModel: likeGroupModel, userId: user!.uid);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Group added successfully');
      // Navigator.of(context).pop();
    });
  }

  Future<void> deleteLikeGroup({
    required BuildContext context,
    required String groupId,
  }) async {
    state = true;
    final user = _authApis.getCurrUser();
    final result = await _databaseApis.deleteLikeGroup(
        userId: user!.uid, groupId: groupId);
    result.fold((l) {
      state = false;
      // showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      // showSnackBar(context, 'Group deleted successfully');
    });
  }

  Future<void> updateLikeGroupName({
    required BuildContext context,
    required String groupId,
    required String groupName,
  }) async {
    state = true;
    final user = _authApis.getCurrUser();
    print(groupName);
    final result = await _databaseApis.updateLikeGroupName(
        groupId: groupId, groupName: groupName, userId: user!.uid);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Group Name change successfully');
    });
  }

  Future<void> updateOrderIndex({
    required List<LikeGroupModel> groups,
  }) async {
    final user = _authApis.getCurrUser();
     await _databaseApis.updateOrderIndex(
        groups: groups, userId: user!.uid);
  }

  Stream<List<LikeGroupModel>> getAllLikeGroups() {
    try {
      final user = _authApis.getCurrUser();
      Stream<List<LikeGroupModel>> likeGroups =
          _databaseApis.getAllLikeGroups(userId: user!.uid);
      return likeGroups;
    } catch (error) {
      return const Stream.empty();
    }
  }
}
