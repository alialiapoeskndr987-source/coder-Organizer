# 🛠️ دليل البناء والتشغيل — coder-organizer v1.22

> **الحالة:** كود MVP كامل (المهمة 002) — مُختبَر ومحلَّل في بيئة العمل (D-019)
> **القرارات المرجعية:** D-014/D-015/D-018 (نموذج الربح)، D-020 (الهوية)، SRS v1.0 الأقسام 3-10

---

## 1. ما بُني (تغطية SRS)

| المتطلب | التنفيذ | الموقع |
|---------|---------|--------|
| FR-01 المصادقة | بريد+كلمة مرور (8+ أحرف بمقياس قوة) + Google Sign-In + رابط إعادة ضبط 60 دقيقة + حذف الحساب. **يتفعّل تلقائياً عند إعداد Firebase** (§4) وإلا يعمل التطبيق بوضع محلي | `lib/data/services/auth_service.dart` + `lib/features/auth/` |
| FR-02 إعدادات المالك | 8 ثيمات تطبيق فوري، عنوان رئيسي ≤60 حرفاً، تصدير/استيراد gzip-JSON عبر SAF بمعاينة واستراتيجيتي استبدال/دمج، تغيير كلمة المرور | `lib/features/settings/` |
| FR-03 البنية الهرمية | تبويب→فرعي→قسم→مشروع + مساعد إنشاء متتالٍ بخيار «➕ جديد» بكل مستوى + 5 قوالب + سلة محذوفات بمدة 30 يوماً + تراجع فوري SnackBar | `lib/features/create/` + `lib/features/tree/` + `lib/features/trash/` |
| FR-04 البحث والفلترة | فلاتر منسدلة من البيانات الفعلية بخيار «جديد» بكل قائمة + بحث نصي + نتائج فورية | `lib/features/search/search_screen.dart` |
| FR-05 الرئيسية | العنوان المخصص + شبكة التبويبات (أيقونة/اسم/عدد المشاريع) + الأكثر زيارة 7 أيام + آخر ما فُتح + زر إنشاء عائم | `lib/features/home/` |
| FR-06 عناصر العقدة | روابط (5 تصنيفات) + ملاحظات ≤50 بتنقّل + تنبيهات بإشعارات نظام تعمل والتطبيق مغلق + **البريد المسجل، الاشتراكات، منصات النشر، المتغيرات** (التميّز التنافسي) | `lib/features/node/` |
| NFR-02/03 الخصوصية | محتوى المستخدم لا يغادر الجهاز؛ كلمات مرور البريد والمتغيرات السرّية **مستثناة من التصدير** | `backup_dao.dart` + اختبار مؤكد |
| NFR-06 التوطين | إنجليزي افتراضي + عربي RTL كامل | `lib/l10n/` |
| التجربة (D-015) | 30 يوماً كاملة الميزات من أول تشغيل، محفوظة في مكانين (Drift + Secure Storage) والأقدم يفوز — لا تمديد بمسح البيانات | `lib/data/services/trial_service.dart` |
| الشراء (D-014/18) | IAP واحد `coder_organizer_lifetime` غير استهلاكي، استعادة مشتريات، حالة انتظار/خطأ كاملة | `lib/data/services/billing_service.dart` + `paywall_screen.dart` |
| التحليلات (D-017) | شاشة/مفتاح موافقة + 5 أحداث معتمدة فقط (بوابة صلبة) | `lib/data/services/analytics_service.dart` |

**البنية:** `core/` (ثوابت، ثيمات، تعدادات) → `data/` (Drift: 10 جداول + NodesDao/ElementsDao/BackupDao، خدمات) → `providers/` (Riverpod) → `features/` (11 شاشة) → `shared/widgets/`.

---

## 2. تشغيل المشروع على جهازك

المتطلبات: Flutter 3.24+ (طُوِّر واختُبر على 3.47.6 stable) + Android SDK + JDK 17.

```bash
git clone https://github.com/alialiapoeskndr987-source/coder-Organizer.git
cd coder-Organizer
flutter pub get
flutter run                # تشغيل تجريبي على جهاز/محاكي أندرويد
flutter test               # 6 اختبارات وحدة لطبقة البيانات (يجب أن تنجح كلها)
flutter analyze            # بلا أخطاء
flutter build appbundle    # App Bundle للنشر (بعد إعداد التوقيع §6)
flutter build apk --release  # APK مباشر
```

> **ملاحظة إعادة التوليد:** عند أي تعديل مستقبلي على `lib/data/db/tables.dart` أعد:
> `dart run build_runner build --delete-conflicting-outputs`
> الترجمات: `flutter gen-l10n` (تلقائي عند البناء).

---

## 3. الثوابت المركزية (D-020) — مصدر الهوية الوحيد

`lib/core/constants/app_constants.dart`:
`appName='coder-organizer'` · `appDisplayName='Coder Organizer'` · `appVersion='1.22'`
`applicationId='com.coderorganizer'` (في `android/app/build.gradle.kts`) · `versionName="1.22"`, `versionCode=22`.
أي إعادة تسمية مستقبلاً = تعديل هذا الملف + build.gradle.kts فقط.

---

## 4. تفعيل Firebase (للمصادقة FR-01) — ~15 دقيقة

الكود جاهز بالكامل ويعمل حالياً بوضع محلي (بدون Firebase) كي تبني وتجرّب فوراً. للتفعيل:

1. أنشئ مشروعاً في [console.firebase.google.com](https://console.firebase.google.com) وأضف تطبيق أندرويد بالمعرّف `com.coderorganizer`.
2. حمّل `google-services.json` وضعه في `android/app/`.
3. في `android/settings.gradle.kts` أضف داخل `plugins`: `id("com.google.gms.google-services") version("4.4.2") apply false`
4. في `android/app/build.gradle.kts` أضف أعلى الملف داخل plugins: `id("com.google.gms.google-services")`
5. لدخول Google: أضف بصمة SHA-1 (من `cd android && ./gradlew signingReport` أو مفتاح الإصدار) في إعدادات مشروع Firebase.
6. فعّل في Firebase Console: Authentication → Email/Password + Google.
7. Analytics يعمل تلقائياً بعد التفعيل — لا يرسل شيئاً قبل موافقة المستخدم (D-017).

**لا حاجة لأي خطوة إضافية في الكود** — `main.dart` يكتشف Firebase ويحوّل تلقائياً من الوضع المحلي إلى `FirebaseAuthService`.

---

## 5. تفعيل الشراء (D-014/D-018) — في Play Console

1. Play Console → تطبيقك → Monetize → Products → In-app products.
2. أنشئ منتجاً بمعرّف: **`coder_organizer_lifetime`** (غير استهلاكي One-time) بسعر **9.99$**.
3. الكود يستعلم المنتج تلقائياً ويعرض سعره في شاشة الترقية؛ يدعم: شراء/انتظار/استعادة/خطأ.
4. للاختبار قبل النشر: أضف بريدك كمختبِر داخلي (Internal Testing).

---

## 6. توقيع النشر (App Bundle)

```bash
keytool -genkey -v -keystore ~/coder-organizer-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
أنشئ `android/key.properties` بمسار المفتاح وكلمات السر، وأضف كتلة `signingConfigs` في `android/app/build.gradle.kts` (نمط Flutter القياسي)، ثم `flutter build appbundle`.
الناتج: `build/app/outputs/bundle/release/app-release.aab` → Internal Testing (D-013).

---

## 7. ملاحظات هندسية معروفة (MVP)

- **الأسرار محفوظة في قاعدة التطبيق الخاصة دون تشفير** (محمية بعزل أندرويد)، ومستثناة من التصدير (NFR-02). تشفير القيم مرشّح لتقوية v1.1.
- التنبيهات تُعاد جدولتها تلقائياً عند فتح التطبيق/الاستيراد/الاسترجاع؛ إشعارات ما بعد إعادة تشغيل الهاتف تُعاد عند أول فتح (إضافة مستقبِل Boot محتملة لاحقاً).
- دمج الاستيراد يضيف نسخة جديدة بمعرّفات معاد ربطها (لا يحاول الإصلاح بالمعرّف) — سلوك موثّق ومقصود.
- الأيقونة الافتراضية Flutter مستخدمة مؤقتاً — الهوية البصرية بند Q11 المتبقي قبل النشر.

## 8. البناء السحابي بدون حاسوب (GitHub Actions) — سجل الإصلاح

**السياق:** بيئة البناء المعتمدة هي بيئة العمل (D-019)، وأُضيف مسار سحابي موازٍ يبني APK تلقائياً عند كل push إلى main دون حاجة لأي حاسوب محلي.

**سجل مشاكل البناء وحلولها (للمرجعية):**

| # | المشكلة | الحل المعتمد |
|---|---------|--------------|
| 1 | `path_provider_android` 2.3.x أُدخل فيه كود JNI أصلي (jni/cmake) يفرض تنزيل NDK وفشل البناء في البيئات المحدودة | قفل الإصدار الخالص `2.2.23` عبر `dependency_overrides` في pubspec.yaml (آخر إصدار Kotlin فقط، متوافق مع path_provider 2.1.5) |
| 2 | Flutter 3.47 + AGP 9.1 يفرضان NDK لإزالة رموز التنقيح حتى بلا كود C | حذف `ndkVersion = flutter.ndkVersion` من `android/app/build.gradle.kts` (لا NDK إطلاقاً بعد إصلاح #1) |
| 3 | `gradlew` و`gradlew.bat` و`gradle-wrapper.jar` مستبعدة من المستودع بـ android/.gitignore الافتراضي | خطوة "Restore Gradle wrapper" في الـ workflow تولّدها بـ Gradle 9.3.1 المطابق لـ gradle-wrapper.properties |

**مسار CI (`.github/workflows/build-apk.yml`):**
- JDK 21 (Temurin) + Flutter 3.47.6 stable + استعادة الـ wrapper 9.3.1
- `flutter pub get` ثم `flutter analyze` (يجب أن يكون نظيفاً) ثم `flutter test` (يجب أن تنجح كلها) ثم بناء APK شامل (كل المعماريات) + APK arm64 مجزأ
- المخرجات تُرفع كـ artifact باسم `coder-organizer-apks` يحوي: `coder-organizer-v1.22-release.apk` (شامل) + `coder-organizer-v1.22-arm64.apk` + `SHA256SUMS.txt`

**توقيع APK المبني في CI:** توقيع debug (سلوك قالب Flutter الافتراضي) — يكفي للتثبيت التجريبي المباشر على الجهاز؛ يُعاد التوقيع بمفتاح النشر قبل رفع App Bundle إلى Play (§6).
