// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Coder Organizer';

  @override
  String get tagline => 'مشاريعك منظمة بالكامل';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get done => 'تم';

  @override
  String get undo => 'تراجع';

  @override
  String get restore => 'استرجاع';

  @override
  String get search => 'بحث';

  @override
  String get close => 'إغلاق';

  @override
  String get confirm => 'تأكيد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'حسناً';

  @override
  String get create => 'إنشاء';

  @override
  String get name => 'الاسم';

  @override
  String get optional => 'اختياري';

  @override
  String get home => 'الرئيسية';

  @override
  String get alerts => 'التنبيهات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get trash => 'سلة المحذوفات';

  @override
  String trialBanner(int days) {
    return 'تجربة مجانية — بقيت $days يوماً';
  }

  @override
  String get trialLastDay => 'تجربة مجانية — اليوم الأخير!';

  @override
  String get trialExpiredTitle => 'انتهت تجربتك المجانية';

  @override
  String get trialExpiredBody =>
      'بياناتك آمنة ويمكنك تصفح كل شيء. رقِّ مرة واحدة للوصول مدى الحياة لمتابعة الإنشاء والتعديل.';

  @override
  String get upgrade => 'ترقية';

  @override
  String get upgradeNow => 'الترقية الآن';

  @override
  String priceLifetime(String price) {
    return 'وصول مدى الحياة — $price';
  }

  @override
  String get purchaseSuccess =>
      'تمت الشراء بنجاح. شكراً لدعمك Coder Organizer!';

  @override
  String get purchaseError => 'لم تكتمل عملية الشراء. حاول مرة أخرى.';

  @override
  String get purchasePending =>
      'الشراء قيد المعالجة وسيُفعّل تلقائياً بعد تأكيده.';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordWeak => 'ضعيفة';

  @override
  String get passwordFair => 'متوسطة';

  @override
  String get passwordStrong => 'قوية';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetLinkSent =>
      'إن كان البريد مسجلاً فقد أُرسل رابط إعادة ضبط آمن صالح لمدة 60 دقيقة.';

  @override
  String get continueWithGoogle => 'المتابعة بحساب جوجل';

  @override
  String get authError => 'فشلت المصادقة. تحقق من البيانات وحاول مجدداً.';

  @override
  String get deleteMyAccount => 'حذف حسابي';

  @override
  String get deleteAccountConfirm =>
      'سيُحذف حسابك وبياناته السحابية نهائياً. تبقى البيانات المحلية على هذا الجهاز حتى إزالة التطبيق. هل تريد المتابعة؟';

  @override
  String get defaultWorkspaceTitle => 'مساحتي';

  @override
  String get mostVisited => 'الأكثر زيارة (7 أيام)';

  @override
  String get lastOpened => 'آخر ما فُتح';

  @override
  String projectsCount(int count) {
    return '$count مشروعاً';
  }

  @override
  String get createNew => 'إنشاء جديد';

  @override
  String get mainTab => 'تبويب رئيسي';

  @override
  String get subTab => 'تبويب فرعي';

  @override
  String get section => 'قسم';

  @override
  String get project => 'مشروع';

  @override
  String get nodeType => 'النوع';

  @override
  String get tplClient => 'مشروع لزبون';

  @override
  String get tplPersonal => 'مشروع شخصي';

  @override
  String get tplSubscription => 'اشتراك / خدمة';

  @override
  String get tplQuickNote => 'ملاحظة سريعة';

  @override
  String get tplCustom => 'مخصص (بلا قالب)';

  @override
  String get template => 'القالب';

  @override
  String createNodeTitle(String type) {
    return 'إنشاء $type';
  }

  @override
  String get parentTab => 'التبويب الرئيسي';

  @override
  String get parentSub => 'التبويب الفرعي';

  @override
  String get parentSection => 'القسم';

  @override
  String get optionNew => '➕ جديد…';

  @override
  String get noParentYet => 'لا يوجد بعد — أنشئ واحداً بالأعلى';

  @override
  String deleteNodeTitle(String name) {
    return 'حذف «$name»؟';
  }

  @override
  String deleteCascadeWarn(int count) {
    return 'سيُنقل معه $count عنصراً متداخلاً وكل عناصرها إلى سلة المحذوفات.';
  }

  @override
  String get movedToTrash => 'نُقل إلى سلة المحذوفات';

  @override
  String get restored => 'استُرجع';

  @override
  String get breadcrumbRoot => 'مساحة العمل';

  @override
  String childrenCount(int count) {
    return '$count عنصراً';
  }

  @override
  String get nodeDetails => 'التفاصيل';

  @override
  String get renameNode => 'إعادة تسمية';

  @override
  String get changeIcon => 'تغيير الأيقونة';

  @override
  String get status => 'الحالة';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusArchived => 'مؤرشف';

  @override
  String get links => 'الروابط';

  @override
  String get notes => 'الملاحظات';

  @override
  String get alertsWithCount => 'التنبيهات';

  @override
  String get registeredEmails => 'البريد المسجل';

  @override
  String get subscriptions => 'الاشتراكات';

  @override
  String get platforms => 'منصات النشر';

  @override
  String get variables => 'المتغيرات';

  @override
  String get addLink => 'إضافة رابط';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get addAlert => 'إضافة تنبيه';

  @override
  String get addEmail => 'إضافة بريد';

  @override
  String get addSubscription => 'إضافة اشتراك';

  @override
  String get addPlatform => 'إضافة منصة';

  @override
  String get addVariable => 'إضافة متغير';

  @override
  String get linkTitle => 'عنوان الرابط';

  @override
  String get url => 'الرابط URL';

  @override
  String get linkRepository => 'مستودع';

  @override
  String get linkDashboard => 'لوحة تحكم';

  @override
  String get linkWebsite => 'موقع';

  @override
  String get linkStore => 'متجر';

  @override
  String get linkOther => 'أخرى';

  @override
  String get noteTitle => 'العنوان (اختياري)';

  @override
  String get noteContent => 'المحتوى';

  @override
  String get notesLimit => 'حتى 50 ملاحظة لكل عقدة';

  @override
  String get emailLabel => 'الوصف';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailPassword => 'كلمة المرور';

  @override
  String get showSecret => 'إظهار';

  @override
  String get hideSecret => 'إخفاء';

  @override
  String get subService => 'اسم الخدمة';

  @override
  String get subPlan => 'الخطة';

  @override
  String get subPrice => 'السعر';

  @override
  String get subCycle => 'دورة الفوترة';

  @override
  String get cycleMonthly => 'شهري';

  @override
  String get cycleYearly => 'سنوي';

  @override
  String get cycleLifetime => 'مدى الحياة';

  @override
  String get cycleCustom => 'مخصص';

  @override
  String get subRenewsAt => 'يتجدد في';

  @override
  String get subStatus => 'حالة الاشتراك';

  @override
  String get subActive => 'نشط';

  @override
  String get subCancelled => 'ملغى';

  @override
  String get subExpired => 'منتهٍ';

  @override
  String get platformName => 'المنصة';

  @override
  String get platformAccount => 'الحساب / المعرّف';

  @override
  String get varKey => 'المفتاح';

  @override
  String get varValue => 'القيمة';

  @override
  String get isSecret => 'سرّي (لا يُصدَّر أبداً)';

  @override
  String get secretExportNote => 'القيم السرّية مستثناة من التصدير.';

  @override
  String get searchHint => 'ابحث بالاسم…';

  @override
  String get filterTab => 'التبويب الرئيسي';

  @override
  String get filterSub => 'التبويب الفرعي';

  @override
  String get filterSection => 'القسم';

  @override
  String get filterStatus => 'الحالة';

  @override
  String get allOption => 'الكل';

  @override
  String get noResults => 'لا نتائج مطابقة';

  @override
  String resultsCount(int count) {
    return '$count نتيجة';
  }

  @override
  String get mainTitleLabel => 'العنوان الرئيسي (رأس الصفحة)';

  @override
  String get mainTitleHint => 'حتى 60 حرفاً';

  @override
  String get themes => 'الثيمات';

  @override
  String get language => 'اللغة';

  @override
  String get dataSection => 'البيانات';

  @override
  String get exportData => 'تصدير البيانات (JSON)';

  @override
  String get importData => 'استيراد البيانات (JSON)';

  @override
  String get importStrategy => 'استراتيجية الاستيراد';

  @override
  String get strategyReplace => 'استبدال كل شيء';

  @override
  String get strategyMerge => 'دمج مع البيانات الحالية';

  @override
  String importPreview(
    int nodes,
    int links,
    int notes,
    int emails,
    int subs,
    int platforms,
    int variables,
    int alerts,
  ) {
    return '$nodes عقدة، $links رابط، $notes ملاحظة، $emails بريد، $subs اشتراك، $platforms منصة، $variables متغير، $alerts تنبيه';
  }

  @override
  String get exportDone => 'اكتمل التصدير بنجاح';

  @override
  String get importDone => 'اكتمل الاستيراد بنجاح';

  @override
  String get dataError => 'فشلت العملية. حاول مجدداً.';

  @override
  String get trashEmpty => 'سلة المحذوفات فارغة';

  @override
  String get trashAutoPurge => 'تُحفظ العناصر 30 يوماً ثم تُحذف نهائياً.';

  @override
  String get purgeNow => 'إفراغ السلة الآن';

  @override
  String get purgeConfirm => 'حذف كل محتويات السلة نهائياً؟ لا يمكن التراجع.';

  @override
  String get restoreNode => 'استرجاع';

  @override
  String get deleteForever => 'حذف نهائي';

  @override
  String get accountSection => 'الحساب';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get analyticsSection => 'التحليلات';

  @override
  String get analyticsDesc =>
      'مشاركة أحداث استخدام مجهولة محدودة (تثبيت، أول مشروع، بدء تجربة، شراء، عدد المشاريع النشطة). لا يغادر أي محتوى جهازك أبداً.';

  @override
  String get analyticsOn => 'مفعّلة';

  @override
  String get analyticsOff => 'معطّلة';

  @override
  String get aboutSection => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get alertsCenter => 'مركز التنبيهات';

  @override
  String get upcoming => 'قادمة';

  @override
  String get fired => 'انطلقت';

  @override
  String get alertDisabled => 'معطّل';

  @override
  String get noAlerts => 'لا تنبيهات بعد';

  @override
  String get alertTitleLabel => 'عنوان التنبيه';

  @override
  String get alertDateTime => 'التاريخ والوقت';

  @override
  String reminderBefore(int min) {
    return 'تذكير قبل $min دقيقة';
  }

  @override
  String get reminderNone => 'بلا تذكير مسبق';

  @override
  String get notifPermissionDenied =>
      'رُفض إذن الإشعارات — لن تظهر التنبيهات. فعّله من إعدادات النظام.';

  @override
  String get featureLocked => 'انتهت التجربة — رقِّ للمتابعة.';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get nameTooLong => 'الاسم طويل جداً';

  @override
  String get urlInvalid => 'أدخل رابطاً صالحاً';

  @override
  String get emailInvalid => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get passwordShort => '8 أحرف على الأقل';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get unexpectedError => 'حدث خطأ ما. حاول مجدداً.';

  @override
  String get openNode => 'فتح';

  @override
  String get items => 'العناصر';

  @override
  String get emptyState => 'لا شيء هنا بعد — استخدم زر + للإنشاء';

  @override
  String noteOf(int index, int total) {
    return 'ملاحظة $index من $total';
  }

  @override
  String get theme1 => 'أزرق المبرمج';

  @override
  String get theme2 => 'أخضر الطرفية';

  @override
  String get theme3 => 'بنفسجي النيون';

  @override
  String get theme4 => 'برتقالي الغروب';

  @override
  String get theme5 => 'قرمزي الليل';

  @override
  String get theme6 => 'سماوي المحيط';

  @override
  String get theme7 => 'فضي المعدن';

  @override
  String get theme8 => 'ذهبي منتصف الليل';
}
