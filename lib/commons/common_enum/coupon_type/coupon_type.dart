enum CouponTypeEnum{
  online('Online'),
  instore('In-Store'),
  all('All');


  const CouponTypeEnum(this.type);
  final String type;
}

// using an extension
// enhanced enums
extension ConvertCouponTypeEnum on String{
  CouponTypeEnum toCouponTypeEnum(){
    switch(this){
      case 'Online':
        return CouponTypeEnum.online;
        case 'In-Store':
        return CouponTypeEnum.instore;
      case 'All':
        return CouponTypeEnum.all;
      default:
        return CouponTypeEnum.all;
    }
  }
}