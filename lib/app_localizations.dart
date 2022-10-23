import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flashcards_portrait/models/category.dart';
import 'package:flutter_flashcards_portrait/models/tags.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;
  late List<Category> categories;
  late List<Tags> tags;
  late List<String> activeLanguages;
  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('lang/slides-${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    categories = List<Category>.from(
        (jsonMap['Categories']).map((e) => Category.fromJson(e)));
    tags = List<Tags>.from((jsonMap['tags']).map((e) => Tags.fromJson(e)));
    activeLanguages = List<String>.from((jsonMap['activeLanguages']));
    return true;
  }

  // This method will be called from every widget which needs a localized text

  List<Category> getCategories() {
    return categories;
  }

  List<String> getActiveLanguages() {
    return activeLanguages;
  }

  List<Tags> getTags() {
    return tags;
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
