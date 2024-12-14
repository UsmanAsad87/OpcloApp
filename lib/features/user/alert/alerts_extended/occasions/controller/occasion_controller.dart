import 'package:opclo/commons/common_enum/occassion_type_enum/occasion_type_enum.dart';
import 'package:opclo/features/user/alert/alerts_extended/occasions/api/occasion_api.dart';
import 'package:opclo/models/occasion_model.dart';

import '../../../../../../commons/common_enum/occasion_option_enum/occasion_option_enum.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/show_toast.dart';
import '../../../../../auth/data/auth_apis/auth_apis.dart';

final occasionControllerProvider =
    StateNotifierProvider<OccasionController, bool>((ref) {
  return OccasionController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(occasionDatabaseApiProvider),
  );
});

final getAllOccasionProvider = StreamProvider.family((ref, String fsqId) {
  final customerCtr = ref.watch(occasionControllerProvider.notifier);
  return customerCtr.getAllOccasion(fsqId: fsqId);
});

class OccasionController extends StateNotifier<bool> {
  final AuthApis _authApis;
  final OccasionDatabaseApi _databaseApis;

  OccasionController({
    required AuthApis authApis,
    required OccasionDatabaseApi databaseApis,
  })  : _authApis = authApis,
        _databaseApis = databaseApis,
        super(false);

  Future<void> addOccasion({
    required BuildContext context,
    required OccasionModel occasionModel,
  }) async {
    state = true;
    final oldOccasion = await _databaseApis
        .getOccasionByType(
            fsqId: occasionModel.fsqId, type: occasionModel.occasionType)
        .first;
    final result;
    if (oldOccasion.isNotEmpty) {
      if (oldOccasion.first.occasionType == OccasionTypeEnum.holidays &&
          oldOccasion.first.option != occasionModel.option) {
        final userId = _authApis.getCurrentUserId();
        final newOccasion = occasionModel.copyWith(userId: userId);
        result = await _databaseApis.addOccasion(occasionModel: newOccasion);
      } else {
        final updateAlert = oldOccasion.first.copyWith(
          date: DateTime.now(),
          userId: occasionModel.userId,
          option: handleOccasionSelection(
              oldOccasion.first.option, occasionModel.option),
        );
        result = await _databaseApis.addOccasion(occasionModel: updateAlert);
      }
    } else {
      final userId = _authApis.getCurrentUserId();
      final updatedOccasion = occasionModel.copyWith(userId: userId);
      result = await _databaseApis.addOccasion(occasionModel: updatedOccasion);
    }
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Occasion added successfully');
      Navigator.of(context).pop();
    });
  }

  Stream<List<OccasionModel>> getAllOccasion({required String fsqId}) {
    try {
      final userId = _authApis.getCurrentUserId();
      Stream<List<OccasionModel>> occasions =
          _databaseApis.getAllOccasion(fsqId: fsqId, userId: userId);
      return occasions;
    } catch (error) {
      return const Stream.empty();
      // Handle the error as needed
    }
  }

  bool isOppositeForHimOrHer(
      OccasionOptionEnum currentOption, OccasionOptionEnum newOption) {
    if ((currentOption == OccasionOptionEnum.forHim &&
            newOption == OccasionOptionEnum.forHer) ||
        (currentOption == OccasionOptionEnum.forHer &&
            newOption == OccasionOptionEnum.forHim)) {
      return true;
    }
    return false;
  }

  OccasionOptionEnum handleOccasionSelection(
      OccasionOptionEnum currentOption, OccasionOptionEnum newOption) {
    if (isOppositeForHimOrHer(currentOption, newOption)) {
      return OccasionOptionEnum.himAndHer;
    } else {
      return newOption;
    }
  }
}
