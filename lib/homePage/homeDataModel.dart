import 'package:flutter/material.dart';

class HomePageDataModel {}

class SlidesInfo {
  final String id;
  final String gender_id;
  final String image;
  final String description;
  final String text_color;

  SlidesInfo(
      {this.id, this.gender_id, this.image, this.description, this.text_color});

  factory SlidesInfo.fromJson(Map<String, dynamic> json) => SlidesInfo(
      id: json['id'],
      gender_id: json['gender_id'],
      image: json['image'],
      description: json['description'],
      text_color: json['text_color']);
}

class GenresInfo {
  final String id;

  GenresInfo({this.id});

  factory GenresInfo.fromJson(Map<String, dynamic> json) => GenresInfo(
    id: json['id']
  );


}
