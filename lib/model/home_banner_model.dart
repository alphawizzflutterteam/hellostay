class HomeBannerModel {
  List<Data>? data;
  int? uploaded;
  int? status;

  HomeBannerModel({this.data, this.uploaded, this.status});

  HomeBannerModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    uploaded = json['uploaded'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['uploaded'] = this.uploaded;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  bool? bActive;
  String? title;
  Null? desc;
  String? bgImage;

  Data({this.bActive, this.title, this.desc, this.bgImage});

  Data.fromJson(Map<String, dynamic> json) {
    bActive = json['_active'];
    title = json['title'];
    desc = json['desc'];
    bgImage = json['bg_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_active'] = this.bActive;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['bg_image'] = this.bgImage;
    return data;
  }
}
