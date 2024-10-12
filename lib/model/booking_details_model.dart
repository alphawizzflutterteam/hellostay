class BookingDetailsmodel {
  Booking? booking;
  Service? service;
  Gateway? gateway;
  int? status;

  BookingDetailsmodel({this.booking, this.service, this.gateway, this.status});

  BookingDetailsmodel.fromJson(Map<String, dynamic> json) {
    booking =
        json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    service =
        json['service'] != null ? new Service.fromJson(json['service']) : null;
    gateway =
        json['gateway'] != null ? new Gateway.fromJson(json['gateway']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.gateway != null) {
      data['gateway'] = this.gateway!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Booking {
  int? id;
  String? code;
  int? vendorId;
  int? customerId;
  dynamic paymentId;
  String? gateway;
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
  String? commission;
  String? commissionType;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? address2;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  dynamic customerNotes;
  String? vendorServiceFeeAmount;
  String? vendorServiceFee;
  int? createUser;
  int? updateUser;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? buyerFees;
  String? totalBeforeFees;
  dynamic paidVendor;
  dynamic objectChildId;
  dynamic number;
  dynamic paid;
  String? payNow;
  String? cancelReason;
  dynamic? walletCreditUsed;
  dynamic? walletTotalUsed;
  dynamic walletTransactionId;
  dynamic isRefundWallet;
  dynamic isPaid;
  String? totalBeforeDiscount;
  String? couponAmount;
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
      this.cancelReason,
      this.walletCreditUsed,
      this.walletTotalUsed,
      this.walletTransactionId,
      this.isRefundWallet,
      this.isPaid,
      this.totalBeforeDiscount,
      this.couponAmount,
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
    commission = json['commission'].toString();
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
    cancelReason = json['cancel_reason'];
    walletCreditUsed = json['wallet_credit_used'];
    walletTotalUsed = json['wallet_total_used'];
    walletTransactionId = json['wallet_transaction_id'];
    isRefundWallet = json['is_refund_wallet'];
    isPaid = json['is_paid'];
    totalBeforeDiscount = json['total_before_discount'];
    couponAmount = json['coupon_amount'];
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
    data['cancel_reason'] = this.cancelReason;
    data['wallet_credit_used'] = this.walletCreditUsed;
    data['wallet_total_used'] = this.walletTotalUsed;
    data['wallet_transaction_id'] = this.walletTransactionId;
    data['is_refund_wallet'] = this.isRefundWallet;
    data['is_paid'] = this.isPaid;
    data['total_before_discount'] = this.totalBeforeDiscount;
    data['coupon_amount'] = this.couponAmount;
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
  dynamic allowFullDay;
  dynamic salePrice;
  String? status;
  int? createUser;
  int? updateUser;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? reviewScore;
  dynamic icalImportUrl;
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

class Gateway {
  String? name;
  bool? isOffline;

  Gateway({this.name, this.isOffline});

  Gateway.fromJson(Map<String, dynamic> json) {
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
