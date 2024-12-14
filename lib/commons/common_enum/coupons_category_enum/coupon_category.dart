enum CouponCategory {
  diningAndTakeout('Dining & Takeout'),
  healthAndFitness('Health & Fitness'),
  travel('Travel'),
  sports('sports'),
  clothing('Clothing'),
  outdoors('Outdoors'),
  makeupAndSkincare('Makeup & Skincare'),
  babyAndKids('Baby & Kids'),
  electronics('Electronics'),
  toysAndGames('Toys & Games'),
  homeAndGarden('Home & Garden'),
  petSupplies('Pet Supplies'),
  furnitureAndDecor('Furniture & Decor'),
  carRental('Car Rental'),
  bedAndBath('Bed & Bath'),
  autoServices('Auto Services');

  const CouponCategory(this.type);
  final String type;
}

extension ConvertCouponCategory on String {
  CouponCategory toCouponCategoryEnum() {
    switch (this.toLowerCase()) {
      case 'dining & takeout':
        return CouponCategory.diningAndTakeout;
      case 'health & fitness':
        return CouponCategory.healthAndFitness;
      case 'travel':
        return CouponCategory.travel;
      case 'sports':
        return CouponCategory.sports;
      case 'clothing':
        return CouponCategory.clothing;
      case 'outdoors':
        return CouponCategory.outdoors;
      case 'makeup & skincare':
        return CouponCategory.makeupAndSkincare;
      case 'baby & kids':
        return CouponCategory.babyAndKids;
      case 'electronics':
        return CouponCategory.electronics;
      case 'toys & games':
        return CouponCategory.toysAndGames;
      case 'home & garden':
        return CouponCategory.homeAndGarden;
      case 'pet supplies':
        return CouponCategory.petSupplies;
      case 'furniture & decor':
        return CouponCategory.furnitureAndDecor;
      case 'car rental':
        return CouponCategory.carRental;
      case 'bed & bath':
        return CouponCategory.bedAndBath;
      case 'auto services':
        return CouponCategory.autoServices;
      default:
        return CouponCategory.diningAndTakeout;
    }
  }
}