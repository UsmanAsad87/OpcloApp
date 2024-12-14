import '../../utils/constants/assets_manager.dart';

String getIcon(String title) {
  switch (title.toLowerCase()) {
    case 'birthdays':
      return AppAssets.birthDayImage;
    case 'weddings':
      return AppAssets.weddingImage;
    case 'anniversaries':
      return AppAssets.valentinesDayImage;
    case 'graduations':
      return AppAssets.graduationImage;
    case 'gift':
      return AppAssets.giftBoxImage;
    default:
      return AppAssets.giftBoxImage;
  }
}