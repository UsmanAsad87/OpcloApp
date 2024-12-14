import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/models/feedback_model.dart';
import '../../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_providers/global_providers.dart';
import '../../../../core/constants/firebase_constants.dart';

final feedbackDatabaseApiProvider = Provider<FeedbackDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return FeedbackDatabaseApi(firebase: firebase);
});

class FeedbackDatabaseApi {
  final FirebaseFirestore _firestore;

//
  FeedbackDatabaseApi({required FirebaseFirestore firebase})
      : _firestore = firebase;

  FutureEitherVoid addFeedBack({required FeedbackModel feedBack}) async {
    try {
      final productRef = _firestore
          .collection(FirebaseConstants.feedbackCollection)
          .doc(feedBack.id);
      await productRef.set(feedBack.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occure', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

}
