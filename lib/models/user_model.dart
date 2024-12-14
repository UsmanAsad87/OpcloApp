import 'package:opclo/commons/common_enum/account_type/account_type.dart';
import 'package:opclo/features/user/location/model/location_detail.dart';
import '../commons/common_enum/signup_type/signup_type.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileImage;
  final String userName;
  final AccountTypeEnum accountType;
  final LocationDetails? homeAddress;
  final LocationDetails? workAddress;
  final String notificationToken;
  final DateTime createdAt;
  final SignupTypeEnum signupTypeEnum;
  final String? subscriptionId;
  final String? subscriptionName;
  final bool? subscriptionIsValid;
  final bool? subscriptionApproved;
  final DateTime? subscriptionAdded;
  final DateTime? subscriptionExpire;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.accountType,
    required this.profileImage,
    required this.notificationToken,
    required this.userName,
    this.homeAddress,
    this.workAddress,
    required this.createdAt,
    required this.signupTypeEnum,
    this.subscriptionId,
    this.subscriptionName,
    this.subscriptionIsValid,
    this.subscriptionApproved,
    this.subscriptionAdded,
    this.subscriptionExpire,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          other.accountType == accountType &&
          profileImage == other.profileImage &&
          notificationToken == other.notificationToken &&
          userName == other.userName &&
          homeAddress == other.homeAddress &&
          createdAt == other.createdAt &&
          workAddress == other.homeAddress &&
          signupTypeEnum == other.signupTypeEnum &&
          subscriptionId == other.subscriptionId &&
          subscriptionName == other.subscriptionName &&
          subscriptionIsValid == other.subscriptionIsValid &&
          subscriptionApproved == other.subscriptionApproved &&
          subscriptionAdded == other.subscriptionAdded &&
          subscriptionExpire == other.subscriptionExpire);

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      accountType.hashCode ^
      profileImage.hashCode ^
      notificationToken.hashCode ^
      userName.hashCode ^
      homeAddress.hashCode ^
      createdAt.hashCode ^
      workAddress.hashCode ^
      signupTypeEnum.hashCode ^
      subscriptionId.hashCode ^
      subscriptionName.hashCode ^
      subscriptionIsValid.hashCode ^
      subscriptionApproved.hashCode ^
      subscriptionAdded.hashCode ^
      subscriptionExpire.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' uid: $uid,' +
        ' name: $name,' +
        ' email: $email,' +
        'accountType: $accountType' +
        ' profileImage: $profileImage,' +
        ' notificationToken: $notificationToken,' +
        ' userName: $userName,' +
        ' homeAddress: $homeAddress,' +
        ' workAddress: $workAddress,' +
        ' createdAt: $createdAt,' +
        ' signupTypeEnum: $signupTypeEnum,' +
        ' subscriptionId: $subscriptionId,' +
        ' subscriptionName: $subscriptionName,' +
        ' subscriptionIsValid: $subscriptionIsValid,' +
        ' subscriptionApproved: $subscriptionApproved,' +
        ' subscriptionAdded: $subscriptionAdded,' +
        ' subscriptionExpire: $subscriptionExpire,' +
        '}';
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    AccountTypeEnum? accountType,
    String? profileImage,
    DateTime? createdAt,
    String? notificationToken,
    String? userName,
    LocationDetails? homeAddress,
    LocationDetails? workAddress,
    SignupTypeEnum? signupTypeEnum,
    String? subscriptionId,
    String? subscriptionName,
    bool? subscriptionIsValid,
    bool? subscriptionApproved,
    DateTime? subscriptionAdded,
    DateTime? subscriptionExpire,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      accountType: accountType ?? this.accountType,
      profileImage: profileImage ?? this.profileImage,
      notificationToken: notificationToken ?? this.notificationToken,
      userName: userName ?? this.userName,
      homeAddress: homeAddress ?? this.homeAddress,
      workAddress: workAddress ?? workAddress ?? this.workAddress,
      createdAt: createdAt ?? this.createdAt,
      signupTypeEnum: signupTypeEnum ?? this.signupTypeEnum,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      subscriptionIsValid: subscriptionIsValid ?? this.subscriptionIsValid,
      subscriptionApproved: subscriptionApproved ?? this.subscriptionApproved,
      subscriptionAdded: subscriptionAdded ?? this.subscriptionAdded,
      subscriptionExpire: subscriptionExpire ?? this.subscriptionExpire,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'accountType': this.accountType.type,
      'profileImage': this.profileImage,
      'notificationToken': this.notificationToken,
      'userName': this.userName,
      'homeAddress': this.homeAddress?.toMap(),
      'workAddress': workAddress?.toMap(),
      'createdAt': this.createdAt.toIso8601String(),
      'signupTypeEnum': this.signupTypeEnum.type,
      'subscriptionId': this.subscriptionId,
      'subscriptionName': this.subscriptionName,
      'subscriptionIsValid': this.subscriptionIsValid,
      'subscriptionApproved': this.subscriptionApproved,
      'subscriptionAdded': this.subscriptionAdded?.toIso8601String(),
      'subscriptionExpire': this.subscriptionExpire?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name']  ?? '',
      email: map['email'] as String,
      accountType: map['accountType'] != null
          ? (map['accountType'] as String).toAccountTypeEnum()
          : AccountTypeEnum.user,
      profileImage: map['profileImage'] as String,
      notificationToken: map['notificationToken'] ?? '',
      userName: map['userName'] as String,
      homeAddress: map['homeAddress'] != null
          ? LocationDetails.fromFirebaseMap(map['homeAddress'])
          : null,
      workAddress: map['workAddress'] != null
          ? LocationDetails.fromFirebaseMap(map['workAddress'])
          : null,
      // homeAddress: map['homeAddress'] as String,
      // workAddress: map['workAddress'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      signupTypeEnum: (map['signupTypeEnum'] as String).toSignUpTypeEnum(),
      subscriptionId: map['subscriptionId'] as String?,
      subscriptionName: map['subscriptionName'] as String?,
      subscriptionIsValid: map['subscriptionIsValid'] as bool?,
      subscriptionApproved: map['subscriptionApproved'] as bool?,
      subscriptionAdded: map['subscriptionAdded'] != null
          ? DateTime.parse(map['subscriptionAdded'] as String).toLocal()
          : null,
      // New field added
      subscriptionExpire: map['subscriptionExpire'] != null
          ? DateTime.parse(map['subscriptionExpire'] as String).toLocal()
          : null, // New field added
    );
  }
}
