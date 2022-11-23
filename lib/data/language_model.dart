import 'dart:ui';

class LanguageModel {
  final String languageCode;
  final String countryCode;
  final String name;

  LanguageModel({
    required this.languageCode,
    required this.countryCode,
    required this.name,
  });

  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }
}
