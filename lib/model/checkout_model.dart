class CheckoutModel {
  String? pageTitle;
  Booking? booking;
  Service? service;
  Gateways? gateways;
  User? user;
  bool? isApi;
  List<Coupans>? coupans;

  CheckoutModel(
      {this.pageTitle,
        this.booking,
        this.service,
        this.gateways,
        this.user,
        this.isApi,
        this.coupans});

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    pageTitle = json['page_title'];
    booking =
    json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    service =
    json['service'] != null ? new Service.fromJson(json['service']) : null;
    gateways = json['gateways'] != null
        ? new Gateways.fromJson(json['gateways'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isApi = json['is_api'];
    if (json['coupans'] != null) {
      coupans = <Coupans>[];
      json['coupans'].forEach((v) {
        coupans!.add(new Coupans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_title'] = this.pageTitle;
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.gateways != null) {
      data['gateways'] = this.gateways!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['is_api'] = this.isApi;
    if (this.coupans != null) {
      data['coupans'] = this.coupans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  int? id;
  String? code;
  int? vendorId;
  int? customerId;
  dynamic paymentId;
  dynamic gateway;
  int? objectId;
  String? objectModel;
  String? startDate;
  String? endDate;
  String? total;
  int? totalGuests;
  dynamic currency;
  String? status;
  dynamic deposit;
  dynamic depositType;
  int? commission;
  String? commissionType;
  dynamic email;
  dynamic firstName;
  dynamic lastName;
  dynamic phone;
  dynamic address;
  dynamic address2;
  dynamic city;
  dynamic state;
  dynamic zipCode;
  dynamic country;
  dynamic customerNotes;
  String? vendorServiceFeeAmount;
  String? vendorServiceFee;
  int? createUser;
  dynamic updateUser;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? buyerFees;
  String? totalBeforeFees;
  dynamic paidVendor;
  dynamic objectChildId;
  dynamic number;
  dynamic paid;
  dynamic payNow;
  dynamic walletCreditUsed;
  dynamic walletTotalUsed;
  dynamic walletTransactionId;
  dynamic isRefundWallet;
  dynamic isPaid;
  String? totalBeforeDiscount;
  String? couponAmount;
  dynamic cancelReason;
  String? roomData;
  Service? service;

  Booking(
      {this.id,
        this.code,
        this.vendorId,
        this.customerId,
        this.paymentId,
        this.gateway,
        this.objectId,
        this.objectModel,
        this.startDate,
        this.endDate,
        this.total,
        this.totalGuests,
        this.currency,
        this.status,
        this.deposit,
        this.depositType,
        this.commission,
        this.commissionType,
        this.email,
        this.firstName,
        this.lastName,
        this.phone,
        this.address,
        this.address2,
        this.city,
        this.state,
        this.zipCode,
        this.country,
        this.customerNotes,
        this.vendorServiceFeeAmount,
        this.vendorServiceFee,
        this.createUser,
        this.updateUser,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.buyerFees,
        this.totalBeforeFees,
        this.paidVendor,
        this.objectChildId,
        this.number,
        this.paid,
        this.payNow,
        this.walletCreditUsed,
        this.walletTotalUsed,
        this.walletTransactionId,
        this.isRefundWallet,
        this.isPaid,
        this.totalBeforeDiscount,
        this.couponAmount,
        this.cancelReason,
        this.roomData,
        this.service});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    vendorId = json['vendor_id'];
    customerId = json['customer_id'];
    paymentId = json['payment_id'];
    gateway = json['gateway'];
    objectId = json['object_id'];
    objectModel = json['object_model'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    total = json['total'];
    totalGuests = json['total_guests'];
    currency = json['currency'];
    status = json['status'];
    deposit = json['deposit'];
    depositType = json['deposit_type'];
    commission = json['commission'];
    commissionType = json['commission_type'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    address = json['address'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    country = json['country'];
    customerNotes = json['customer_notes'];
    vendorServiceFeeAmount = json['vendor_service_fee_amount'];
    vendorServiceFee = json['vendor_service_fee'];
    createUser = json['create_user'];
    updateUser = json['update_user'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    buyerFees = json['buyer_fees'];
    totalBeforeFees = json['total_before_fees'];
    paidVendor = json['paid_vendor'];
    objectChildId = json['object_child_id'];
    number = json['number'];
    paid = json['paid'];
    payNow = json['pay_now'];
    walletCreditUsed = json['wallet_credit_used'];
    walletTotalUsed = json['wallet_total_used'];
    walletTransactionId = json['wallet_transaction_id'];
    isRefundWallet = json['is_refund_wallet'];
    isPaid = json['is_paid'];
    totalBeforeDiscount = json['total_before_discount'];
    couponAmount = json['coupon_amount'];
    cancelReason = json['cancel_reason'];
    roomData = json['room_data'];
    service =
    json['service'] != null ? new Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['vendor_id'] = this.vendorId;
    data['customer_id'] = this.customerId;
    data['payment_id'] = this.paymentId;
    data['gateway'] = this.gateway;
    data['object_id'] = this.objectId;
    data['object_model'] = this.objectModel;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total'] = this.total;
    data['total_guests'] = this.totalGuests;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['deposit'] = this.deposit;
    data['deposit_type'] = this.depositType;
    data['commission'] = this.commission;
    data['commission_type'] = this.commissionType;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip_code'] = this.zipCode;
    data['country'] = this.country;
    data['customer_notes'] = this.customerNotes;
    data['vendor_service_fee_amount'] = this.vendorServiceFeeAmount;
    data['vendor_service_fee'] = this.vendorServiceFee;
    data['create_user'] = this.createUser;
    data['update_user'] = this.updateUser;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['buyer_fees'] = this.buyerFees;
    data['total_before_fees'] = this.totalBeforeFees;
    data['paid_vendor'] = this.paidVendor;
    data['object_child_id'] = this.objectChildId;
    data['number'] = this.number;
    data['paid'] = this.paid;
    data['pay_now'] = this.payNow;
    data['wallet_credit_used'] = this.walletCreditUsed;
    data['wallet_total_used'] = this.walletTotalUsed;
    data['wallet_transaction_id'] = this.walletTransactionId;
    data['is_refund_wallet'] = this.isRefundWallet;
    data['is_paid'] = this.isPaid;
    data['total_before_discount'] = this.totalBeforeDiscount;
    data['coupon_amount'] = this.couponAmount;
    data['cancel_reason'] = this.cancelReason;
    data['room_data'] = this.roomData;
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  int? id;
  String? title;
  String? slug;
  String? content;
  int? imageId;
  int? bannerImageId;
  int? locationId;
  String? address;
  String? mapLat;
  String? mapLng;
  int? mapZoom;
  int? isFeatured;
  String? gallery;
  String? video;
  List<Policy>? policy;
  int? starRate;
  String? price;
  String? checkInTime;
  String? checkOutTime;
  dynamic? allowFullDay;
  dynamic? salePrice;
  String? status;
  int? createUser;
  int? updateUser;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? reviewScore;
  dynamic? icalImportUrl;
  int? enableExtraPrice;
  List<ExtraPrice>? extraPrice;
  dynamic enableServiceFee;
  dynamic serviceFee;
  dynamic surrounding;
  dynamic badgeTags;
  int? authorId;
  dynamic minDayBeforeBooking;
  dynamic minDayStays;

  Service(
      {this.id,
        this.title,
        this.slug,
        this.content,
        this.imageId,
        this.bannerImageId,
        this.locationId,
        this.address,
        this.mapLat,
        this.mapLng,
        this.mapZoom,
        this.isFeatured,
        this.gallery,
        this.video,
        this.policy,
        this.starRate,
        this.price,
        this.checkInTime,
        this.checkOutTime,
        this.allowFullDay,
        this.salePrice,
        this.status,
        this.createUser,
        this.updateUser,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.reviewScore,
        this.icalImportUrl,
        this.enableExtraPrice,
        this.extraPrice,
        this.enableServiceFee,
        this.serviceFee,
        this.surrounding,
        this.badgeTags,
        this.authorId,
        this.minDayBeforeBooking,
        this.minDayStays});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    imageId = json['image_id'];
    bannerImageId = json['banner_image_id'];
    locationId = json['location_id'];
    address = json['address'];
    mapLat = json['map_lat'];
    mapLng = json['map_lng'];
    mapZoom = json['map_zoom'];
    isFeatured = json['is_featured'];
    gallery = json['gallery'];
    video = json['video'];
    if (json['policy'] != null) {
      policy = <Policy>[];
      json['policy'].forEach((v) {
        policy!.add(new Policy.fromJson(v));
      });
    }
    starRate = json['star_rate'];
    price = json['price'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    allowFullDay = json['allow_full_day'];
    salePrice = json['sale_price'];
    status = json['status'];
    createUser = json['create_user'];
    updateUser = json['update_user'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reviewScore = json['review_score'];
    icalImportUrl = json['ical_import_url'];
    enableExtraPrice = json['enable_extra_price'];
    if (json['extra_price'] != null) {
      extraPrice = <ExtraPrice>[];
      json['extra_price'].forEach((v) {
        extraPrice!.add(new ExtraPrice.fromJson(v));
      });
    }
    enableServiceFee = json['enable_service_fee'];
    serviceFee = json['service_fee'];
    surrounding = json['surrounding'];
    badgeTags = json['badge_tags'];
    authorId = json['author_id'];
    minDayBeforeBooking = json['min_day_before_booking'];
    minDayStays = json['min_day_stays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['content'] = this.content;
    data['image_id'] = this.imageId;
    data['banner_image_id'] = this.bannerImageId;
    data['location_id'] = this.locationId;
    data['address'] = this.address;
    data['map_lat'] = this.mapLat;
    data['map_lng'] = this.mapLng;
    data['map_zoom'] = this.mapZoom;
    data['is_featured'] = this.isFeatured;
    data['gallery'] = this.gallery;
    data['video'] = this.video;
    if (this.policy != null) {
      data['policy'] = this.policy!.map((v) => v.toJson()).toList();
    }
    data['star_rate'] = this.starRate;
    data['price'] = this.price;
    data['check_in_time'] = this.checkInTime;
    data['check_out_time'] = this.checkOutTime;
    data['allow_full_day'] = this.allowFullDay;
    data['sale_price'] = this.salePrice;
    data['status'] = this.status;
    data['create_user'] = this.createUser;
    data['update_user'] = this.updateUser;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['review_score'] = this.reviewScore;
    data['ical_import_url'] = this.icalImportUrl;
    data['enable_extra_price'] = this.enableExtraPrice;
    if (this.extraPrice != null) {
      data['extra_price'] = this.extraPrice!.map((v) => v.toJson()).toList();
    }
    data['enable_service_fee'] = this.enableServiceFee;
    data['service_fee'] = this.serviceFee;
    data['surrounding'] = this.surrounding;
    data['badge_tags'] = this.badgeTags;
    data['author_id'] = this.authorId;
    data['min_day_before_booking'] = this.minDayBeforeBooking;
    data['min_day_stays'] = this.minDayStays;
    return data;
  }
}

class Policy {
  String? title;
  String? content;

  Policy({this.title, this.content});

  Policy.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}

class ExtraPrice {
  String? name;
  String? price;
  String? type;

  ExtraPrice({this.name, this.price, this.type});

  ExtraPrice.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['type'] = this.type;
    return data;
  }
}

class Gateways {
  OfflinePayment? offlinePayment;

  Gateways({this.offlinePayment});

  Gateways.fromJson(Map<String, dynamic> json) {
    offlinePayment = json['offline_payment'] != null
        ? new OfflinePayment.fromJson(json['offline_payment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offlinePayment != null) {
      data['offline_payment'] = this.offlinePayment!.toJson();
    }
    return data;
  }
}

class OfflinePayment {
  String? name;
  bool? isOffline;

  OfflinePayment({this.name, this.isOffline});

  OfflinePayment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isOffline = json['is_offline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['is_offline'] = this.isOffline;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  dynamic businessName;
  String? email;
  String? emailVerifiedAt;
  dynamic twoFactorSecret;
  dynamic twoFactorRecoveryCodes;
  dynamic referralCode;
  dynamic referrer;
  dynamic otp;
  String? address;
  String? address2;
  String? phone;
  dynamic birthday;
  String? city;
  String? state;
  String? country;
  int? zipCode;
  dynamic lastLoginAt;
  dynamic avatarId;
  dynamic bio;
  String? status;
  dynamic reviewScore;
  dynamic createUser;
  dynamic updateUser;
  dynamic vendorCommissionAmount;
  dynamic vendorCommissionType;
  int? needUpdatePw;
  int? roleId;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  dynamic paymentGateway;
  dynamic totalGuests;
  dynamic locale;
  dynamic userName;
  dynamic verifySubmitStatus;
  dynamic isVerified;
  int? activeStatus;
  int? darkMode;
  String? messengerColor;
  dynamic stripeCustomerId;
  dynamic totalBeforeFees;
  String? walletAmount;

  User(
      {this.id,
        this.name,
        this.firstName,
        this.lastName,
        this.businessName,
        this.email,
        this.emailVerifiedAt,
        this.twoFactorSecret,
        this.twoFactorRecoveryCodes,
        this.referralCode,
        this.referrer,
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
        this.walletAmount});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    businessName = json['business_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    twoFactorSecret = json['two_factor_secret'];
    twoFactorRecoveryCodes = json['two_factor_recovery_codes'];
    referralCode = json['referral_code'];
    referrer = json['referrer'];
    otp = json['otp'];
    address = json['address'];
    address2 = json['address2'];
    phone = json['phone'];
    birthday = json['birthday'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zip_code'];
    lastLoginAt = json['last_login_at'];
    avatarId = json['avatar_id'];
    bio = json['bio'];
    status = json['status'];
    reviewScore = json['review_score'];
    createUser = json['create_user'];
    updateUser = json['update_user'];
    vendorCommissionAmount = json['vendor_commission_amount'];
    vendorCommissionType = json['vendor_commission_type'];
    needUpdatePw = json['need_update_pw'];
    roleId = json['role_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentGateway = json['payment_gateway'];
    totalGuests = json['total_guests'];
    locale = json['locale'];
    userName = json['user_name'];
    verifySubmitStatus = json['verify_submit_status'];
    isVerified = json['is_verified'];
    activeStatus = json['active_status'];
    darkMode = json['dark_mode'];
    messengerColor = json['messenger_color'];
    stripeCustomerId = json['stripe_customer_id'];
    totalBeforeFees = json['total_before_fees'];
    walletAmount = json['wallet_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['business_name'] = this.businessName;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['two_factor_secret'] = this.twoFactorSecret;
    data['two_factor_recovery_codes'] = this.twoFactorRecoveryCodes;
    data['referral_code'] = this.referralCode;
    data['referrer'] = this.referrer;
    data['otp'] = this.otp;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['phone'] = this.phone;
    data['birthday'] = this.birthday;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zip_code'] = this.zipCode;
    data['last_login_at'] = this.lastLoginAt;
    data['avatar_id'] = this.avatarId;
    data['bio'] = this.bio;
    data['status'] = this.status;
    data['review_score'] = this.reviewScore;
    data['create_user'] = this.createUser;
    data['update_user'] = this.updateUser;
    data['vendor_commission_amount'] = this.vendorCommissionAmount;
    data['vendor_commission_type'] = this.vendorCommissionType;
    data['need_update_pw'] = this.needUpdatePw;
    data['role_id'] = this.roleId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['payment_gateway'] = this.paymentGateway;
    data['total_guests'] = this.totalGuests;
    data['locale'] = this.locale;
    data['user_name'] = this.userName;
    data['verify_submit_status'] = this.verifySubmitStatus;
    data['is_verified'] = this.isVerified;
    data['active_status'] = this.activeStatus;
    data['dark_mode'] = this.darkMode;
    data['messenger_color'] = this.messengerColor;
    data['stripe_customer_id'] = this.stripeCustomerId;
    data['total_before_fees'] = this.totalBeforeFees;
    data['wallet_amount'] = this.walletAmount;
    return data;
  }
}

class Coupans {
  int? id;
  String? code;
  String? name;
  int? amount;
  String? discountType;
  String? endDate;
  int? minTotal;
  int? maxTotal;
 dynamic? services;
 dynamic? onlyForUser;
  String? status;
  int? quantityLimit;
  int? limitPerUser;
  int? imageId;
  int? createUser;
  int? updateUser;
  dynamic? deletedAt;
  String? createdAt;
  String? updatedAt;

  Coupans(
      {this.id,
        this.code,
        this.name,
        this.amount,
        this.discountType,
        this.endDate,
        this.minTotal,
        this.maxTotal,
        this.services,
        this.onlyForUser,
        this.status,
        this.quantityLimit,
        this.limitPerUser,
        this.imageId,
        this.createUser,
        this.updateUser,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Coupans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    amount = json['amount'];
    discountType = json['discount_type'];
    endDate = json['end_date'];
    minTotal = json['min_total'];
    maxTotal = json['max_total'];
    services = json['services'];
    onlyForUser = json['only_for_user'];
    status = json['status'];
    quantityLimit = json['quantity_limit'];
    limitPerUser = json['limit_per_user'];
    imageId = json['image_id'];
    createUser = json['create_user'];
    updateUser = json['update_user'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['discount_type'] = this.discountType;
    data['end_date'] = this.endDate;
    data['min_total'] = this.minTotal;
    data['max_total'] = this.maxTotal;
    data['services'] = this.services;
    data['only_for_user'] = this.onlyForUser;
    data['status'] = this.status;
    data['quantity_limit'] = this.quantityLimit;
    data['limit_per_user'] = this.limitPerUser;
    data['image_id'] = this.imageId;
    data['create_user'] = this.createUser;
    data['update_user'] = this.updateUser;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
