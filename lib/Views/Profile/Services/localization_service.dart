import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static LocalizationService? _instance;
  Map<String, String>? _localizedStrings;

  LocalizationService._();

  static LocalizationService getInstance() {
    if (_instance == null) {
      _instance = LocalizationService._();
    }
    return _instance!;
  }

  Future<void> loadLocalization(String languageCode) async {
    String jsonString = await rootBundle.loadString('assets/locales/localization.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap[languageCode] as Map<String, String>;
  }

  String getTranslatedValue(String key) {
    return _localizedStrings![key] ?? key; // Trả về key nếu không tìm thấy
  }

  getString(String s) {}
}
