import 'package:opclo/features/user/feedback/api/feedback_api.dart';
import 'package:opclo/models/feedback_model.dart';
import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_imports/common_libs.dart';
import '../../../../commons/common_widgets/show_toast.dart';
import '../../../auth/data/auth_apis/auth_apis.dart';


final feedbackControllerProvider =
StateNotifierProvider<FeedbackController, bool>((ref) {
  return FeedbackController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(feedbackDatabaseApiProvider),
  );
});


class FeedbackController extends StateNotifier<bool> {
  final AuthApis _authApis;
  final FeedbackDatabaseApi _databaseApis;

  FeedbackController({
    required AuthApis authApis,
    required FeedbackDatabaseApi databaseApis,
  })  : _authApis = authApis,
        _databaseApis = databaseApis,
        super(false);

  Future<void> addFeedback(
      BuildContext context,
      FeedbackModel feedback,
      ) async {
    state = true;
    final uid = _authApis.getCurrUser()?.uid ?? '';
    final updateFeedback = feedback.copyWith(userId: uid);
    final result = await _databaseApis.addFeedBack(feedBack: updateFeedback);

    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r){
      state = false;
      // showSnackBar(context, 'Thanks for your feedback');
      Navigator.of(context).pop();
    });
  }
}
