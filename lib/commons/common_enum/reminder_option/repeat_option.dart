enum RepeatOption {
  None,
  Daily,
  Weekends,
  Weekly,
  Monthly,
  Yearly,
}

List<String> repeatOptions = [
  'None',
  'Daily',
  'Weekends',
  'Weekly',
  'Monthly',
  'Yearly',
];

extension RepeatOptionExtension on RepeatOption {
  String get stringValue {
    switch (this) {
      case RepeatOption.None:
        return 'None';
      case RepeatOption.Daily:
        return 'Daily';
      case RepeatOption.Weekends:
        return 'Weekends';
      case RepeatOption.Weekly:
        return 'Weekly';
      case RepeatOption.Monthly:
        return 'Monthly';
      case RepeatOption.Yearly:
        return 'Yearly';
    }
  }
}

RepeatOption repeatOptionFromString(String value) {
  switch (value) {
    case 'None':
      return RepeatOption.None;
    case 'Daily':
      return RepeatOption.Daily;
    case 'Weekends':
      return RepeatOption.Weekends;
    case 'Weekly':
      return RepeatOption.Weekly;
    case 'Monthly':
      return RepeatOption.Monthly;
    case 'Yearly':
      return RepeatOption.Yearly;
    default:
      throw ArgumentError('Invalid repeat option: $value');
  }
}