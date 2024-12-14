import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/models/preference_model/preference_model.dart';
import '../../../commons/common_imports/apis_commons.dart';
import '../../../commons/common_providers/global_providers.dart';
import '../../../core/constants/firebase_constants.dart';

final preferenceApisProvider = Provider<PreferenceDatabase>((ref) {
  final fireStore = ref.watch(firebaseDatabaseProvider);
  return PreferenceDatabase(firestore: fireStore);
});

abstract class IDatabaseApis {


}

class PreferenceDatabase extends IDatabaseApis {
  final FirebaseFirestore _firestore;

  PreferenceDatabase({required FirebaseFirestore firestore}) : _firestore = firestore;

  FutureEitherVoid savePreference({required PreferenceModel pref}) async {
    try {
      await _firestore
          .collection(FirebaseConstants.preferencesCollection)
          .doc(pref.id)
          .set(pref.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

}