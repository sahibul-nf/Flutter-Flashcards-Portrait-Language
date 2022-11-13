import 'glossry.dart';
import 'slide.dart';
import 'package:collection/collection.dart';

class Category {
  final String categoryName;
  final String flashCardMaker;
  final String explanation;
  final List<Slide> slides;
  final List<Glossry> glossries;

  Category({
    required this.slides,
    required this.explanation,
    required this.categoryName,
    required this.flashCardMaker,
    required this.glossries,
  });

  Category.fromJson(Map<String, dynamic> json)
      : categoryName = json["categoryName"] ?? "",
        flashCardMaker = json["FlashCardMaker"] ?? "",
        explanation = json["explanation"] ?? "",
        slides = json['slides'] != null
            ? List<Slide>.from(json['slides'].map((e) => Slide.fromJson(e)))
            : [],
        glossries = json['glossries'] != null
            ? List<Glossry>.from(
                json['glossries'].map((e) => Glossry.fromJson(e)))
            : [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['FlashCardMaker'] = flashCardMaker;
    data['explanation'] = explanation;
    data['slides'] = List<dynamic>.from(slides.map((slide) => slide.toJson()));
    data['glossries'] =
        List<dynamic>.from(glossries.map((glossry) => glossry.toJson()));
    return data;
  }

  @override
  operator ==(o) =>
      o is Category &&
      o.categoryName == categoryName &&
      o.flashCardMaker == flashCardMaker &&
      const DeepCollectionEquality.unordered().equals(o.slides, slides) &&
      const DeepCollectionEquality.unordered().equals(o.glossries, glossries);

  @override
  int get hashCode => Object.hash(categoryName, flashCardMaker, explanation,
      Object.hashAll(slides), Object.hashAll(glossries));
}
