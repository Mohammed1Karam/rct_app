# إزالة الـ Native Splash والاعتماد على Flutter Splash

الهدف هو إزالة مكتبة `flutter_native_splash` وإعداداتها من المشروع، بحيث يعتمد التطبيق فقط على الـ Widgets البرمجية (Flutter) التي تتحكم في شاشة البداية.

## التغييرات المقترحة

### [Component Name] التنظيف والإزالة

#### [MODIFY] [pubspec.yaml](file:///Users/mohammed/Documents/app_mobile/RCT-Mobile/RCT-Mobile/pubspec.yaml)
- إزالة `flutter_native_splash: ^2.4.7` من قسم `dependencies`.
- إزالة كتلة الإعدادات `flutter_native_splash:` بالكامل من نهاية الملف.

#### [MODIFY] [splash.dart](file:///Users/mohammed/Documents/app_mobile/RCT-Mobile/RCT-Mobile/lib/splash.dart)
- إزالة `import 'package:flutter_native_splash/flutter_native_splash.dart';`.
- إزالة استدعاء `FlutterNativeSplash.remove();` في كلاس `IOSSplashScreen`.

## خطة التحقق

### التحقق اليدوي
1. تشغيل أمر `flutter pub run flutter_native_splash:remove` لتنظيف ملفات النيتف (Android/iOS).
2. تشغيل `flutter pub get` للتأكد من حذف المكتبة.
3. بناء التطبيق للتأكد من عدم وجود أخطاء في الكومبايل.
