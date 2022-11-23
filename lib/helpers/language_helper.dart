import 'package:flutter/material.dart';

class LanguageHelper {
  convertLangNameToLocale(String langNameToConvert) {
    Locale convertedLocale;

    switch (langNameToConvert) {
      case 'English':
        convertedLocale = Locale('en', 'EN');
        break;
      case 'Русский':
        convertedLocale = Locale('ru', 'RU');
        break;
      case 'Tűrkce':
        convertedLocale = Locale('tr', 'TR');
        break;
      case 'Uzbek':
        convertedLocale = Locale('uz', 'UZ');
        break;
      default:
        convertedLocale = Locale('ru', 'RU');
    }

    return convertedLocale;
  }

  convertLocaleToLangName(String localeToConvert) {
    String langName;

    switch (localeToConvert) {
      case 'en':
        langName = "English";
        break;
      case 'ru':
        langName = "Русский";
        break;
      case 'tr':
        langName = "Tűrkce";
        break;
      case 'uz':
        langName = "Uzbek";
        break;
      default:
        langName = "Русский";
    }

    return langName;
  }
}