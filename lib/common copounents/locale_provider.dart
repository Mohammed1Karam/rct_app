import 'package:flutter/material.dart';
import 'package:rct/services/cache_helper.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = CacheHelper.getData(key: "lang") == "en"
      ? const Locale('en', 'US')
      : const Locale('ar', 'SA');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    CacheHelper.saveData(key: "lang", value: locale.languageCode);

    notifyListeners();
  }
  void clearLocale() {
    _locale = const Locale('ar', 'SA');
    notifyListeners();
  }
}

class L10n {
  static final all = [
    const Locale('en', 'US'),
    const Locale('ar', 'SA'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return '🇸🇦';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
