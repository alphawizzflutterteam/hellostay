/// data : [{"id":53,"code":"8028f149b4d2bc871c670bceefdc0c5f","vendor_id":5,"customer_id":6,"payment_id":null,"gateway":"offline_payment","object_id":10,"object_model":"hotel","start_date":"2024-02-10 00:00:00","end_date":"2024-02-15 00:00:00","total":"7650.00","total_guests":6,"currency":null,"status":"processing","deposit":null,"deposit_type":null,"commission":755,"commission_type":{"amount":"10","type":"percent"},"email":"admin@gmail.com","first_name":"admin@gmail.com","last_name":"Vjjjb","phone":"9338527410","address":"Jvvj","address2":"Gigi","city":"Khhk","state":"Vjkh","zip_code":"Jvgi","country":"DZ","customer_notes":"Iggigi","vendor_service_fee_amount":"0.00","vendor_service_fee":"","create_user":6,"update_user":6,"deleted_at":null,"created_at":"2024-02-06T11:50:12.000000Z","updated_at":"2024-02-06T12:00:39.000000Z","buyer_fees":[{"name":"Service fee","desc":"This helps us run our platform and offer services like 24/7 support on your trip.","price":"100","unit":"fixed","type":"one_time"}],"total_before_fees":"7550.00","paid_vendor":null,"object_child_id":null,"number":null,"paid":null,"pay_now":"7650.00","wallet_credit_used":0,"wallet_total_used":0,"wallet_transaction_id":null,"is_refund_wallet":null,"is_paid":null,"total_before_discount":"7550.00","coupon_amount":"0.00","service":{"title":"Dylan Hotel"},"booking_meta":{"duration":null,"base_price":550,"sale_price":null,"guests":6,"adults":4,"children":2,"extra_price":"[]","locale":"en","how_to_pay":""},"service_icon":"fa fa-building-o"}]
/// total : 1
/// max_pages : 1
/// status : 1

class BookingScreenModel {
  BookingScreenModel({
      List<BookingData>? data,
      num? total, 
      num? maxPages, 
      num? status,}){
    _data = data;
    _total = total;
    _maxPages = maxPages;
    _status = status;
}

  BookingScreenModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BookingData.fromJson(v));
      });
    }
    _total = json['total'];
    _maxPages = json['max_pages'];
    _status = json['status'];
  }
  List<BookingData>? _data;
  num? _total;
  num? _maxPages;
  num? _status;
BookingScreenModel copyWith({  List<BookingData>? data,
  num? total,
  num? maxPages,
  num? status,
}) => BookingScreenModel(  data: data ?? _data,
  total: total ?? _total,
  maxPages: maxPages ?? _maxPages,
  status: status ?? _status,
);
  List<BookingData>? get data => _data;
  num? get total => _total;
  num? get maxPages => _maxPages;
  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    map['max_pages'] = _maxPages;
    map['status'] = _status;
    return map;
  }

}

/// id : 53
/// code : "8028f149b4d2bc871c670bceefdc0c5f"
/// vendor_id : 5
/// customer_id : 6
/// payment_id : null
/// gateway : "offline_payment"
/// object_id : 10
/// object_model : "hotel"
/// start_date : "2024-02-10 00:00:00"
/// end_date : "2024-02-15 00:00:00"
/// total : "7650.00"
/// total_guests : 6
/// currency : null
/// status : "processing"
/// deposit : null
/// deposit_type : null
/// commission : 755
/// commission_type : {"amount":"10","type":"percent"}
/// email : "admin@gmail.com"
/// first_name : "admin@gmail.com"
/// last_name : "Vjjjb"
/// phone : "9338527410"
/// address : "Jvvj"
/// address2 : "Gigi"
/// city : "Khhk"
/// state : "Vjkh"
/// zip_code : "Jvgi"
/// country : "DZ"
/// customer_notes : "Iggigi"
/// vendor_service_fee_amount : "0.00"
/// vendor_service_fee : ""
/// create_user : 6
/// update_user : 6
/// deleted_at : null
/// created_at : "2024-02-06T11:50:12.000000Z"
/// updated_at : "2024-02-06T12:00:39.000000Z"
/// buyer_fees : [{"name":"Service fee","desc":"This helps us run our platform and offer services like 24/7 support on your trip.","price":"100","unit":"fixed","type":"one_time"}]
/// total_before_fees : "7550.00"
/// paid_vendor : null
/// object_child_id : null
/// number : null
/// paid : null
/// pay_now : "7650.00"
/// wallet_credit_used : 0
/// wallet_total_used : 0
/// wallet_transaction_id : null
/// is_refund_wallet : null
/// is_paid : null
/// total_before_discount : "7550.00"
/// coupon_amount : "0.00"
/// service : {"title":"Dylan Hotel"}
/// booking_meta : {"duration":null,"base_price":550,"sale_price":null,"guests":6,"adults":4,"children":2,"extra_price":"[]","locale":"en","how_to_pay":""}
/// service_icon : "fa fa-building-o"

class BookingData {
  BookingData({
      num? id, 
      String? code, 
      num? vendorId, 
      num? customerId, 
      dynamic paymentId, 
      String? gateway, 
      num? objectId, 
      String? objectModel, 
      String? startDate, 
      String? endDate, 
      String? total, 
      num? totalGuests, 
      dynamic currency, 
      String? status, 
      dynamic deposit, 
      dynamic depositType, 
      num? commission, 
      CommissionType? commissionType, 
      String? email, 
      String? firstName, 
      String? lastName, 
      String? phone, 
      String? address, 
      String? address2, 
      String? city, 
      String? state, 
      String? zipCode, 
      String? country, 
      String? customerNotes, 
      String? vendorServiceFeeAmount, 
      String? vendorServiceFee, 
      num? createUser, 
      num? updateUser, 
      dynamic deletedAt, 
      String? createdAt, 
      String? updatedAt, 
      List<BuyerFees>? buyerFees, 
      String? totalBeforeFees, 
      dynamic paidVendor, 
      dynamic objectChildId, 
      dynamic number, 
      dynamic paid, 
      String? payNow, 
      num? walletCreditUsed, 
      num? walletTotalUsed, 
      dynamic walletTransactionId, 
      dynamic isRefundWallet, 
      dynamic isPaid, 
      String? totalBeforeDiscount, 
      String? couponAmount, 
      Service? service, 
      BookingMeta? bookingMeta, 
      String? serviceIcon,}){
    _id = id;
    _code = code;
    _vendorId = vendorId;
    _customerId = customerId;
    _paymentId = paymentId;
    _gateway = gateway;
    _objectId = objectId;
    _objectModel = objectModel;
    _startDate = startDate;
    _endDate = endDate;
    _total = total;
    _totalGuests = totalGuests;
    _currency = currency;
    _status = status;
    _deposit = deposit;
    _depositType = depositType;
    _commission = commission;
    _commissionType = commissionType;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _address = address;
    _address2 = address2;
    _city = city;
    _state = state;
    _zipCode = zipCode;
    _country = country;
    _customerNotes = customerNotes;
    _vendorServiceFeeAmount = vendorServiceFeeAmount;
    _vendorServiceFee = vendorServiceFee;
    _createUser = createUser;
    _updateUser = updateUser;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _buyerFees = buyerFees;
    _totalBeforeFees = totalBeforeFees;
    _paidVendor = paidVendor;
    _objectChildId = objectChildId;
    _number = number;
    _paid = paid;
    _payNow = payNow;
    _walletCreditUsed = walletCreditUsed;
    _walletTotalUsed = walletTotalUsed;
    _walletTransactionId = walletTransactionId;
    _isRefundWallet = isRefundWallet;
    _isPaid = isPaid;
    _totalBeforeDiscount = totalBeforeDiscount;
    _couponAmount = couponAmount;
    _service = service;
    _bookingMeta = bookingMeta;
    _serviceIcon = serviceIcon;
}

  BookingData.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _vendorId = json['vendor_id'];
    _customerId = json['customer_id'];
    _paymentId = json['payment_id'];
    _gateway = json['gateway'];
    _objectId = json['object_id'];
    _objectModel = json['object_model'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _total = json['total'];
    _totalGuests = json['total_guests'];
    _currency = json['currency'];
    _status = json['status'];
    _deposit = json['deposit'];
    _depositType = json['deposit_type'];
    _commission = json['commission'];
    _commissionType = json['commission_type'] != null ? CommissionType.fromJson(json['commission_type']) : null;
    _email = json['email'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _phone = json['phone'];
    _address = json['address'];
    _address2 = json['address2'];
    _city = json['city'];
    _state = json['state'];
    _zipCode = json['zip_code'];
    _country = json['country'];
    _customerNotes = json['customer_notes'];
    _vendorServiceFeeAmount = json['vendor_service_fee_amount'];
    _vendorServiceFee = json['vendor_service_fee'];
    _createUser = json['create_user'];
    _updateUser = json['update_user'];
    _deletedAt = json['deleted_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['buyer_fees'] != null) {
      _buyerFees = [];
      json['buyer_fees'].forEach((v) {
        _buyerFees?.add(BuyerFees.fromJson(v));
      });
    }
    _totalBeforeFees = json['total_before_fees'];
    _paidVendor = json['paid_vendor'];
    _objectChildId = json['object_child_id'];
    _number = json['number'];
    _paid = json['paid'];
    _payNow = json['pay_now'];
    _walletCreditUsed = json['wallet_credit_used'];
    _walletTotalUsed = json['wallet_total_used'];
    _walletTransactionId = json['wallet_transaction_id'];
    _isRefundWallet = json['is_refund_wallet'];
    _isPaid = json['is_paid'];
    _totalBeforeDiscount = json['total_before_discount'];
    _couponAmount = json['coupon_amount'];
    _service = json['service'] != null ? Service.fromJson(json['service']) : null;
    _bookingMeta = json['booking_meta'] != null ? BookingMeta.fromJson(json['booking_meta']) : null;
    _serviceIcon = json['service_icon'];
  }
  num? _id;
  String? _code;
  num? _vendorId;
  num? _customerId;
  dynamic _paymentId;
  String? _gateway;
  num? _objectId;
  String? _objectModel;
  String? _startDate;
  String? _endDate;
  String? _total;
  num? _totalGuests;
  dynamic _currency;
  String? _status;
  dynamic _deposit;
  dynamic _depositType;
  num? _commission;
  CommissionType? _commissionType;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _address;
  String? _address2;
  String? _city;
  String? _state;
  String? _zipCode;
  String? _country;
  String? _customerNotes;
  String? _vendorServiceFeeAmount;
  String? _vendorServiceFee;
  num? _createUser;
  num? _updateUser;
  dynamic _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  List<BuyerFees>? _buyerFees;
  String? _totalBeforeFees;
  dynamic _paidVendor;
  dynamic _objectChildId;
  dynamic _number;
  dynamic _paid;
  String? _payNow;
  num? _walletCreditUsed;
  num? _walletTotalUsed;
  dynamic _walletTransactionId;
  dynamic _isRefundWallet;
  dynamic _isPaid;
  String? _totalBeforeDiscount;
  String? _couponAmount;
  Service? _service;
  BookingMeta? _bookingMeta;
  String? _serviceIcon;
BookingData copyWith({  num? id,
  String? code,
  num? vendorId,
  num? customerId,
  dynamic paymentId,
  String? gateway,
  num? objectId,
  String? objectModel,
  String? startDate,
  String? endDate,
  String? total,
  num? totalGuests,
  dynamic currency,
  String? status,
  dynamic deposit,
  dynamic depositType,
  num? commission,
  CommissionType? commissionType,
  String? email,
  String? firstName,
  String? lastName,
  String? phone,
  String? address,
  String? address2,
  String? city,
  String? state,
  String? zipCode,
  String? country,
  String? customerNotes,
  String? vendorServiceFeeAmount,
  String? vendorServiceFee,
  num? createUser,
  num? updateUser,
  dynamic deletedAt,
  String? createdAt,
  String? updatedAt,
  List<BuyerFees>? buyerFees,
  String? totalBeforeFees,
  dynamic paidVendor,
  dynamic objectChildId,
  dynamic number,
  dynamic paid,
  String? payNow,
  num? walletCreditUsed,
  num? walletTotalUsed,
  dynamic walletTransactionId,
  dynamic isRefundWallet,
  dynamic isPaid,
  String? totalBeforeDiscount,
  String? couponAmount,
  Service? service,
  BookingMeta? bookingMeta,
  String? serviceIcon,
}) => BookingData(  id: id ?? _id,
  code: code ?? _code,
  vendorId: vendorId ?? _vendorId,
  customerId: customerId ?? _customerId,
  paymentId: paymentId ?? _paymentId,
  gateway: gateway ?? _gateway,
  objectId: objectId ?? _objectId,
  objectModel: objectModel ?? _objectModel,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  total: total ?? _total,
  totalGuests: totalGuests ?? _totalGuests,
  currency: currency ?? _currency,
  status: status ?? _status,
  deposit: deposit ?? _deposit,
  depositType: depositType ?? _depositType,
  commission: commission ?? _commission,
  commissionType: commissionType ?? _commissionType,
  email: email ?? _email,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  phone: phone ?? _phone,
  address: address ?? _address,
  address2: address2 ?? _address2,
  city: city ?? _city,
  state: state ?? _state,
  zipCode: zipCode ?? _zipCode,
  country: country ?? _country,
  customerNotes: customerNotes ?? _customerNotes,
  vendorServiceFeeAmount: vendorServiceFeeAmount ?? _vendorServiceFeeAmount,
  vendorServiceFee: vendorServiceFee ?? _vendorServiceFee,
  createUser: createUser ?? _createUser,
  updateUser: updateUser ?? _updateUser,
  deletedAt: deletedAt ?? _deletedAt,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  buyerFees: buyerFees ?? _buyerFees,
  totalBeforeFees: totalBeforeFees ?? _totalBeforeFees,
  paidVendor: paidVendor ?? _paidVendor,
  objectChildId: objectChildId ?? _objectChildId,
  number: number ?? _number,
  paid: paid ?? _paid,
  payNow: payNow ?? _payNow,
  walletCreditUsed: walletCreditUsed ?? _walletCreditUsed,
  walletTotalUsed: walletTotalUsed ?? _walletTotalUsed,
  walletTransactionId: walletTransactionId ?? _walletTransactionId,
  isRefundWallet: isRefundWallet ?? _isRefundWallet,
  isPaid: isPaid ?? _isPaid,
  totalBeforeDiscount: totalBeforeDiscount ?? _totalBeforeDiscount,
  couponAmount: couponAmount ?? _couponAmount,
  service: service ?? _service,
  bookingMeta: bookingMeta ?? _bookingMeta,
  serviceIcon: serviceIcon ?? _serviceIcon,
);
  num? get id => _id;
  String? get code => _code;
  num? get vendorId => _vendorId;
  num? get customerId => _customerId;
  dynamic get paymentId => _paymentId;
  String? get gateway => _gateway;
  num? get objectId => _objectId;
  String? get objectModel => _objectModel;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get total => _total;
  num? get totalGuests => _totalGuests;
  dynamic get currency => _currency;
  String? get status => _status;
  dynamic get deposit => _deposit;
  dynamic get depositType => _depositType;
  num? get commission => _commission;
  CommissionType? get commissionType => _commissionType;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;
  String? get address => _address;
  String? get address2 => _address2;
  String? get city => _city;
  String? get state => _state;
  String? get zipCode => _zipCode;
  String? get country => _country;
  String? get customerNotes => _customerNotes;
  String? get vendorServiceFeeAmount => _vendorServiceFeeAmount;
  String? get vendorServiceFee => _vendorServiceFee;
  num? get createUser => _createUser;
  num? get updateUser => _updateUser;
  dynamic get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<BuyerFees>? get buyerFees => _buyerFees;
  String? get totalBeforeFees => _totalBeforeFees;
  dynamic get paidVendor => _paidVendor;
  dynamic get objectChildId => _objectChildId;
  dynamic get number => _number;
  dynamic get paid => _paid;
  String? get payNow => _payNow;
  num? get walletCreditUsed => _walletCreditUsed;
  num? get walletTotalUsed => _walletTotalUsed;
  dynamic get walletTransactionId => _walletTransactionId;
  dynamic get isRefundWallet => _isRefundWallet;
  dynamic get isPaid => _isPaid;
  String? get totalBeforeDiscount => _totalBeforeDiscount;
  String? get couponAmount => _couponAmount;
  Service? get service => _service;
  BookingMeta? get bookingMeta => _bookingMeta;
  String? get serviceIcon => _serviceIcon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['vendor_id'] = _vendorId;
    map['customer_id'] = _customerId;
    map['payment_id'] = _paymentId;
    map['gateway'] = _gateway;
    map['object_id'] = _objectId;
    map['object_model'] = _objectModel;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['total'] = _total;
    map['total_guests'] = _totalGuests;
    map['currency'] = _currency;
    map['status'] = _status;
    map['deposit'] = _deposit;
    map['deposit_type'] = _depositType;
    map['commission'] = _commission;
    if (_commissionType != null) {
      map['commission_type'] = _commissionType?.toJson();
    }
    map['email'] = _email;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['phone'] = _phone;
    map['address'] = _address;
    map['address2'] = _address2;
    map['city'] = _city;
    map['state'] = _state;
    map['zip_code'] = _zipCode;
    map['country'] = _country;
    map['customer_notes'] = _customerNotes;
    map['vendor_service_fee_amount'] = _vendorServiceFeeAmount;
    map['vendor_service_fee'] = _vendorServiceFee;
    map['create_user'] = _createUser;
    map['update_user'] = _updateUser;
    map['deleted_at'] = _deletedAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_buyerFees != null) {
      map['buyer_fees'] = _buyerFees?.map((v) => v.toJson()).toList();
    }
    map['total_before_fees'] = _totalBeforeFees;
    map['paid_vendor'] = _paidVendor;
    map['object_child_id'] = _objectChildId;
    map['number'] = _number;
    map['paid'] = _paid;
    map['pay_now'] = _payNow;
    map['wallet_credit_used'] = _walletCreditUsed;
    map['wallet_total_used'] = _walletTotalUsed;
    map['wallet_transaction_id'] = _walletTransactionId;
    map['is_refund_wallet'] = _isRefundWallet;
    map['is_paid'] = _isPaid;
    map['total_before_discount'] = _totalBeforeDiscount;
    map['coupon_amount'] = _couponAmount;
    if (_service != null) {
      map['service'] = _service?.toJson();
    }
    if (_bookingMeta != null) {
      map['booking_meta'] = _bookingMeta?.toJson();
    }
    map['service_icon'] = _serviceIcon;
    return map;
  }

}

/// duration : null
/// base_price : 550
/// sale_price : null
/// guests : 6
/// adults : 4
/// children : 2
/// extra_price : "[]"
/// locale : "en"
/// how_to_pay : ""

class BookingMeta {
  BookingMeta({
      dynamic duration, 
      num? basePrice, 
      dynamic salePrice,
    String? guests,
    String? adults,
    String? children,
      String? extraPrice, 
      String? locale, 
      String? howToPay,}){
    _duration = duration;
    _basePrice = basePrice;
    _salePrice = salePrice;
    _guests = guests;
    _adults = adults;
    _children = children;
    _extraPrice = extraPrice;
    _locale = locale;
    _howToPay = howToPay;
}

  BookingMeta.fromJson(dynamic json) {
    _duration = json['duration'];
    _basePrice = json['base_price'];
    _salePrice = json['sale_price'];
    _guests = json['guests'].toString();
    _adults = json['adults'].toString();
    _children = json['children'].toString();
    _extraPrice = json['extra_price'];
    _locale = json['locale'];
    _howToPay = json['how_to_pay'];
  }
  dynamic _duration;
  num? _basePrice;
  dynamic _salePrice;
  String? _guests;
  String? _adults;
  String? _children;
  String? _extraPrice;
  String? _locale;
  String? _howToPay;
BookingMeta copyWith({  dynamic duration,
  num? basePrice,
  dynamic salePrice,
  String? guests,
  String? adults,
  String? children,
  String? extraPrice,
  String? locale,
  String? howToPay,
}) => BookingMeta(  duration: duration ?? _duration,
  basePrice: basePrice ?? _basePrice,
  salePrice: salePrice ?? _salePrice,
  guests: guests ?? _guests,
  adults: adults ?? _adults,
  children: children ?? _children,
  extraPrice: extraPrice ?? _extraPrice,
  locale: locale ?? _locale,
  howToPay: howToPay ?? _howToPay,
);
  dynamic get duration => _duration;
  num? get basePrice => _basePrice;
  dynamic get salePrice => _salePrice;
  String? get guests => _guests;
  String? get adults => _adults;
  String? get children => _children;
  String? get extraPrice => _extraPrice;
  String? get locale => _locale;
  String? get howToPay => _howToPay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['duration'] = _duration;
    map['base_price'] = _basePrice;
    map['sale_price'] = _salePrice;
    map['guests'] = _guests;
    map['adults'] = _adults;
    map['children'] = _children;
    map['extra_price'] = _extraPrice;
    map['locale'] = _locale;
    map['how_to_pay'] = _howToPay;
    return map;
  }

}

/// title : "Dylan Hotel"

class Service {
  Service({
      String? title,}){
    _title = title;
}

  Service.fromJson(dynamic json) {
    _title = json['title'];
  }
  String? _title;
Service copyWith({  String? title,
}) => Service(  title: title ?? _title,
);
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    return map;
  }

}

/// name : "Service fee"
/// desc : "This helps us run our platform and offer services like 24/7 support on your trip."
/// price : "100"
/// unit : "fixed"
/// type : "one_time"

class BuyerFees {
  BuyerFees({
      String? name, 
      String? desc, 
      String? price, 
      String? unit, 
      String? type,}){
    _name = name;
    _desc = desc;
    _price = price;
    _unit = unit;
    _type = type;
}

  BuyerFees.fromJson(dynamic json) {
    _name = json['name'];
    _desc = json['desc'];
    _price = json['price'];
    _unit = json['unit'];
    _type = json['type'];
  }
  String? _name;
  String? _desc;
  dynamic? _price;
  String? _unit;
  String? _type;
BuyerFees copyWith({  String? name,
  String? desc,
  String? price,
  String? unit,
  String? type,
}) => BuyerFees(  name: name ?? _name,
  desc: desc ?? _desc,
  price: price ?? _price,
  unit: unit ?? _unit,
  type: type ?? _type,
);
  String? get name => _name;
  String? get desc => _desc;
  dynamic? get price => _price;
  String? get unit => _unit;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['desc'] = _desc;
    map['price'] = _price;
    map['unit'] = _unit;
    map['type'] = _type;
    return map;
  }

}

/// amount : "10"
/// type : "percent"

class CommissionType {
  CommissionType({
      String? amount, 
      String? type,}){
    _amount = amount;
    _type = type;
}

  CommissionType.fromJson(dynamic json) {
    _amount = json['amount'];
    _type = json['type'];
  }
  dynamic? _amount;
  String? _type;
CommissionType copyWith({  String? amount,
  String? type,
}) => CommissionType(  amount: amount ?? _amount,
  type: type ?? _type,
);
  String? get amount => _amount;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = _amount;
    map['type'] = _type;
    return map;
  }

}