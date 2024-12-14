enum SignupTypeEnum {
  google('google'),
  apple('apple'),
  phone('phone'),
  email('email');

  const SignupTypeEnum(this.type);

  final String type;
}

// using an extension
// enhanced enums
extension ConvertSignupTypeEnum on String {
  SignupTypeEnum toSignUpTypeEnum() {
    switch (this) {
      case 'google':
        return SignupTypeEnum.google;
      case 'apple':
        return SignupTypeEnum.apple;
      case 'email':
        return SignupTypeEnum.email;
      case 'phone':
        return SignupTypeEnum.phone;
      default:
        return SignupTypeEnum.phone;
    }
  }
}
