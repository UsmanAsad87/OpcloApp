import '../../models/alert_model.dart';
import '../common_enum/alert_type.dart';

// bool isAlertExpired(AlertModel alert) {
//   switch (alert.option) {
//     case AlertTypeEnum.womenOwned:
//     case AlertTypeEnum.blackOwned:
//     case AlertTypeEnum.cardForVaccine:
//     case AlertTypeEnum.socialDistancing:
//       return false;
//     case AlertTypeEnum.incorrectHour:
//     case AlertTypeEnum.construction:
//       return DateTime.now().difference(alert.date) >= Duration(days: 30);
//     case AlertTypeEnum.movedLocation:
//       return DateTime.now().difference(alert.date) >= Duration(days: 60);
//     case AlertTypeEnum.maintenance:
//     case AlertTypeEnum.dineInClosed:
//     case AlertTypeEnum.driveThruClosed:
//       return DateTime.now().difference(alert.date) >= Duration(days: 7);
//     default:
//       return false;
//   }
// }