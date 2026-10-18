# دليل نشر coder-organizer على Google Play — خطوة بخطوة

> المرجع المعماري: `SRS` + القرارات D-001 (شراء واحد 9.99$)، D-015 (تجربة 30 يوماً داخلية)، D-017 (تحليلات بموافقة)، D-019 (CI = بيئة البناء).
> الحالة وقت كتابة الدليل: v1.24 بتوقيع debug — هذا الدليل يوصلك من هنا إلى «منشور».
> الدليل التكميلي التجاري: `SELLING-IN-STORES.md`.

---

## المرحلة 0 — المتطلبات المادية

| المتطلب | التفصيل | التكلفة |
|---|---|---|
| حساب Google Play Developer | من [play.google.com/console](https://play.google.com/console) — يتطلب توثيق هوية + اسم مطور عام | **25$ مرة واحدة مدى الحياة** |
| جهاز كمبيوتر بهذه البيئة | نفس بيئة البناء D-019: Flutter 3.47.6 + JDK 21 + Gradle 9.3.1 | — |
| بريد دعم عام | سيظهر للجمهور في صفحة المتجر | مجاني |
| رابط سياسة خصوصية | يكفي GitHub Pages من هذا المستودع | مجاني |

> ملاحظة عن مدة مراجعة الحساب الجديد: إنشاء الحساب قد يستغرق 48 ساعة للتحقق، وخُذ في الاعتبار أن الحسابات الجديدة تُطلب منها أحياناً إثبات هوية إضافي (بطاقة/وجه). ابدأ بفتح الحساب **في اليوم الأول** حتى تجري المراجعة بالتوازي مع تجهيزك للحزمة.

---

## المرحلة 1 — التوقيع النهائي (إلزامي قبل أي رفع)

التطبيق حالياً موقّع بمفتاح debug. النشر يتطلب keystore خاصاً بك. **نقطة حاسمة: من يملك keystore يملك التطبيق — احتفظ به في مكانين آمنين (قرص خارجي + مدير كلمات مرور) ولا ترفعه لأي مكان عام أبداً.**

### 1.1 توليد المفتاح
```bash
keytool -genkey -v -keystore coder-organizer-release.jks \
  -keyalg RSA -keysize 4096 -validity 10000 \
  -alias coder_organizer
```
- سيطلب كلمة مرور للمخزن وكلمة مرور للمفتاح — اجعلهما قويين واحفظهما في مدير كلمات مرور.
- `validity 10000` يوماً — متطلب Play أن يظل المفتاح صالحاً بعد أكتوبر 2033.

### 1.2 ربط المفتاح بالمشروع
أنشئ الملف `android/key.properties` (خارج git — أضفه إلى `.gitignore`):
```properties
storePassword=********
keyPassword=********
keyAlias=coder_organizer
storeFile=../coder-organizer-release.jks
```
وضع ملف الـ keystore في مجلد `android/` (وأضف `*.jks` إلى `.gitignore`).

### 1.3 تعديل `android/app/build.gradle.kts`
```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties().apply {
    load(FileInputStream(rootProject.file("key.properties")))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ... بقية الإعدادات الحالية تبقى
        }
    }
}
```

### 1.4 إزالة إذن QUERY_ALL_PACKAGES
في `android/app/src/main/AndroidManifest.xml` — احذف:
```xml
<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
```
واستبدله بالإعلان الموجه (التطبيق يطلق تطبيقات/روابط من عناصر الشجرة):
```xml
<queries>
    <intent>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent>
</queries>
```
> لماذا؟ `QUERY_ALL_PACKAGES` إذن مقيد تحظر سياسات Play إلا لحالات استخدام محددة جداً (أدوات إدارية/مكافحة فيروسات). استخدامك الفعلي هو «فتح تطبيقات مرتبطة بعناصر» — والإعلان الموجه أعلاه يغطيه بالكامل ويمر المراجعة.

### 1.5 بناء حزمة الرفع (AAB)
```bash
flutter clean
flutter pub get
flutter build appbundle --release --flavor stable
# الناتج: build/app/outputs/bundle/stableRelease/app-stable-release.aab
```
> انشر نسخة **stable الكاملة** في Play (انظر قرار النسختين في `SELLING-IN-STORES.md` §4). تحقق من الإصدار: `versionCode 24` يجب أن يظهر في اسم/محتوى الحزمة، وكل رفع لاحق يرفع الرقم إجبارياً.

---

## المرحلة 2 — إنشاء التطبيق في Play Console

1. ادخل إلى [Play Console](https://play.google.com/console) → **Create app**.
2. املأ:
   - **App name**: `Coder Organizer — Dev Task Tree` (≤30 حرفاً؛ يمكنك ضبطه لاحقاً).
   - **Default language**: English (United States) — التطبيق يدعم العربية والإنجليزية، لكن اللغة الافتراضية للقائمة إنجليزية ثم تضاف العربية كترجمة.
   - **App or game**: App.
   - **Free or paid**: **Free** — لأن الدخل عبر الشراء داخل التطبيق (القرار D-001). التطبيقات المدفوعة مقدماً تقيد الدفع في دولاً أقل؛ IAP أنسب لنموذجك.
3. أقر بالإقرارات الثلاثة (برنامج المطورين، قوانين التصدير الأمريكية — أجب «لا» على التصدير المشفر لأن التشفير لديك محلي للبيانات فقط، وبرنامج عائلي عدالة).
4. من القائمة الجانبية → **Dashboard** سترى قائمة «Setup checklist» — الخطوات التالية تملأها بالترتيب.

---

## المرحلة 3 — تعبئة قائمة المتجر (Store listing)

### 3.1 البيانات النصية
| الحقل | القيمة المقترحة |
|---|---|
| Short description (≤80) | `Organize your coding projects: tasks, notes & secrets in one dev tree.` |
| Full description | انسخ من README وأعد صياغته تسويقياً: فقرة القيمة → قائمة FR-01..06 → دعم العربية/الإنجليزية → 8 ثيمات → خصوصية (بيانات محلية) |
| App category | **Productivity** |
| Tags | Productivity، Task management، Developer tools |
| Email + Phone | بريد الدعم (الهاتف اختياري) |
| Website | رابط المستودع على GitHub |

### 3.2 الأصول الرسومية
- **App icon 512×512**: جاهزة — ارفع `branding/play-store-icon-stable-512.png` كما هي (32-bit PNG بلا شفافية — مطابقة تماماً).
- **Feature graphic 1024×500**: أنشئها من الهوية (خلفية نيلية متدرجة + رمز الأيقونة يسار + اسم التطبيق). أداة مجانية: Canva بمقاس مخصص.
- **Screenshots**: 4 لقطات هاتف على الأقل (16:9 أو 9:16): شاشة الشجرة الرئيسية، محرر عنصر، البحث/الفلترة، الإعدادات مع الثيمات الثمانية. خذها من هاتفك مباشرة (أعلى جودة).

### 3.3 الترجمة العربية
Store listing → **Manage translations** → أضف `العربية` واملأ العنوان والوصفين بالعربية (أوفر لك مسودة):
- العنوان: `منظّم المبرمج — شجرة مهام ومشاريع`
- الوصف المختصر: `نظّم مشاريعك البرمجية: مهام وملاحظات وأسرار في شجرة واحدة`

---

## المرحلة 4 — إقرارات المحتوى والسياسات

### 4.1 App content (قسم Policy)
- **Privacy policy**: رابط الصفحة المستضافة — إلزامي ولن يُقبل النشر بدونه.
- **Ads**: لا يحتوي إعلانات.
- **Content rating**: استبيان IARC — إجابات مباشرة (لا عنف/رهانات/محتوى مستخدمين عام) → النتيجة Everyone.
- **Target audience**: 18+ أو «13+» — اختر الفئة العمرية دون «مصمم للأطفال» (يغلق متطلبات الأطفال الثقيلة).
- **Data safety** (الأهم — أجب بدقة حسب الحقيقة):
  - هل يجمع التطبيق بيانات شخصية أو تشاركها؟ → **لا يجمع، لا يشارك** إذا نشرت نسخة بلا Firebase مهيأ.
  - إذا فعّلت Firebase Analytics لاحقاً: عدّل الإجابة إلى «يجمع بيانات استخدام، مشفرة أثناء النقل، قابلة للحذف بطلب المستخدم» — التطبيق مصمم أصلاً على الموافقة الصريحة D-017، فأنت متوافق.
- **Government apps / financial features**: لا.

### 4.2 ملف الدخول والتقنيات
- إن استخدمت لاحقاً ميزات تسجيل دخول Firebase: أضف إقرار «Account deletion» (متطلب جديد يُطلب عند وجود إنشاء حسابات).

---

## المرحلة 5 — إعداد الفوترة (القرار D-001)

1. Play Console → تطبيقك → **Monetize → Products → In-app products** → **Create product**.
2. املأ:
   - **Product ID**: `unlock_pro_lifetime` — **يجب أن يطابق الرمز في كود `BillingService` حرفياً** (افحص الثابت في `lib/data/services/billing_service.dart` ووحّد).
   - **Name**: `Pro — Lifetime Unlock`
   - **Price**: 9.99$ — Play يحول تلقائياً لعملات الدول (يمكنك تعديل أسعار مناطق بعينها لاحقاً).
3. فعّل المنتج (Activate). 
4. **اختبار الفوترة**: أضف بريدك كمختبر → Settings → License testing؛ على الجهاز المختبِر تكون المشتريات تجريبية بلا خصم حقيقي.
5. ملاحظة معمارية: تجربة الـ 30 يوماً **داخلية في التطبيق** (D-015 مشفرة محلياً) وليست Trial من Play — لذا لا شيء يُعدّ في قسم Subscriptions. الفائدة: التجربة تعمل حتى بلا اتصال بشبكة Play.

---

## المرحلة 6 — الاختبار ثم النشر (مسارات الإصدار)

Play Console → **Testing →** ثلاثة مسارات، اعبرهم بالترتيب:

1. **Internal testing** (حتى 100 بريد): ارفع الـ AAB هنا أولاً — النشر خلال دقائق. جرّب: تثبيت، تجربة 30 يوماً، انتهاء تجربة مصطنع (عدّل تاريخ الجهاز)، شراء تجريبي، استعادة الشراء بعد إعادة تثبيت.
2. **Closed testing** (20–50 مستخدماً): انسخ لهم رابط الانضمام. **مهم للحسابات الجديدة**: Google يشترط غالباً 14 يوماً من الاختبار المغلق بعشرين مختبِراً على الأقل قبل فتح الإنتاج — ابدأ تجميع المختبرين مبكراً.
3. **Production → Create new release**:
   - ارفع AAB النهائي.
   - **Release notes**: أول إصدار — اكتبها بالعربية والإنجليزية.
   - اختر **Staged rollout** بنسبة **20%** ثم ارفعها 50% → 100% عبر الأيام — يحدّ من ضرر أي مشكلة مفاجئة على التقييمات.
   - اضغط **Start rollout to Production** → المراجعة تستغرق عادة 1–7 أيام لأول إصدار من حساب جديد.

---

## المرحلة 7 — ما بعد النشر (التزامات مستمرة)

- **مراقبة Android Vitals**: ANR/Crashes — حد التحذير ANR أقل من 0.47%.
- **رد التقييمات** من قسم Ratings and reviews (يظهر ردك للعامة).
- **كل تحديث**: ارفع versionCode +1 مع AAB جديد على مسار Production (تحديثات التطبيقات المنشورة تراجع خلال ساعات عادة لا أيام).
- **Play App Signing**: عند أول رفع سيقترح عليك Play تفعيل توقيع التطبيق المُدار — **اقبله** ثم **احتفظ بـ Upload key** (keystore الرفع) بأمان؛ فقدانه يعني طلب إعادة تعيين معقدة.

---

## ملخص المسار في 10 أسطر

```
١. افتح حساب Developer (25$) — اليوم، للمراجعة المتوازية
٢. keystore release + key.properties + signingConfigs
٣. استبدل QUERY_ALL_PACKAGES بـ <queries> الموجه
٤. flutter build appbundle --release --flavor stable
٥. سياسة خصوصية على GitHub Pages + لقطات شاشة + Feature graphic
٦. Create app + تعبئة Store listing (أيقونة branding/ جاهزة) + Data safety
٧. أنشئ IAP: unlock_pro_lifetime بسعر 9.99$ وفعّله
٨. Internal → Closed (١٤ يوماً/٢٠ مختبراً) → Production rollout 20%
٩. مراقبة Vitals + رد التقييمات
١٠. دورة تحديث كل 2–4 أسابيع بإصدار versionCode جديد
```
