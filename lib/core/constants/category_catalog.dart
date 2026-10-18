/// v2.0 (D-023) — the 40 fixed entries of the 50-category catalog.
/// Fixed names are localized here in code (not the DB): the DB stores the
/// English seed only as a fallback. Numbers 41..50 are the per-profile
/// editable entries (D-023) and live in the Categories table only.
///
/// The internal number is intentionally hidden from the UI — users only see
/// display names.
class CategoryCatalog {
  CategoryCatalog._();

  /// (english, arabic) display pairs, indexed by number-1 (1..40).
  static const List<(String, String)> fixed = [
    ('Frontend', 'الواجهات الأمامية'),
    ('Backend', 'الواجهات الخلفية'),
    ('Mobile', 'تطبيقات الجوال'),
    ('DevOps', 'ديف أوبس'),
    ('Databases', 'قواعد البيانات'),
    ('APIs', 'واجهات برمجية'),
    ('Networking', 'الشبكات'),
    ('Security', 'الأمن والحماية'),
    ('Testing', 'الاختبارات'),
    ('AI & ML', 'الذكاء الاصطناعي'),
    ('Data Science', 'علم البيانات'),
    ('Algorithms', 'الخوارزميات'),
    ('Snippets', 'مقتطفات الكود'),
    ('Learning', 'التعلم'),
    ('Courses', 'الدورات'),
    ('Books', 'الكتب'),
    ('Certificates', 'الشهادات'),
    ('Tutorials', 'الشروحات'),
    ('Clients', 'العملاء'),
    ('Meetings', 'الاجتماعات'),
    ('Invoices', 'الفواتير'),
    ('Finance', 'المالية'),
    ('Marketing', 'التسويق'),
    ('Design', 'التصميم'),
    ('UI / UX', 'واجهة وتجربة المستخدم'),
    ('Research', 'الأبحاث'),
    ('Ideas', 'الأفكار'),
    ('Tasks', 'المهام'),
    ('Bugs', 'الأخطاء'),
    ('Features', 'الميزات'),
    ('Releases', 'الإصدارات'),
    ('Documentation', 'التوثيق'),
    ('Tools', 'الأدوات'),
    ('Scripts', 'السكربتات'),
    ('Repos', 'المستودعات'),
    ('Servers', 'الخوادم'),
    ('Domains', 'النطاقات'),
    ('Hosting', 'الاستضافة'),
    ('Licenses', 'التراخيص'),
    ('Archives', 'الأرشيف'),
  ];

  /// Editable range 41..50 (10 entries per profile).
  static const int fixedCount = 40;
  static const int totalCount = 50;
}
