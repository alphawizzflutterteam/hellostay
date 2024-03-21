
class GetUserData {
  GetUserDataListModel data;
  int status;

  GetUserData({
    required this.data,
    required this.status,
  });

  factory GetUserData.fromJson(Map<String, dynamic> json) => GetUserData(
    data: GetUserDataListModel.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
  };
}

class GetUserDataListModel {
  int? id;
  String? name;
  String? firstName;
  String ?lastName;
  String? businessName;
  String? email;
  String ?emailVerifiedAt;
  String ?twoFactorSecret;
  String ?twoFactorRecoveryCodes;
  String? otp;
  String? address;
  String? address2;
  String? phone;
  String? birthday;
  String? city;
  String? state;
  String ?country;
  String? zipCode;
  String ?lastLoginAt;
  String? avatarId;
  String? bio;
  String? status;
  String? reviewScore;
  String? createUser;
  String? updateUser;
  String? vendorCommissionAmount;
  String? vendorCommissionType;
  String? needUpdatePw;
  String ?roleId;
  String? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? paymentGateway;
  String? totalGuests;
  String? locale;
  String ?userName;
  String ?verifySubmitStatus;
  String? isVerified;
  String? activeStatus;
  String? darkMode;
  String? messengerColor;
  String? stripeCustomerId;
  String? totalBeforeFees;
  String ?avatarUrl;
  String? avatarThumbUrl;
  String? referralCode;

  GetUserDataListModel({
     this.id,
    this.referralCode,
     this.name,
     this.firstName,
     this.lastName,
     this.businessName,
     this.email,
     this.emailVerifiedAt,
     this.twoFactorSecret,
     this.twoFactorRecoveryCodes,
     this.otp,
     this.address,
     this.address2,
     this.phone,
     this.birthday,
     this.city,
     this.state,
     this.country,
     this.zipCode,
     this.lastLoginAt,
     this.avatarId,
     this.bio,
     this.status,
     this.reviewScore,
     this.createUser,
     this.updateUser,
     this.vendorCommissionAmount,
     this.vendorCommissionType,
     this.needUpdatePw,
     this.roleId,
     this.deletedAt,
     this.createdAt,
     this.updatedAt,
     this.paymentGateway,
     this.totalGuests,
     this.locale,
     this.userName,
     this.verifySubmitStatus,
     this.isVerified,
     this.activeStatus,
     this.darkMode,
     this.messengerColor,
     this.stripeCustomerId,
     this.totalBeforeFees,
     this.avatarUrl,
     this.avatarThumbUrl,
  });

  factory GetUserDataListModel.fromJson(Map<String, dynamic> json) => GetUserDataListModel(
    id: json["id"]??"",
    referralCode: json["referral_code"]??"",

    name: json["name"]??"",
    firstName: json["first_name"]??"",
    lastName: json["last_name"]??"",
    businessName: json["business_name"]??"",
    email: json["email"]??"",
    emailVerifiedAt: json["email_verified_at"]??"",
    twoFactorSecret: json["two_factor_secret"]??"",
    twoFactorRecoveryCodes: json["two_factor_recovery_codes"]??"",
    otp: json["otp"]??"",
    address: json["address"]??"",
    address2: json["address2"]??"",
    phone: json["phone"]??"",
    birthday: json["birthday"]??"",
    city: json["city"]??"",
    state: json["state"]??"",
    country: json["country"]??"",
    zipCode: json["zip_code"].toString()??"",
    lastLoginAt: json["last_login_at"]??"",
    avatarId: json["avatar_id"].toString()??"",
    bio: json["bio"]??"",
    status: json["status"]??"",
    reviewScore: json["review_score"]??"",
    createUser: json["create_user"]??"",
    updateUser: json["update_user"]??"",
    vendorCommissionAmount: json["vendor_commission_amount"]??"",
    vendorCommissionType: json["vendor_commission_type"]??"",
    needUpdatePw: json["need_update_pw"].toString()??"",
    roleId: json["role_id"].toString()??"",
    deletedAt: json["deleted_at"]??"",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    paymentGateway: json["payment_gateway"]??"",
    totalGuests: json["total_guests"]??"",
    locale: json["locale"]??"",
    userName: json["user_name"] ?? "",
    verifySubmitStatus: json["verify_submit_status"]??"",
    isVerified: json["is_verified"]??"",
    activeStatus: json["active_status"].toString()??"",
    darkMode: json["dark_mode"].toString()??"",
    messengerColor: json["messenger_color"]??"",
    stripeCustomerId: json["stripe_customer_id"]??"",
    totalBeforeFees: json["total_before_fees"]??"",
    avatarUrl: json["avatar_url"]??"",
    avatarThumbUrl: json["avatar_thumb_url"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "business_name": businessName,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "two_factor_secret": twoFactorSecret,
    "two_factor_recovery_codes": twoFactorRecoveryCodes,
    "otp": otp,
    "address": address,
    "address2": address2,
    "phone": phone,
    "birthday": birthday,
    "city": city,
    "state": state,
    "country": country,
    "zip_code": zipCode,
    "last_login_at": lastLoginAt,
    "avatar_id": avatarId,
    "bio": bio,
    "status": status,
    "review_score": reviewScore,
    "create_user": createUser,
    "update_user": updateUser,
    "vendor_commission_amount": vendorCommissionAmount,
    "vendor_commission_type": vendorCommissionType,
    "need_update_pw": needUpdatePw,
    "role_id": roleId,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "payment_gateway": paymentGateway,
    "total_guests": totalGuests,
    "locale": locale,
    "user_name": userName,
    "verify_submit_status": verifySubmitStatus,
    "is_verified": isVerified,
    "active_status": activeStatus,
    "dark_mode": darkMode,
    "messenger_color": messengerColor,
    "stripe_customer_id": stripeCustomerId,
    "total_before_fees": totalBeforeFees,
    "avatar_url": avatarUrl,
    "avatar_thumb_url": avatarThumbUrl,
  };
}
