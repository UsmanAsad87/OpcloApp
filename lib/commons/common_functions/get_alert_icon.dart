
import 'package:opclo/commons/common_enum/alert_type.dart';
import 'package:opclo/features/user/alert/controller/alert_notifier.dart';

import '../../utils/constants/assets_manager.dart';

String getAlertIcon(AlertTypeEnum type) {
  switch (type) {
    case AlertTypeEnum.incorrectHour:
      return AppAssets.clockImage;
    case AlertTypeEnum.driveThruClosed:
      return AppAssets.dineThruImage;
    case AlertTypeEnum.dineInClosed:
      return AppAssets.dineInImage;
    case AlertTypeEnum.womenOwned:
      return AppAssets.womenOwnedImage;
    case AlertTypeEnum.blackOwned:
      return AppAssets.blackOwnedImage;
    case AlertTypeEnum.maintenance:
      return AppAssets.maintenanceImage;
    case AlertTypeEnum.construction:
      return AppAssets.constructionImage;
    case AlertTypeEnum.movedLocation:
      return AppAssets.redLocationImage;
    case AlertTypeEnum.newAlert:
      return AppAssets.newAlertImage;
    case AlertTypeEnum.existingAlert:
      return AppAssets.alertImage;
      case AlertTypeEnum.cardForVaccine:
      return AppAssets.cardImage;
    case AlertTypeEnum.socialDistancing:
      return AppAssets.socialDistanceImage;
    default:
      return AppAssets.clockImage;
  }
}