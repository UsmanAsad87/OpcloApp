import '../../../commons/common_imports/apis_commons.dart';
import '../../../commons/common_widgets/show_toast.dart';
import '../../../models/preference_model/preference_model.dart';
import '../database/preference_database.dart';

final preferencesControllerProvider =
StateNotifierProvider<PreferencesController, bool>((ref) {
  return PreferencesController(
    preferencesApis: ref.watch(preferenceApisProvider),
  );
});


class PreferencesController extends StateNotifier<bool> {
  final PreferenceDatabase _preferencesApis;

  PreferencesController({required PreferenceDatabase preferencesApis})
      : _preferencesApis = preferencesApis,
        super(false);

  Future<void> savePreference({required PreferenceModel pref}) async {
    final result = await _preferencesApis.savePreference(pref: pref);
    result.fold((l) {
      state = false;
      showToast(msg: l.message);
    }, (r) async {
      state = false;
    });
  }
}