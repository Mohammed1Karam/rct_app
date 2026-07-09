import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rct/services/cache_helper.dart';

void initializeAppLanguage() {
  // التحقق إذا كانت اللغة مخزنة
  String? savedLanguage = CacheHelper.getData(key: "lang");

  // إذا لم تكن مخزنة، استخدم لغة الجهاز الافتراضية
  if (savedLanguage == null) {
    // جلب لغة الجهاز
    String deviceLanguage = ui.window.locale.languageCode;

    // تخزين اللغة (عربية إذا كانت "ar"، وإلا افتراضية "en")
    CacheHelper.saveData(
        key: "lang", value: deviceLanguage == "ar" ? "ar" : "en");
  }
}

// استخدام اللغة المخزنة لتحديد الـ borderRadius
BorderRadius getDynamicBorderRadius() {
  // التحقق من اللغة المخزنة أو استخدام لغة الجهاز إذا لم يتم التخزين
  String? language = CacheHelper.getData(key: "lang");

  if (language == null) {
    // إذا كانت اللغة غير موجودة في التخزين، استخدم لغة الجهاز
    String deviceLanguage = ui.window.locale.languageCode;
    language = deviceLanguage == "ar" ? "ar" : "en";

    // تخزين اللغة لاستخدامها لاحقًا
    CacheHelper.saveData(key: "lang", value: language);
  }

  // تحديد الـ borderRadius بناءً على اللغة
  bool isArabic = language == "ar";
  return BorderRadius.only(
    topLeft: Radius.circular(isArabic ? 100 : 0),
    topRight: Radius.circular(isArabic ? 0 : 100),
  );
}
