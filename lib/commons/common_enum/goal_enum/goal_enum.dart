enum GoalEnum {
  achieveTravelGoals('achieveTravelGoals'),
  receiveGreatDeals('receiveGreatDeals'),
  discoverNewPlaces('discoverNewPlaces'),
  stayInformedWithPlaceAlerts('stayInformedWithPlaceAlerts'),
  buildBucketLists('buildBucketLists'),
  planSpecialOccasions('planSpecialOccasions'),
  organizeDailyLife('organizeDailyLife');

  const GoalEnum(this.type);

  final String type;
}

// using an extension
// enhanced enums
extension ConvertGoalTypeEnum on String {
  GoalEnum toGoalEnum() {
    switch (this) {
      case 'achieveTravelGoals':
        return GoalEnum.achieveTravelGoals;
      case 'receiveGreatDeals':
        return GoalEnum.receiveGreatDeals;
      case 'discoverNewPlaces':
        return GoalEnum.discoverNewPlaces;
      case 'stayInformedWithPlaceAlerts':
        return GoalEnum.stayInformedWithPlaceAlerts;
      case 'buildBucketLists':
        return GoalEnum.buildBucketLists;
      case 'planSpecialOccasions':
        return GoalEnum.planSpecialOccasions;
      case 'organizeDailyLife':
        return GoalEnum.organizeDailyLife;
      default:
        return GoalEnum.organizeDailyLife;
    }
  }
}



  String toGoalEnum(GoalEnum goal) {
    switch (goal) {
      case GoalEnum.achieveTravelGoals:
        return 'Achieve Travel Goals';
      case GoalEnum.receiveGreatDeals:
        return 'Receive Great Deals';
      case GoalEnum.discoverNewPlaces:
        return 'Discover New Places';
      case GoalEnum.stayInformedWithPlaceAlerts:
        return 'Stay Informed With Place Alerts';
      case GoalEnum.buildBucketLists:
        return 'Build Bucket Lists';
      case GoalEnum.planSpecialOccasions:
        return 'Plan Special Occasions';
      case GoalEnum.organizeDailyLife:
        return 'Organize Daily Life';
      default:
        return 'Achieve Travel Goals';
    }
  }

