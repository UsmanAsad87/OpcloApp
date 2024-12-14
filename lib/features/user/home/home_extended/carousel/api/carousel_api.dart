import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_providers/global_providers.dart';
import '../../../../../../core/constants/firebase_constants.dart';
import '../../../../../../models/crousel_model.dart';

final createJobApisProvider = Provider<CarouselApi>((ref) {
  final fireStoreProvider = ref.watch(firebaseDatabaseProvider);
  return CarouselApi(fireStore: fireStoreProvider);
});

class CarouselApi {
  final FirebaseFirestore _fireStore;

  CarouselApi({required FirebaseFirestore fireStore}) : _fireStore = fireStore;

  Stream<List<CarouselModel>> getCarouselList() {
    return _fireStore
        .collection(FirebaseConstants.carouselCollection)
        .snapshots()
        .map((event) {
      List<CarouselModel> models = [];
      for (var document in event.docs) {
        var model = CarouselModel.fromMap(document.data());
        models.add(model);
      }
      return models;
    });
  }

  FutureEitherVoid addCarousel({
    required CarouselModel carouselModel,
  }) async {
    try {
      await _fireStore
          .collection(FirebaseConstants.carouselCollection)
          .doc(carouselModel.id)
          .set(carouselModel.toMap());

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase Error Occurred', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }
}
