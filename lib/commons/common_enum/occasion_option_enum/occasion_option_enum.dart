enum OccasionOptionEnum {
  valentineDay('Valentine’s Day'),
  mothersDay('Mother’s Day'),
  fathersDay('Father’s Day'),
  halloween('Halloween'),
  forHim('For him'),
  forHer('For her'),
  himAndHer('For him & her'),
  christmas('Christmas');

  const OccasionOptionEnum(this.type);

  final String type;
}

extension ConvertOccasionoption on String {
  OccasionOptionEnum toOccasionOptionEnum() {
    switch (this) {
      case 'Valentine’s Day':
        return OccasionOptionEnum.valentineDay;
      case 'Mother’s Day':
        return OccasionOptionEnum.mothersDay;
      case 'Father’s Day':
        return OccasionOptionEnum.fathersDay;
      case 'Halloween':
        return OccasionOptionEnum.halloween;
      case 'Christmas':
        return OccasionOptionEnum.christmas;
      case 'For him':
        return OccasionOptionEnum.forHim;
      case 'For her':
        return OccasionOptionEnum.forHer;
      case 'For him & her':
        return OccasionOptionEnum.himAndHer;
      default:
        return OccasionOptionEnum.valentineDay;
    }
  }
}
