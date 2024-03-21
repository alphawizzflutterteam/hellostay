class CouponModel {
  List<Data>? data;
  int? status;

  CouponModel({this.data, this.status});

  CouponModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
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
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
