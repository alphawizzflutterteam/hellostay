class HotelSearchResponse {
  int? total;
  int? totalPages;
  List<HotelDataList>? data;
  int? status;

  HotelSearchResponse({this.total, this.totalPages, this.data, this.status});

  HotelSearchResponse.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <HotelDataList>[];
      json['data'].forEach((v) {
        data!.add(HotelDataList.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['total_pages'] = totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class HotelDataList {
  int? id;
  String? objectModel;
  String? title;
  String? price;
 dynamic salePrice;
 dynamic discountPercent;
  String? image;
  String? content;
  Location? location;
  int? isFeatured;
  ReviewScore? reviewScore;

  HotelDataList(
      {this.id,
        this.objectModel,
        this.title,
        this.price,
        this.salePrice,
        this.discountPercent,
        this.image,
        this.content,
        this.location,
        this.isFeatured,
        this.reviewScore});

  HotelDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    objectModel = json['object_model'];
    title = json['title'];
    price = json['price'];
    salePrice = json['sale_price'];
    discountPercent = json['discount_percent'];
    image = json['image'];
    content = json['content'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    isFeatured = json['is_featured'];
    reviewScore = json['review_score'] != null
        ? ReviewScore.fromJson(json['review_score'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['object_model'] = objectModel;
    data['title'] = title;
    data['price'] = price;
    data['sale_price'] = salePrice;
    data['discount_percent'] = discountPercent;
    data['image'] = image;
    data['content'] = content;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['is_featured'] = isFeatured;
    if (reviewScore != null) {
      data['review_score'] = reviewScore!.toJson();
    }
    return data;
  }
}

class Location {
  int? id;
  String? name;

  Location({this.id, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ReviewScore {
  dynamic? scoreTotal;
  int? totalReview;
  String? reviewText;

  ReviewScore({this.scoreTotal, this.totalReview, this.reviewText});

  ReviewScore.fromJson(Map<String, dynamic> json) {
    scoreTotal = json['score_total'];
    totalReview = json['total_review'];
    reviewText = json['review_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score_total'] = scoreTotal;
    data['total_review'] = totalReview;
    data['review_text'] = reviewText;
    return data;
  }
}
