// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter_flashcards_portrait/models/tags.dart';

import 'glossry.dart';
import 'slide.dart';

class Category extends Equatable {
  String categoryName;
  String flashCardMaker;
  String explanation;
  List<Slide> slides;
  List<Tags> tags;
  List<Glossry> glossries;

  Category(
      {required this.slides,
      required this.explanation,
      required this.categoryName,
      required this.flashCardMaker,
      required this.glossries,
      required this.tags});

  Category.fromJson(Map<String, dynamic> json)
      : categoryName = json["categoryName"] ?? "",
        flashCardMaker = json["FlashCardMaker"] ?? "",
        explanation = json["explanation"] ?? "",
        slides = json['slides'] != null
            ? List<Slide>.from(json['slides'].map((e) => Slide.fromJson(e)))
            : [],
        tags = json['tags'] == null
            ? []
            : List<Tags>.from(json['tags'].map((e) => Tags.fromJson(e))),
        glossries = json['glossries'] != null
            ? List<Glossry>.from(
                json['glossries'].map((e) => Glossry.fromJson(e)))
            : [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['FlashCardMaker'] = flashCardMaker;
    data['explanation'] = explanation;
    data["tags"] = List<dynamic>.from(tags.map((tag) => tag.toJson()));
    data['slides'] = List<dynamic>.from(slides.map((slide) => slide.toJson()));
    data['glossries'] =
        List<dynamic>.from(glossries.map((glossry) => glossry.toJson()));
    return data;
  }

  @override
  List<Object> get props =>
      [categoryName, flashCardMaker, explanation, slides, glossries];
}
