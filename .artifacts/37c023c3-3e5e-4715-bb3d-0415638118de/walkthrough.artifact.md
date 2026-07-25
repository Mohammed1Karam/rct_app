# شاشة سبلاش ثابتة وسلسة (بدون وميض أبيض)

تم تحسين شاشة البداية (Splash Screen) لتعمل بشكل أكثر احترافية وسلاسة، مع منع الوميض الأبيض وزيادة وقت العرض.

## التغييرات الرئيسية

- **حل مشكلة الوميض الأبيض (Android):**
    - تم تغيير خلفية النظام (Native Window) من شفافة إلى اللون الداكن الموحد `#20262f`.
    - تم تعطيل خاصية الشفافية في ملفات `styles.xml` لضمان ظهور اللون فور نقر أيقونة التطبيق.
- **توحيد الصورة:**
    - تم ضبط الألوان في إصدارات أندرويد القديمة والحديثة (Android 12+) لتتطابق تماماً مع شاشة فلاتر.
- **زيادة المدة:**
    - تم تحديث وقت الانتظار في ملف `lib/splash.dart` ليصبح **4 ثوانٍ** بدلاً من 3، لكل من أندرويد و iOS.

## ما تم اختباره
- تم التحقق من ملفات الأندرويد (`styles.xml`) للتأكد من صحة قيم الألوان والخصائص.
- تم التحقق من كود فلاتر للتأكد من تغيير مدة الـ `Future.delayed`.

> [!TIP]
> عند تشغيل التطبيق الآن، سيظهر اللون الداكن `#20262f` فوراً بدلاً من الشاشة البيضاء، ثم سيظهر الشعار بشكل ثابت وبدون أي حركة مفاجئة عند انتقال التحكم إلى فلاتر.

render_diffs(file:///Users/mohammed/Documents/app_mobile/RCT-Mobile/RCT-Mobile/android/app/src/main/res/values/styles.xml)
render_diffs(file:///Users/mohammed/Documents/app_mobile/RCT-Mobile/RCT-Mobile/android/app/src/main/res/values-v31/styles.xml)
render_diffs(file:///Users/mohammed/Documents/app_mobile/RCT-Mobile/RCT-Mobile/lib/splash.dart)
