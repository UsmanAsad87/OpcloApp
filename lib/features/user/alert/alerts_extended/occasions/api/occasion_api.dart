import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opclo/commons/common_enum/occassion_type_enum/occasion_type_enum.dart';
import 'package:opclo/models/occasion_model.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_providers/global_providers.dart';
import '../../../../../../core/constants/firebase_constants.dart';

final occasionDatabaseApiProvider = Provider<OccasionDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return OccasionDatabaseApi(firebase: firebase);
});

class OccasionDatabaseApi {
  final FirebaseFirestore _firestore;

  OccasionDatabaseApi({required FirebaseFirestore firebase})
      : _firestore = firebase;

  FutureEitherVoid addOccasion({required OccasionModel occasionModel}) async {
    try {
      CollectionReference occasionRef = _firestore
      // .collection(FirebaseConstants.userCollection)
      // .doc(occasionModel.userId)
          .collection(FirebaseConstants.occasionCollection);
      await occasionRef.doc(occasionModel.id).set(occasionModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occur', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<OccasionModel>> getAllOccasion(
      {required String fsqId,
        required userId
      }) {
    try {
      CollectionReference noteRef = _firestore
      // .collection(FirebaseConstants.userCollection)
      // .doc(userId)
          .collection(FirebaseConstants.occasionCollection);

      return noteRef
          .where('fsqId', isEqualTo: fsqId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return OccasionModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  Stream<List<OccasionModel>> getOccasionByType(
      {required String fsqId,
        required OccasionTypeEnum type
      }) {
    try {
      CollectionReference noteRef = _firestore
      // .collection(FirebaseConstants.userCollection)
      // .doc(userId)
          .collection(FirebaseConstants.occasionCollection);

      return noteRef
          .where('fsqId', isEqualTo: fsqId)
          .where('occasionType', isEqualTo: type.type)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return OccasionModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }
}
