import 'package:flutter/material.dart';
import 'package:pluis_hv_app/commons/values.dart';

class HomePageDataModel {}

class SlidesInfo {
  final String id;
  final String gender_id;
  final String image_full;
  final String image_media;
  final String image_small;
  final String description;
  final String text_color;

  SlidesInfo(
      {this.id, this.gender_id, this.image_full,this.image_media,this.image_small, this.description, this.text_color});

  factory SlidesInfo.fromJson(Map<String, dynamic> json) => SlidesInfo(
      id: json['id'],
      gender_id: json['gender_id'],
      image_full: WEB_SLIDES_IMAGES + json['image_full'],
      image_media: WEB_SLIDES_IMAGES + json['image_media'],
      image_small: WEB_SLIDES_IMAGES + json['image_small'],
      description: json['description'],
      text_color: json['text_color']);
}

class GenresInfo {
  final String id;
  final String title;
  final String gender_id;
  final String visibility;
  final String created_at;

  GenresInfo(
      {this.title, this.gender_id, this.visibility, this.created_at, this.id});

  factory GenresInfo.fromJson(Map<String, dynamic> json) => GenresInfo(
      id: json['id'],
      title: json['title'],
      gender_id: json['gender_id'],
      visibility: json['visibility'],
      created_at: json['created_at']);
}
