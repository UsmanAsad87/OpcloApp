enum OccasionTypeEnum{
  holidays('Holidays'),
  birthdays('BirthDays'),
  anniversaries('Anniversaries'),
  weddings('Weddings'),
  graduations('Graduations');

  const OccasionTypeEnum(this.type);
  final String type;
}

extension ConvertOccasionType on String {
  OccasionTypeEnum toOccasionTypeEnum() {
    switch (this) {
      case 'Holidays':
        return OccasionTypeEnum.holidays;
      case 'BirthDays':
        return OccasionTypeEnum.birthdays;
      case 'Anniversaries':
        return OccasionTypeEnum.anniversaries;
      case 'Weddings':
        return OccasionTypeEnum.weddings;
      case 'Graduations':
        return OccasionTypeEnum.graduations;
      default:
        return OccasionTypeEnum.holidays;
    }
  }
}
