enum AlertTypeEnum {
  incorrectHour('Incorrect Hour'),
  movedLocation('Moved Location'),
  dineInClosed('Dine-In Closed'),
  driveThruClosed('Drive-thru Closed'),
  blackOwned('Black Owned'),
  womenOwned('Women Owned'),
  newAlert('New Alert'),
  existingAlert('Existing Alert'),
  construction('Under construction'),
  cardForVaccine('Card for Vaccine'),
  socialDistancing('Social Distancing'),
  maintenance('Maintenance');

  const AlertTypeEnum(this.type);

  final String type;
}

// using an extension
// enhanced enums
extension ConvertAlertTypeEnum on String {
  AlertTypeEnum toAlertTypeEnum() {
    switch (this) {
      case 'Incorrect Hour':
        return AlertTypeEnum.incorrectHour;
      case 'Moved Location':
        return AlertTypeEnum.movedLocation;
      case 'Maintenance':
        return AlertTypeEnum.maintenance;
      case 'Under construction':
        return AlertTypeEnum.construction;
      case 'Dine-In Closed':
        return AlertTypeEnum.dineInClosed;
      case 'Drive-thru Closed':
        return AlertTypeEnum.driveThruClosed;
      case 'Black Owned':
        return AlertTypeEnum.blackOwned;
      case 'Women Owned':
        return AlertTypeEnum.womenOwned;
      case 'New Alert':
        return AlertTypeEnum.newAlert;
      case 'Existing Alert':
        return AlertTypeEnum.existingAlert;
      case 'Card for Vaccine':
        return AlertTypeEnum.cardForVaccine;
      case 'Social Distancing':
        return AlertTypeEnum.socialDistancing;
      default:
        return AlertTypeEnum.incorrectHour;
    }
  }
}
