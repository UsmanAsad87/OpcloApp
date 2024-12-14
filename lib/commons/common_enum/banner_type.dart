enum BannerTypeEnum {
  home('home'),
  explore('explore');

  const BannerTypeEnum(this.type);

  final String type;
}

// using an extension
// enhanced enums
extension ConvertBannerTypeEnum on String {
  BannerTypeEnum toBannerTypeEnum() {
    switch (this) {
      case 'home':
        return BannerTypeEnum.home;
      case 'explore':
        return BannerTypeEnum.explore;
      default:
        return BannerTypeEnum.home;
    }
  }
}
