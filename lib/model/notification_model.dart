class NotificationModel {
  NotificationData? data;
  int? status;
  int? count;

  NotificationModel({this.data, this.status});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new NotificationData.fromJson(json['data']) : null;
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class NotificationData {
  Rows? rows;
  String? pageTitle;
  String? type;

  NotificationData({this.rows, this.pageTitle, this.type});

  NotificationData.fromJson(Map<String, dynamic> json) {
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
    pageTitle = json['page_title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['page_title'] = this.pageTitle;
    data['type'] = this.type;
    return data;
  }
}

class Rows {
  int? currentPage;
  List<RowData>? data;
  // String? firstPageUrl;
  // int? from;
  // int? lastPage;
  // String? lastPageUrl;
  // List<Links>? links;
  // Null? nextPageUrl;
  // String? path;
  // int? perPage;
  // Null? prevPageUrl;
  // int? to;
  // int? total;

  Rows(
      {this.currentPage,
        this.data,
        /*this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total*/});

  Rows.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <RowData>[];
      json['data'].forEach((v) {
        data!.add( RowData.fromJson(v));
      });
    }
    /*firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];*/
   /* if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    /*data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;*/
    return data;
  }
}

class RowData {
  int? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  NotificationRowData? data;
  int? forAdmin;
  dynamic readAt;
  String? createdAt;
  String? updatedAt;

  RowData(
      {this.id,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.data,
        this.forAdmin,
        this.readAt,
        this.createdAt,
        this.updatedAt});

  RowData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data = json['data'] != null ? new NotificationRowData.fromJson(json['data']) : null;
    forAdmin = json['for_admin'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiable_type'] = this.notifiableType;
    data['notifiable_id'] = this.notifiableId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['for_admin'] = this.forAdmin;
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class NotificationRowData {
  String? id;
  int? forAdmin;
  Notification? notification;

  NotificationRowData({this.id, this.forAdmin, this.notification});

  NotificationRowData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    forAdmin = json['for_admin'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['for_admin'] = this.forAdmin;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class Notification {
  String? event;
  String? to;
  int? id;
  String? name;
  String? avatar;
  String? link;
  String? type;
  String? message;

  Notification(
      {this.event,
        this.to,
        this.id,
        this.name,
        this.avatar,
        this.link,
        this.type,
        this.message});

  Notification.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    to = json['to'];
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    link = json['link'];
    type = json['type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    data['to'] = this.to;
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['link'] = this.link;
    data['type'] = this.type;
    data['message'] = this.message;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
