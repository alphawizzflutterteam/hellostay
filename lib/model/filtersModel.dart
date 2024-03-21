// To parse this JSON data, do
//
//     final filtersModel = filtersModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FiltersModel filtersModelFromJson(String str) =>
    FiltersModel.fromJson(json.decode(str));

String filtersModelToJson(FiltersModel data) => json.encode(data.toJson());

class FiltersModel {
  List<FiltersModelDatum> data;
  int status;

  FiltersModel({
    required this.data,
    required this.status,
  });

  factory FiltersModel.fromJson(Map<String, dynamic> json) => FiltersModel(
        data: List<FiltersModelDatum>.from(
            json["data"].map((x) => FiltersModelDatum.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
      };
}

class FiltersModelDatum {
  String title;
  String field;
  String position;
  String min;
  String max;
  List<TermElement> data;

  FiltersModelDatum({
    required this.title,
    required this.field,
    required this.position,
    required this.min,
    required this.max,
    required this.data,
  });

  factory FiltersModelDatum.fromJson(Map<String, dynamic> json) =>
      FiltersModelDatum(
        title: json["title"],
        field: json["field"],
        position: json["position"],
        min: json["min"],
        max: json["max"],
        data: List<TermElement>.from(
            json["data"].map((x) => TermElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "field": field,
        "position": position,
        "min": min,
        "max": max,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TermElement {
  int id;
  String name;
  String slug;
  List<TermElementInside> terms;

  TermElement({
    required this.id,
    required this.name,
    required this.slug,
    required this.terms,
  });

  factory TermElement.fromJson(Map<String, dynamic> json) => TermElement(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        terms: List<TermElementInside>.from(
            json["terms"].map((x) => TermElementInside.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
      };
}

class TermElementInside {
  int id;
  String name;
  String slug;

  TermElementInside({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory TermElementInside.fromJson(Map<String, dynamic> json) =>
      TermElementInside(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}
