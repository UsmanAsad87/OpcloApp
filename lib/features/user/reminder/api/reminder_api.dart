import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../commons/common_imports/apis_commons.dart';
import '../../../../commons/common_providers/global_providers.dart';
import '../../../../core/constants/firebase_constants.dart';
import '../../../../models/reminder_model.dart';

final reminderDatabaseApiProvider = Provider<ReminderDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return ReminderDatabaseApi(firebase: firebase, auth: FirebaseAuth.instance);
});

class ReminderDatabaseApi {
  final FirebaseFirestore _firestore;
  final FirebaseAuth auth;

  ReminderDatabaseApi({required FirebaseFirestore firebase, required this.auth})
      : _firestore = firebase;

  FutureEitherVoid addReminder({required ReminderModel reminderModel}) async {
    try {
      CollectionReference reminderRef =
          _firestore.collection(FirebaseConstants.reminderCollection);
      await reminderRef.doc(reminderModel.id).set(reminderModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<ReminderModel>> getAllReminders() {
    try {
      CollectionReference reminderRef =
          _firestore.collection(FirebaseConstants.reminderCollection);
      return reminderRef
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return ReminderModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<ReminderModel> getReminderById({required String reminderId}) {
    try {
      final reminderRef = _firestore
          .collection(FirebaseConstants.reminderCollection)
          .doc(reminderId);

      return reminderRef.snapshots().map((docSnapshot) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return ReminderModel.fromMap(data);
      });
    } catch (error) {
      return Stream.empty();
    }
  }

}
