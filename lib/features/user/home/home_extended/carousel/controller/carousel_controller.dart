import 'package:image_picker/image_picker.dart';

import '../../../../../../commons/common_functions/upload_image_to_firebase.dart';
import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/show_toast.dart';
import '../../../../../../core/constants/firebase_constants.dart';
import '../../../../../../models/crousel_model.dart';
import '../api/carousel_api.dart';


final carouselControllerProvider =
    StateNotifierProvider<CarouselsController, bool>((ref) {
  final carouselApi = ref.watch(createJobApisProvider);
  return CarouselsController(
    carouselApi: carouselApi,
  );
});

final fetchAllCarouselProvider = StreamProvider((
  ref,
) {
  final carouselCtr = ref.watch(carouselControllerProvider.notifier);
  return carouselCtr.getCarousel();
});

class CarouselsController extends StateNotifier<bool> {
  final CarouselApi _carouselApi;

  CarouselsController({
    required CarouselApi carouselApi,
  })  : _carouselApi = carouselApi,
        super(false);

  Stream<List<CarouselModel>> getCarousel() {
    return _carouselApi.getCarouselList();
  }

  Future<void> addCarousel(
      {
        required BuildContext context,
        required CarouselModel model,
        String? profileImage}) async {
    state = true;
    CarouselModel? updatedModel;
    if (profileImage != null) {
      String imageUrl = await uploadXImage(XFile(profileImage),
          storageFolderName: FirebaseConstants.carouselStorage);
      updatedModel = model.copyWith(image: imageUrl);
    }

    final result =
        await _carouselApi.addCarousel(carouselModel: updatedModel ?? model);
    result.fold((l) {
      state = false;
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      showToast(msg: l.message);
    }, (r) {
      state = false;
      showToast(msg: 'carousel item added Successfully!');
      Navigator.of(context).pop();
    });
    state = false;
  }
}
