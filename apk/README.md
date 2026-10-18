# APK — ملفات التثبيت (v1.24)

نسختان بأيقونتين جديدتين مميزتين + إصلاح اللغة عند الإقلاع:

## 1) coder-organizer-v1.24-lite-arm64.apk (~12 MB) — ابدأ بهذه
- اسم الظهور: **Coder Organizer Lite**
- أيقونة رمز قوسي الكود والسهم الصاعد بلمسة **فيروزية**
- حزمة مستقلة `com.coderorganizer.lite` — لا تتعارض مع أي تثبيت سابق
- معمارية arm64-v8a (هواتف أندرويد الحديثة) + تغليف قديم متوافق (extractNativeLibs=true)

## 2) coder-organizer-v1.24-full-universal.apk (~31 MB) — النسخة الكاملة
- اسم الظهور: **Coder Organizer**
- أيقونة نفس الرمز بلمسة **كهرمانية + نجمة ذهبية** (تمييز النسخة الكاملة)
- الحزمة الرسمية `com.coderorganizer` — تشمل كل المعماريات (arm64 / armv7 / x86_64)

## جديد في v1.24
- أيقونتا تطبيق احترافيتان (legacy + adaptive بتقنية Android 8+ لكل الكثافات)
- إصلاح وميض اللغة: التطبيق يبدأ بلغتك المحفوظة من أول إطار (لا عربية مفاجئة إن اخترت الإنجليزية)

روابط مباشرة:
- https://raw.githubusercontent.com/alialiapoeskndr987-source/coder-Organizer/main/apk/coder-organizer-v1.24-lite-arm64.apk
- https://raw.githubusercontent.com/alialiapoeskndr987-source/coder-Organizer/main/apk/coder-organizer-v1.24-full-universal.apk

فحص السلامة: SHA256SUMS.txt — الإصدار 1.24 / versionCode 24 / توقيع تجريبي (debug) للتجربة الشخصية.
> ملاحظة: تحقق من البصمة بعد التحميل إن كانت شبكتك متذبذبة: `certutil -hashfile الملف SHA256` على ويندوز أو `shasum -a 256` على لينكس/ماك.
