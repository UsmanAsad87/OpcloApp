class SubscriptionConstants {
  static String opcloFree = 'opclo_free';
  static String opcloMonthly = 'opclo_monthly';
  static String opcloYearly= 'opclo_yearly';
  static String opcloFreeName = 'Free plan';
  static String opcloMonthlyName = 'Most Popular';
  static String opcloYearlyName= 'Best Value';


  static  List<String> consumableIds = <String>[
  ];
  static List<String> nonConsumableIds = <String>[
    opcloMonthly,
    opcloYearly
  ];
  static  List<String> productIds = [...consumableIds, ...nonConsumableIds];

}
