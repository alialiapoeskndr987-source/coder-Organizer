/// Domain enums shared across layers (UI imports without Drift dependency).
/// v2.0 (D-027) — `item` completes the free tree: projects (and items
/// themselves) may nest arbitrary item children at any depth.
enum NodeType { mainTab, subTab, section, project, item }

enum NodeTemplate { client, personal, subscription, quickNote, custom }

enum NodeStatus { active, archived }

enum LinkCategory { repository, dashboard, website, store, other }

enum BillingCycle { monthly, yearly, lifetime, custom }

enum SubStatus { active, cancelled, expired }

enum ImportStrategy { replace, merge }

enum TrialStatus { active, expired }

enum PurchaseState { unknown, purchased, notPurchased, pending }

/// v1.23 — user-selectable ordering for tree browser & search results.
enum NodeSort { manual, nameAZ, newest, oldest }
