class WalletModel {
  String? walletAmount;
  List<Data>? data;
  int? status;

  WalletModel({this.walletAmount, this.data, this.status});

  WalletModel.fromJson(Map<String, dynamic> json) {
    walletAmount = json['wallet_amount'];
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
    data['wallet_amount'] = this.walletAmount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? transactionId;
  String? title;
  String? description;
  String? credit;
  String? debit;
  int? refrenceId;
  String? refrenceType;
  int? createUser;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.transactionId,
        this.title,
        this.description,
        this.credit,
        this.debit,
        this.refrenceId,
        this.refrenceType,
        this.createUser,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    transactionId = json['transaction_id'];
    title = json['title'];
    description = json['description'];
    credit = json['credit'];
    debit = json['debit'];
    refrenceId = json['refrence_id'];
    refrenceType = json['refrence_type'];
    createUser = json['create_user'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['transaction_id'] = this.transactionId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['credit'] = this.credit;
    data['debit'] = this.debit;
    data['refrence_id'] = this.refrenceId;
    data['refrence_type'] = this.refrenceType;
    data['create_user'] = this.createUser;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
