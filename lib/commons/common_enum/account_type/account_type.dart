enum AccountTypeEnum {
  user('user'),
  admin('admin');

  const AccountTypeEnum(this.type);

  final String type;
}

// using an extension
// enhanced enums
extension ConvertAccountType on String {
  AccountTypeEnum toAccountTypeEnum() {
    switch (this) {
      case 'user':
        return AccountTypeEnum.user;
      case 'admin':
        return AccountTypeEnum.admin;

      default:
        return AccountTypeEnum.user;
    }
  }
}
